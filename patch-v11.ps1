# ==================================================================
#  bulk-write.html  v10 -> v11  패치
#  - 사진 업로드 직전 자동 압축 (17MB -> 1~2MB)
#  - 업로드/저장 fetch 자동 재시도 (Failed to fetch 복구)
#  - 사진 업로드 사이 짧은 텀 (rate limit 회피)
#  줄바꿈/공백에 의존하지 않는 안전 패치
# ==================================================================
$ErrorActionPreference = "Stop"
$file = "C:\Users\USER\florix-studio\public\admin\bulk-write.html"

if(!(Test-Path $file)){ Write-Host "X 파일 없음: $file" -ForegroundColor Red; exit 1 }

# 백업
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
Copy-Item $file "$file.backup-$stamp" -Force
Write-Host "백업: $file.backup-$stamp" -ForegroundColor Cyan

$html = [System.IO.File]::ReadAllText($file)

if($html.Contains("compressImage")){
  Write-Host "이미 패치됨 (compressImage 존재). 중단." -ForegroundColor Yellow
  exit 0
}

# ---- 패치 1: 압축/재시도 함수 추가 (fileToBase64 앞에 삽입) ----
$inject = @"
// ===== v11: 이미지 압축 =====
function compressImage(file,maxDim,quality){
  maxDim=maxDim||1600;quality=quality||0.82;
  return new Promise(function(resolve){
    if(!file||!file.type||!file.type.startsWith('image/')){resolve(file);return;}
    var reader=new FileReader();
    reader.onload=function(e){
      var img=new Image();
      img.onload=function(){
        var width=img.width,height=img.height;
        var tooBig=file.size>2*1024*1024;
        if(width<=maxDim&&height<=maxDim&&!tooBig){resolve(file);return;}
        if(width>height){if(width>maxDim){height=Math.round(height*maxDim/width);width=maxDim;}}
        else{if(height>maxDim){width=Math.round(width*maxDim/height);height=maxDim;}}
        var canvas=document.createElement('canvas');
        canvas.width=width;canvas.height=height;
        canvas.getContext('2d').drawImage(img,0,0,width,height);
        canvas.toBlob(function(blob){
          if(!blob||blob.size>=file.size){resolve(file);return;}
          var newName=file.name.replace(/\.(png|webp|heic|heif)$/i,'.jpg');
          resolve(new File([blob],newName,{type:'image/jpeg',lastModified:Date.now()}));
        },'image/jpeg',quality);
      };
      img.onerror=function(){resolve(file);};
      img.src=e.target.result;
    };
    reader.onerror=function(){resolve(file);};
    reader.readAsDataURL(file);
  });
}
function sleep(ms){return new Promise(function(r){setTimeout(r,ms);});}
// ===== v11: fetch 재시도 =====
async function fetchWithRetry(url,options,maxRetries){
  maxRetries=(maxRetries===undefined)?3:maxRetries;
  var lastErr=null;
  for(var attempt=0;attempt<=maxRetries;attempt++){
    try{
      var res=await fetch(url,options);
      if((res.status===403||res.status===429||res.status>=500)&&attempt<maxRetries){
        await sleep(1000*Math.pow(2,attempt));continue;
      }
      return res;
    }catch(e){
      lastErr=e;
      if(attempt<maxRetries){await sleep(1000*Math.pow(2,attempt));continue;}
      throw lastErr;
    }
  }
  if(lastErr)throw lastErr;
}
function fileToBase64(file){
"@

$anchor1 = "function fileToBase64(file){"
if(-not $html.Contains($anchor1)){ Write-Host "X 패치1 앵커 없음" -ForegroundColor Red; exit 1 }
$idx = $html.IndexOf($anchor1)
$html = $html.Substring(0,$idx) + $inject + $html.Substring($idx + $anchor1.Length)
Write-Host "패치1: 압축/재시도 함수 추가" -ForegroundColor Green

# ---- 패치 2: ghGetFile / ghPutFile 의 await fetch( -> await fetchWithRetry( ----
# 두 군데뿐. 단순 치환.
$before2 = "const res=await fetch(url,{"
$count2 = ([regex]::Matches($html,[regex]::Escape($before2))).Count
$html = $html.Replace($before2,"const res=await fetchWithRetry(url,{")
Write-Host "패치2: GitHub 호출 $count2 곳에 재시도 연결" -ForegroundColor Green

# ---- 패치 3: 업로드 루프 압축 적용 ----
$before3 = "const b64=await fileToBase64(b.file);"
$after3  = "const compFile=await compressImage(b.file);const b64=await fileToBase64(compFile);"
if($html.Contains($before3)){
  $html = $html.Replace($before3,$after3)
  Write-Host "패치3: 본문 사진 압축 적용" -ForegroundColor Green
}else{
  Write-Host "! 패치3 앵커 못 찾음" -ForegroundColor Yellow
}

# 대표 사진도 압축
$before3t = "const b64=await fileToBase64(thumbOverride.file);"
$after3t  = "const compFile=await compressImage(thumbOverride.file);const b64=await fileToBase64(compFile);"
if($html.Contains($before3t)){
  $html = $html.Replace($before3t,$after3t)
  Write-Host "패치3t: 대표 사진 압축 적용" -ForegroundColor Green
}

# ---- 패치 4: 업로드 성공 후 짧은 텀 ----
$before4 = "b.uploadedPath='/uploads/'+remoteName;"
$after4  = "b.uploadedPath='/uploads/'+remoteName;await sleep(400);"
if($html.Contains($before4)){
  $html = $html.Replace($before4,$after4)
  Write-Host "패치4: 호출 간 텀 추가" -ForegroundColor Green
}

# 버전 라벨 변경
$html = $html.Replace("v10 안전 발행","v11 안전 발행")

# 저장 (UTF-8 BOM 없이)
$utf8 = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($file,$html,$utf8)

Write-Host "`n=== 패치 완료 ===" -ForegroundColor Cyan
$check = [System.IO.File]::ReadAllText($file)
if($check.Contains("compressImage")){Write-Host "OK compressImage" -ForegroundColor Green}
if($check.Contains("fetchWithRetry")){Write-Host "OK fetchWithRetry" -ForegroundColor Green}
if($check.Contains("compressImage(b.file)")){Write-Host "OK 본문압축 연결" -ForegroundColor Green}
Write-Host "`n다음 단계: npm run build 로 확인 후 git push" -ForegroundColor Yellow

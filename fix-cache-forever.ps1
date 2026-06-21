# ==================================================================
#  플로릭스 캐시 문제 영구 해결 스크립트
#  - admin 페이지에 캐시 무력화 + 서비스워커 자동 제거 주입
#  - Cloudflare _headers 로 admin 경로 캐시 완전 차단
#  앞으로 코드 수정 -> 배포하면 즉시 반영됨 (캐시 비우기 불필요)
# ==================================================================
$ErrorActionPreference = "Stop"
$root = "C:\Users\USER\florix-studio"
Set-Location $root

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host " 플로릭스 캐시 영구 해결 시작" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

# ---- 0. 백업 ----
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backupDir = "$root\_cachefix-backup-$stamp"
New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
Copy-Item "$root\public\admin" "$backupDir\admin" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "백업 완료: $backupDir" -ForegroundColor Green

# ---- 1. admin 폴더의 모든 html 파일에 캐시킬러 주입 ----
$cacheKiller = @"
<!-- CACHE-KILLER v1: 이 페이지는 절대 캐시되면 안 됨 (관리 페이지) -->
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="0">
<script>
// 기존에 박힌 서비스워커 전부 제거 (옛 파일 캐시 원인 제거)
if('serviceWorker' in navigator){
  navigator.serviceWorker.getRegistrations().then(function(rs){
    for(var i=0;i<rs.length;i++){rs[i].unregister();}
  });
}
// 캐시 스토리지도 비움
if(window.caches&&caches.keys){
  caches.keys().then(function(keys){keys.forEach(function(k){caches.delete(k);});});
}
</script>
<!-- /CACHE-KILLER -->
"@

$adminFiles = Get-ChildItem "$root\public\admin" -Filter "*.html" -File -Recurse
$injected = 0
foreach($f in $adminFiles){
  $html = [System.IO.File]::ReadAllText($f.FullName)
  if($html.Contains("CACHE-KILLER v1")){
    Write-Host "  - 이미 적용됨: $($f.Name)" -ForegroundColor DarkGray
    continue
  }
  # <head> 바로 다음에 삽입 (없으면 맨 앞)
  $idx = $html.IndexOf("<head>")
  if($idx -ge 0){
    $insertAt = $idx + "<head>".Length
    $html = $html.Substring(0,$insertAt) + "`n" + $cacheKiller + $html.Substring($insertAt)
  }else{
    $html = $cacheKiller + $html
  }
  $utf8 = New-Object System.Text.UTF8Encoding $false
  [System.IO.File]::WriteAllText($f.FullName,$html,$utf8)
  Write-Host "  + 주입 완료: $($f.Name)" -ForegroundColor Green
  $injected++
}
Write-Host "캐시킬러 주입: $injected 개 파일" -ForegroundColor Green

# ---- 2. Cloudflare _headers 파일 (admin 경로 캐시 차단) ----
$headersPath = "$root\public\_headers"
$headerRule = @"
# admin 페이지는 절대 캐시하지 않음 (항상 최신)
/admin/*
  Cache-Control: no-store, no-cache, must-revalidate, max-age=0
  Pragma: no-cache
  Expires: 0
"@

if(Test-Path $headersPath){
  $existing = [System.IO.File]::ReadAllText($headersPath)
  if($existing.Contains("/admin/*")){
    Write-Host "_headers 에 admin 규칙 이미 있음" -ForegroundColor DarkGray
  }else{
    $combined = $existing.TrimEnd() + "`n`n" + $headerRule + "`n"
    $utf8 = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($headersPath,$combined,$utf8)
    Write-Host "_headers 에 admin 규칙 추가 (기존 파일 유지)" -ForegroundColor Green
  }
}else{
  $utf8 = New-Object System.Text.UTF8Encoding $false
  [System.IO.File]::WriteAllText($headersPath,$headerRule + "`n",$utf8)
  Write-Host "_headers 파일 새로 생성" -ForegroundColor Green
}

# ---- 3. 빌드 테스트 ----
Write-Host "`n빌드 테스트 중..." -ForegroundColor Cyan
$buildOutput = & npm run build 2>&1 | Out-String
if($buildOutput -match "Complete!" -or $buildOutput -match "built in"){
  Write-Host "빌드 성공" -ForegroundColor Green
}else{
  Write-Host "빌드 결과 확인 필요:" -ForegroundColor Yellow
  Write-Host ($buildOutput | Select-Object -Last 20)
}

# ---- 4. 검증 ----
Write-Host "`n=== 검증 ===" -ForegroundColor Cyan
$bw = [System.IO.File]::ReadAllText("$root\public\admin\bulk-write.html")
if($bw.Contains("CACHE-KILLER v1")){Write-Host "OK bulk-write 캐시킬러 적용됨" -ForegroundColor Green}
if($bw.Contains("compressImage")){Write-Host "OK bulk-write v11 압축 유지됨" -ForegroundColor Green}
if(Test-Path $headersPath){Write-Host "OK _headers 존재" -ForegroundColor Green}

Write-Host "`n다음 단계: git add -A; git commit -m 'fix: 캐시 영구 해결'; git push" -ForegroundColor Yellow

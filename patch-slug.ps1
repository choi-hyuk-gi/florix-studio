# ==================================================================
#  [slug].astro 텍스트 렌더링 보강
#  - **볼드** -> <strong> 변환
#  - 줄바꿈(\n) 살리기
#  - 이미 <p>나 <br> 같은 HTML이면 그대로 둠 (bulk-write 정상 글 보호)
# ==================================================================
$ErrorActionPreference = "Stop"
$file = "C:\Users\USER\florix-studio\src\pages\works\[slug].astro"
$f = Get-ChildItem -LiteralPath "C:\Users\USER\florix-studio\src\pages\works" -Filter "*.astro" | Where-Object { $_.Name -like "*slug*" }
$file = $f.FullName

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
Copy-Item -LiteralPath $file "$file.backup-$stamp" -Force
Write-Host "백업: $file.backup-$stamp" -ForegroundColor Cyan

$content = [System.IO.File]::ReadAllText($file)

if($content.Contains("formatBlockContent")){
  Write-Host "이미 패치됨" -ForegroundColor Yellow
  exit 0
}

# 1. frontmatter(--- ... ---) 안에 헬퍼 함수 추가
# 텍스트를 받아서: HTML 태그가 있으면 그대로, 없으면 **볼드**+줄바꿈 변환
$helper = @'

// 텍스트 블록 정렬: **볼드**->strong, 줄바꿈->문단/<br> (HTML이면 그대로)
function formatBlockContent(raw) {
  if (!raw) return '';
  const hasHtml = /<(p|br|div|strong|b|h[1-6]|ul|li|em)\b/i.test(raw);
  if (hasHtml) return raw; // bulk-write가 만든 정상 HTML은 건드리지 않음
  // 일반 텍스트: **볼드** 변환
  let t = raw.replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>');
  // 빈 줄(\n\n)로 문단 분리, 단일 \n은 <br>
  const paras = t.split(/\n{2,}/).map(p => p.trim()).filter(Boolean);
  return paras.map(p => '<p>' + p.replace(/\n/g, '<br>') + '</p>').join('');
}
'@

# frontmatter 끝(--- 두번째) 직전에 헬퍼 삽입
# Astro 파일은 맨 위 --- ... --- 가 frontmatter
$idx1 = $content.IndexOf("---")
$idx2 = $content.IndexOf("---", $idx1 + 3)
if($idx2 -lt 0){ Write-Host "X frontmatter 못 찾음" -ForegroundColor Red; exit 1 }

$content = $content.Substring(0, $idx2) + $helper + "`n" + $content.Substring($idx2)
Write-Host "1. 헬퍼 함수 삽입 완료" -ForegroundColor Green

# 2. set:html={block.content} -> set:html={formatBlockContent(block.content)}
$old = 'set:html={block.content}'
$new = 'set:html={formatBlockContent(block.content)}'
if(-not $content.Contains($old)){ Write-Host "X 렌더링 라인 못 찾음" -ForegroundColor Red; exit 1 }
$content = $content.Replace($old, $new)
Write-Host "2. 렌더링 라인 교체 완료" -ForegroundColor Green

# 저장 (BOM 없는 UTF-8)
$enc = [System.Text.UTF8Encoding]::new($false)
[System.IO.File]::WriteAllText($file, $content, $enc)
Write-Host "[slug].astro 패치 완료" -ForegroundColor Green

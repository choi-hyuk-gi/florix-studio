# ==================================================================
#  증평 글 본문을 HTML로 깨끗하게 재발행 (** 제거, 예쁜 정렬)
#  사진 14장은 이미 GitHub에 있음 -> 텍스트만 정리해서 .md 덮어쓰기
# ==================================================================
$ErrorActionPreference = "Stop"
Set-Location "C:\Users\USER\florix-studio"
git pull | Out-Null

$path = "src\content\works\2026-06-16-증평-카페-옥상-시공기.md"

# 본문을 HTML <p>로 작성 (** 없음, 문단 구분 깔끔)
$md = @'
---
title: "증평 카페 옥상 시공기"
location: "증평"
category: "카페"
date: 2026-06-16
thumbnail: "/uploads/1782035219802_thumb_중1.jpg"
duration: "1일 완공"
area: 105
featured: false
blocks:
  - type: text
    content: "<p>안녕하세요, 플로릭스 스튜디오입니다 🙂</p><p>이번 현장은 증평의 한 카페 옥상이에요. 용도변경을 마치고, 이제 진짜 '쓰는 공간'으로 다시 태어날 자리죠.</p>"
  - type: image
    src: "/uploads/1782035124491_0_전5.jpg"
  - type: text
    content: "<p>처음 올라왔을 때 가장 먼저 눈에 들어온 건 이 뷰였어요. 삼면이 통창이라 산 풍경이 그대로 들어오는, 옥상이 가진 그대로의 매력이 분명한 공간이었습니다.</p><p>다만 바닥은 손이 좀 필요한 상태였어요.</p>"
  - type: image
    src: "/uploads/1782035131158_1_전1.jpg"
  - type: text
    content: "<p>기존에 깔려 있던 우레탄이 들뜨고, 군데군데 오염도 보였습니다. 이 상태 그대로 위에 뭘 올린다는 건 의미가 없어요. 결국 바닥이 받쳐주지 않으면 어떤 마감도 오래가지 못하거든요.</p><p>그래서 첫 단계는 명확합니다. <strong>기존 우레탄을 싹 걷어내는 것.</strong></p>"
  - type: image
    src: "/uploads/1782035137673_2_전3.jpg"
  - type: text
    content: "<p>저희가 쓰는 건 그라인더와 집진기를 연결한 방식이에요. 바닥을 깎아내면서 분진은 그 자리에서 바로 빨아들이기 때문에, 현장이 비교적 깔끔하게 유지됩니다.</p><p>📌 한 가지 미리 말씀드리면, 이번 단계는 <strong>우레탄 제거</strong>까지입니다. 콘크리트 폴리싱은 아직 들어가지 않았어요. 바닥을 먼저 깨끗한 '맨살' 상태로 만들어두는 게 우선이거든요.</p>"
  - type: image
    src: "/uploads/1782035144297_3_중1.jpg"
  - type: text
    content: "<h2>우레탄, 이렇게 걷어냅니다</h2><p>대형 그라인더로 바닥을 한 면씩 갈아내면, 오래 붙어 있던 우레탄 도막이 떨어져 나옵니다. 한쪽엔 작업하면서 나온 잔재를 자루에 담아두고요.</p>"
  - type: image
    src: "/uploads/1782035151659_4_중2.jpg"
  - type: text
    content: "<p>가까이서 보면 이렇게 우레탄이 잘게 일어나면서 바닥에서 분리됩니다. 한 번에 매끈하게 벗겨지는 게 아니라, 갈면서 도막을 조금씩 깨서 떼어내는 작업이에요.</p>"
  - type: image
    src: "/uploads/1782035160142_5_중3.jpg"
  - type: text
    content: "<p>갈려 나간 자리를 보면 기존 도막과 그 아래 콘크리트 경계가 드러나기 시작해요 😊 이 경계를 따라 꼼꼼하게 밀어줘야 면이 고르게 정리됩니다.</p>"
  - type: image
    src: "/uploads/1782035167643_6_중8.jpg"
  - type: text
    content: "<p>저희가 직접 장비를 잡고, 면을 따라가며 한 구역씩 정리해 나갑니다. 그라인더와 집진기를 함께 돌리기 때문에 분진은 그 자리에서 바로 빨려 들어가, 현장이 비교적 깔끔하게 유지돼요.</p>"
  - type: image
    src: "/uploads/1782035175285_7_모서리작업1.jpg"
  - type: text
    content: "<p>큰 장비가 닿지 않는 벽 모서리와 가장자리는 손그라인더로 따로 잡아줍니다.</p><p>사실 마감 퀄리티는 이런 디테일에서 갈려요. 구석까지 빠짐없이 갈아내야 나중에 면이 들뜨거나 지저분해지지 않거든요.</p>"
  - type: image
    src: "/uploads/1782035182322_8_모서리작업4.jpg"
  - type: text
    content: "<p>이렇게 구석구석 손으로 마무리하면, 가려져 있던 콘크리트 본 바닥이 제 모습을 드러냅니다 👍</p>"
  - type: image
    src: "/uploads/1782035189921_9_후1.jpg"
  - type: text
    content: "<h2>우레탄 제거 완료</h2><p>오래된 우레탄으로 덮여 있던 옥상 바닥이, 이렇게 말끔한 콘크리트 면으로 돌아왔어요. 들뜨고 오염됐던 처음 상태를 떠올리면 확실히 달라진 게 보이실 거예요.</p>"
  - type: image
    src: "/uploads/1782035197473_10_후2.jpg"
  - type: text
    content: "<p>가까이서 보면 콘크리트 속에 박힌 골재 입자까지 자연스럽게 드러납니다. 도막을 걷어내고 본연의 면을 살렸기 때문에 가능한 질감이에요.</p>"
  - type: image
    src: "/uploads/1782035203668_11_후4.jpg"
  - type: text
    content: "<p>큰 장비가 닿지 않는 벽 모서리와 기둥 주변까지 손으로 꼼꼼하게 정리했습니다. 이런 구석 디테일이 결국 전체 마감의 완성도를 좌우해요.</p>"
  - type: image
    src: "/uploads/1782035209694_12_후12.jpg"
  - type: text
    content: "<p>삼면 통창으로 산 풍경이 들어오는 이 공간, 바닥이 정리되니 분위기가 한층 차분해졌습니다.</p>"
  - type: image
    src: "/uploads/1782035215303_13_후3.jpg"
  - type: text
    content: "<p>📌 다시 한번 안내드리면, 이번 현장은 <strong>우레탄 제거와 면갈이</strong>까지 진행한 단계예요. 콘크리트 폴리싱(광택 폴리싱)은 들어가지 않았습니다.</p><h2>왜 면갈이가 중요할까요?</h2><p>어떤 마감을 올리든, 결국 바닥이 받쳐주지 않으면 오래가지 못합니다. 도막이 남아 있거나 면이 고르지 않으면 위에 올라가는 폴리싱도, 에폭시도 들뜨거나 갈라지기 쉬워요. 그래서 저희는 이 면갈이 단계를 가장 기본이자 가장 중요한 공정으로 봅니다.</p><p>증평 카페 옥상, 깨끗하게 정리해 드렸습니다. 다음 단계가 필요하시거나 비슷한 공간을 고민 중이시라면 언제든 편하게 문의 주세요 🙂</p><p><strong>플로릭스 스튜디오 | 콘크리트 폴리싱 전문</strong><br>홈페이지 → https://florixstudio.co.kr/<br>블로그 → https://blog.naver.com/florix_studios<br>인스타그램 → https://www.instagram.com/florix_studios<br>010-8930-2266</p>"
---
'@

$enc = [System.Text.UTF8Encoding]::new($false)
$full = "C:\Users\USER\florix-studio\" + $path
[System.IO.File]::WriteAllText($full, $md, $enc)
Write-Host "✅ 증평 글 본문 HTML로 재작성 완료" -ForegroundColor Green

Write-Host "빌드 테스트 중..." -ForegroundColor Cyan
$build = & npm run build 2>&1 | Out-String
if($build -match "Complete!"){
  Write-Host "✅ 빌드 성공" -ForegroundColor Green
}else{
  Write-Host "⚠️ 빌드 확인 필요:" -ForegroundColor Yellow
  Write-Host ($build | Select-Object -Last 15)
  exit 1
}

git add -A
git commit -m "증평 글 본문 정리 + [slug] 렌더링 보강"
git push
Write-Host "`n🎉 완료! 2-3분 후 사이트 반영" -ForegroundColor Green

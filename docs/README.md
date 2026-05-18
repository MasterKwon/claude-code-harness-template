# docs/ 폴더 구조

각 스킬이 생성하고 읽는 문서의 위치를 정의합니다.

## 디렉터리 구조

```
docs/
├── 00.input/               # 원본 요구사항 자료 (사용자가 넣는 파일)
│   ├── extracted/          # extract.py 변환 결과 (자동 생성)
│   ├── grill-result.md     # /grill-me 인터뷰 결과 (선택, v2.2.0)
│   └── README.md           # 사용 안내
│
├── 01.analyze/             # 분석 단계 산출물
│   ├── requirements.md     # 요구사항 정의서 (초안)
│   ├── asis.md             # AS-IS 현황 분석 (초안)
│   ├── gap.md              # GAP 분석 (초안)
│   └── reviewed/           # 검토·승인 완료본 (다음 단계가 읽는 파일)
│       ├── requirements.md
│       ├── asis.md
│       └── gap.md
│
├── 02.design/              # 설계 단계 산출물
│   ├── design-prompts.md   # Claude Design 입력용 프롬프트 (선택, v2.2.0)
│   ├── db.md               # DB 설계 (초안)
│   ├── screen.md           # 화면 설계 (초안)
│   ├── api.md              # API 설계 (초안)
│   ├── tc/
│   │   └── uat-checklist.md  # UAT 체크리스트 (design-tc 산출물)
│   └── reviewed/           # 검토·승인 완료본 (다음 단계가 읽는 파일)
│       ├── db.md
│       ├── screen.md
│       └── api.md
│
├── 03.build/               # 구현 단계 산출물
│   └── reviewed/
│
├── 04.review/              # 코드 리뷰 산출물
│   ├── report.md           # 리뷰 보고서 (초안)
│   └── reviewed/
│       └── report.md
│
├── 05.test/                # 테스트 단계 산출물
│   ├── report-db.md            # DB 테스트 보고서 (초안)
│   ├── report-api.md           # API 테스트 보고서 (초안)
│   ├── report-screen.md        # 화면 테스트 보고서 (초안)
│   ├── report-e2e.md           # E2E 테스트 보고서 (초안)
│   ├── ui-test-chrome.md       # Chrome 사이드패널 지시문 (v2.2.0, AI 생성)
│   ├── ui-test-chrome.xlsx     # QA 체크리스트 템플릿 (v2.2.0, AI 생성)
│   ├── ui-test-chrome_result.xlsx  # QA 기입 결과본 (v2.2.0, QA 수동 추가)
│   └── reviewed/               # 테스트 통과본 (ship이 읽는 파일)
│
└── 06.ship/                # 배포 단계 산출물
    └── checklist.md        # 배포 체크리스트
```

## 워크플로우

```
[초안 생성]          [검토·승인]          [다음 단계]
스킬 실행      →    reviewed/ 복사   →    다음 스킬이 읽음
(자동)              (사용자 확인)          (자동)
```

## 스킬 ↔ 문서 매핑

| 스킬 | 읽는 파일 | 생성하는 파일 |
|------|----------|-------------|
| /grill-me *(v2.2.0, 선택)* | 사용자 대화 (00.input/* 있으면 참고) | 00.input/grill-result.md |
| /analyze-requirements | 00.input/* (grill-result.md 포함) | 01.analyze/requirements.md |
| /analyze-asis | 프로젝트 소스코드 | 01.analyze/asis.md |
| /analyze-gap | reviewed/requirements.md, reviewed/asis.md | 01.analyze/gap.md |
| /design-prompt-gen *(v2.2.0, 선택)* | reviewed/requirements.md, reviewed/gap.md | 02.design/design-prompts.md |
| /design-db | reviewed/requirements.md, reviewed/gap.md | 02.design/db.md |
| /design-screen | reviewed/requirements.md, reviewed/gap.md | 02.design/screen.md |
| /design-api | reviewed/db.md, reviewed/screen.md | 02.design/api.md |
| /design-tc | reviewed/screen.md, api.md, db.md | 02.design/tc/uat-checklist.md |
| /build-db | reviewed/db.md | 소스코드 직접 생성 |
| /build-api | reviewed/api.md | 소스코드 직접 생성 |
| /build-screen | reviewed/screen.md, reviewed/api.md | 소스코드 직접 생성 |
| /review-all | 소스코드 전체 | 04.review/report.md |
| /test-db | reviewed/db.md, 소스코드 | 05.test/report-db.md |
| /test-api | reviewed/api.md, 소스코드 | 05.test/report-api.md |
| /test-screen | reviewed/screen.md, 소스코드 | 05.test/report-screen.md |
| /test-e2e | 소스코드 전체 | 05.test/report-e2e.md |
| /test-ui-chrome *(v2.2.0)* | 02.design/tc/uat-checklist.md | 05.test/ui-test-chrome.md + .xlsx |
| /ship | 05.test/reviewed/* | 06.ship/checklist.md |

# docs/ 폴더 구조

각 스킬이 생성하고 읽는 문서의 위치를 정의합니다.

## 디렉터리 구조

```
docs/
├── 00.input/               # 원본 요구사항 자료 (사용자가 넣는 파일)
│   ├── extracted/          # extract.py 변환 결과 (자동 생성)
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
└── 02.design/              # 설계 단계 산출물
    ├── db.md               # DB 설계 (초안)
    ├── screen.md           # 화면 설계 (초안)
    ├── api.md              # API 설계 (초안)
    └── reviewed/           # 검토·승인 완료본 (다음 단계가 읽는 파일)
        ├── db.md
        ├── screen.md
        └── api.md
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
| /analyze-requirements | 00.input/* | 01.analyze/requirements.md |
| /analyze-asis | 프로젝트 소스코드 | 01.analyze/asis.md |
| /analyze-gap | reviewed/requirements.md, reviewed/asis.md | 01.analyze/gap.md |
| /design-db | reviewed/requirements.md, reviewed/gap.md | 02.design/db.md |
| /design-screen | reviewed/requirements.md, reviewed/gap.md | 02.design/screen.md |
| /design-api | reviewed/db.md, reviewed/screen.md | 02.design/api.md |
| /build-db | reviewed/db.md | 소스코드 직접 생성 |
| /build-api | reviewed/api.md | 소스코드 직접 생성 |
| /build-screen | reviewed/screen.md, reviewed/api.md | 소스코드 직접 생성 |

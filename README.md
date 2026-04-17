# Claude Code 프로젝트 템플릿

Next.js + MSA 기반 프로젝트를 위한 Claude Code 하네스 엔지니어링 템플릿.
요구사항 분석부터 배포까지 전체 SDLC를 슬래시 커맨드로 실행할 수 있습니다.

---

## 이 템플릿이 하는 일

1. **슬래시 커맨드로 SDLC 실행** — `/analyze-requirements`, `/design-api`, `/build-screen` 등
2. **품질 게이트 자동 검증** — 각 단계 완료 시 체크리스트 자동 검증 후 `reviewed/` 폴더로 승격
3. **기술 스택 자동 설정** — 9가지 선택만 하면 프로젝트 초기화 + 패키지 설치 자동 실행
4. **입력 파일 자동 전처리** — Excel, PPT, PDF, 이미지 등 다양한 형식의 요구사항 문서를 자동으로 읽어서 분석

---

## 디렉터리 구조

```
프로젝트 루트/
├── CLAUDE.md                    ← 프로젝트 컨텍스트 (기술 스택, 가이드라인)
├── README.md                    ← 이 파일
├── .claude/
│   ├── settings.json            ← 훅 설정 (파일 수정 시 TypeScript 자동 체크)
│   ├── hooks/
│   │   └── post-edit.sh         ← .ts/.tsx 수정 시 tsc --noEmit 자동 실행
│   ├── msa-skill.md             ← MSA 폴더 구조 / 서비스 간 통신 패턴 참조
│   ├── nextjs-skill.md          ← Next.js App Router 패턴 참조
│   ├── skills/                  ← 각 단계별 역할 프롬프트 (Claude가 읽는 파일)
│   └── commands/                ← 슬래시 커맨드 정의 파일
└── docs/
    ├── 00.input/                ← 요구사항 입력 파일 넣는 곳
    │   ├── extract.py           ← Excel/PPT/CSV 텍스트 추출 스크립트
    │   └── extracted/           ← 추출 결과 (자동 생성)
    ├── 01.analyze/              ← 분석 산출물
    │   └── reviewed/            ← 품질 게이트 통과한 파일
    ├── 02.design/               ← 설계 산출물
    │   └── reviewed/
    ├── 03.build/                ← 구현 완료 체크리스트
    │   └── reviewed/
    ├── 04.review/               ← 코드 리뷰 보고서
    │   └── reviewed/
    ├── 05.test/                 ← 테스트 보고서
    │   └── reviewed/
    └── 06.ship/                 ← 배포 체크리스트
```

---

## 빠른 시작

### 신규 프로젝트

```
1. 이 템플릿을 새 프로젝트 폴더에 복사
2. CLAUDE.md의 Working directory 경로 수정
3. Claude Code에서 /pipeline-full 실행
```

`/pipeline-full` 실행 시 흐름:

```
Phase 0  /project-setup       기술 스택 선택 + 패키지 자동 설치
Phase 1  /analyze-all         요구사항 / AS-IS / GAP 분석
Phase 2  /design-all          화면 / DB / API 설계
Phase 3  /build-all           DB / API / 화면 구현
Phase 4  /review-all          코드 품질 / 보안 / 성능 리뷰
Phase 5  /test-all            DB / API / 화면 / E2E 테스트
Phase 6  /ship                배포 체크리스트
```

각 Phase 사이에 사용자 확인이 있습니다. 자동으로 다음 단계로 넘어가지 않습니다.

### 기존 프로젝트 기능 추가/수정

```
Claude Code에서 /pipeline-change 실행
```

`/pipeline-change` 실행 시 흐름:

```
Phase 1  analyze-asis         기존 코드 파악 (먼저)
Phase 2  analyze-requirements 변경/추가할 기능 정의
Phase 3  analyze-gap          작업 범위 확정 ← 이후 단계의 기준
Phase 4  영향 범위만 설계      GAP에 없는 레이어는 건너뜀
Phase 5  영향 범위만 구현      GAP에 없는 코드는 건드리지 않음
Phase 6  review-all           변경 코드 + 기존 연결 지점 검토
Phase 7  테스트 + 회귀 테스트  새 기능 + 기존 기능 깨짐 여부
Phase 8  ship                 배포
```

---

## 요구사항 입력 방법

`docs/00.input/` 폴더에 파일을 넣고 분석을 시작합니다.

| 형식 | 처리 방법 |
|------|-----------|
| `.xlsx`, `.pptx`, `.csv` | `extract.py`가 텍스트 추출 (한글 CP949 자동 처리) |
| `.txt`, `.md` | 인코딩 자동 감지 후 읽기 |
| `.pdf`, 이미지 | Claude가 직접 읽기 |

최초 1회 라이브러리 설치:
```bash
pip install openpyxl python-pptx chardet
```

---

## 기술 스택 처리 방식

### 신규 프로젝트 — `/project-setup` 에서 선택

9가지 항목을 선택하면 자동으로 설정됩니다:

| 항목 | 선택지 |
|------|--------|
| 프로젝트 구조 | MSA / 모노리스 |
| 데이터베이스 | PostgreSQL / MySQL / MongoDB / SQLite |
| ORM | Prisma / TypeORM / Mongoose / Raw SQL |
| 인증 | JWT / NextAuth / 없음 |
| API 스타일 | REST / tRPC / GraphQL |
| 상태 관리 | TanStack Query / Zustand+TanStack / Redux / Context |
| 서비스 간 통신 | REST / Redis / RabbitMQ |
| 파일 업로드 | S3 / 로컬 / 없음 |
| 배포 방식 | Docker / Vercel / PM2 |

### 기존 프로젝트 — `/pipeline-change` 에서 자동 감지

사용자에게 스택을 묻지 않습니다. `analyze-asis`의 Step 0에서 프로젝트 파일을 직접 읽어 자동으로 확정합니다.

| 감지 파일 | 감지 정보 |
|-----------|-----------|
| `package.json` | ORM, 인증, 상태 관리, API 스타일, DB 드라이버 |
| `docker-compose.yml` | DB 종류, Redis, RabbitMQ, 서비스 목록/포트 |
| `prisma/schema.prisma` | DB provider |
| `.env` / `.env.example` | DB URL 형식, 서비스 URL |
| `tsconfig.json` | TypeORM 여부 (experimentalDecorators) |
| 디렉터리 구조 | MSA vs 모노리스 |

감지 후 `CLAUDE.md`의 Tech Stack 섹션을 자동 업데이트합니다.
불확실한 항목이 있을 때만 선택적으로 사용자에게 확인합니다.

---

### 신규 프로젝트 — 선택 항목

선택 후 자동 실행:
- `npx create-next-app` (프로젝트 생성)
- `npm install` (선택 패키지 설치)
- `.env.example` 생성
- `docker-compose.yml` 생성 (Docker 선택 시)
- `CLAUDE.md` Tech Stack 섹션 자동 업데이트

---

## 전체 커맨드 목록

### 파이프라인
| 커맨드 | 설명 |
|--------|------|
| `/pipeline-full` | 신규 프로젝트 전체 실행 (Phase 0~6) |
| `/pipeline-change` | 기존 프로젝트 기능 추가/수정 |
| `/project-setup` | 기술 스택 선택 + 프로젝트 초기화 |

### 분석
| 커맨드 | 산출물 |
|--------|--------|
| `/analyze-requirements` | `docs/01.analyze/requirements.md` |
| `/analyze-asis` | `docs/01.analyze/asis.md` |
| `/analyze-gap` | `docs/01.analyze/gap.md` |
| `/analyze-all` | 위 3개 순서대로 실행 |

### 설계
| 커맨드 | 산출물 |
|--------|--------|
| `/design-screen` | `docs/02.design/screen.md` |
| `/design-db` | `docs/02.design/db.md` |
| `/design-api` | `docs/02.design/api.md` |
| `/design-all` | 위 3개 순서대로 실행 |

### 구현
| 커맨드 | 설명 |
|--------|------|
| `/build-db` | DB 스키마 / 마이그레이션 구현 |
| `/build-api` | API 엔드포인트 구현 |
| `/build-screen` | 화면 / 컴포넌트 구현 |
| `/build-all` | 위 3개 순서대로 실행 |

### 리뷰
| 커맨드 | 산출물 |
|--------|--------|
| `/review-all` | `docs/04.review/report.md` (코드 품질 / 보안 / 성능) |

### 테스트
| 커맨드 | 산출물 |
|--------|--------|
| `/test-db` | `docs/05.test/report-db.md` |
| `/test-api` | `docs/05.test/report-api.md` |
| `/test-screen` | `docs/05.test/report-screen.md` |
| `/test-e2e` | `docs/05.test/report-e2e.md` |
| `/test-all` | 위 4개 순서대로 실행 |

### 배포
| 커맨드 | 산출물 |
|--------|--------|
| `/ship` | `docs/06.ship/checklist.md` |

### 보완 (`refine-*`)
문제 발생 시 특정 단계만 다시 실행합니다. 기존 산출물을 유지하면서 미진한 부분만 채웁니다.

```
/refine-analyze-requirements    /refine-design-screen    /refine-build-db
/refine-analyze-asis            /refine-design-db        /refine-build-api
/refine-analyze-gap             /refine-design-api       /refine-build-screen
                                /refine-review-all
/refine-test-db                 /refine-test-api
/refine-test-screen             /refine-test-e2e
/refine-ship
```

---

## 품질 게이트 — reviewed/ 승격 시스템

각 단계 완료 시 자동으로 체크리스트를 검증합니다.
모든 항목 통과 시 `reviewed/` 폴더로 복사되며, 다음 단계는 `reviewed/` 파일만 읽습니다.

```
docs/01.analyze/requirements.md
        ↓ 품질 게이트 통과
docs/01.analyze/reviewed/requirements.md  ← 다음 단계가 읽는 파일
```

미통과 항목이 있으면 해당 항목만 보완 후 재검증합니다.

---

## 문제 발생 시 롤백

`/pipeline-full` 또는 `/pipeline-change`의 롤백 맵을 참조합니다.

기본 원칙:
- 문제 발생 위치에서 원인 단계를 찾아 해당 `refine-*` 실행
- 그 단계 이후의 모든 산출물 재실행
- 롤백 범위가 2단계 이상이면 사용자에게 먼저 확인

---

## 요구사항 변경 발생 시

진행 중 요구사항이 바뀌는 경우 변경 범위에 따라 대응합니다:

| 변경 내용 | 조치 |
|-----------|------|
| 텍스트/레이블 수정 | 화면 구현만 재실행 |
| 필드 추가/삭제 | DB → API → Screen 순 재실행 |
| 기능 추가 | `/refine-analyze-requirements` 후 설계부터 재실행 |
| 기능 제거 | 영향받는 설계/구현 삭제 후 재검증 |

`docs/01.analyze/requirements.md` 하단의 변경 이력 섹션에 날짜/내용/영향 범위를 기록합니다.

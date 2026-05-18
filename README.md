# Claude Code Harness Engineering Template

Claude Code를 활용한 AI 주도 개발을 위한 템플릿입니다.
이 저장소를 클론하여 새 프로젝트의 시작점으로 사용합니다.

---

## 개념

```
이 템플릿 클론 → 새 프로젝트 디렉토리에서 /project-setup → 개발 시작
```

Claude Code의 slash command와 skill 파일을 통해 **분석 → 설계 → 구현 → 테스트 → 배포** 전 과정을 AI와 함께 진행합니다. 코드를 직접 작성하지 않아도 됩니다.

## 발표자료

개념과 파이프라인 전체 흐름을 슬라이드로 확인할 수 있습니다.

| 대상 | 파일 | 설명 |
|------|------|------|
| 1부 (체험형 30분) | [`docs/harness/presentation-intro.html`](docs/harness/presentation-intro.html) | 파이프라인 실습 데모 중심 |
| 2부 (스킬 만들기 30분) | [`docs/harness/presentation-intro2.html`](docs/harness/presentation-intro2.html) | 나만의 스킬 워크샵 |
| 3부 (심화) | [`docs/harness/presentation-intro3.html`](docs/harness/presentation-intro3.html) | 품질 게이트·롤백·커맨드 체계 |
| 4부 (운영 단계 10분) | [`docs/harness/presentation-intro4.html`](docs/harness/presentation-intro4.html) | CONTEXT 누적 · grill-task · 동적 Phase 흐름 |

---

## 시작하기

### 1. 클론

```bash
git clone https://github.com/MasterKwon/claude-code-harness-template.git my-project
cd my-project
```

### 2. 새 저장소로 초기화

```bash
rm -rf .git
git init
git checkout -b develop
```

### 3. 프로젝트 설정

Claude Code에서 실행:

```
/project-setup
```

기술 스택을 선택하면 자동으로 패키지 설치, 환경 변수, Docker 설정, CLAUDE.md가 완성됩니다.

---

## 기술 스택 선택 항목

`/project-setup` 실행 시 아래 항목을 선택합니다. ★ 는 추천 기본값입니다.

| 항목 | 선택지 |
|------|--------|
| 프로젝트 구조 | MSA ★ / 모노리스 |
| 데이터베이스 | PostgreSQL ★ / MySQL / MongoDB / SQLite |
| ORM | Prisma ★ / TypeORM / Mongoose / Raw SQL |
| 인증 | JWT ★ / NextAuth / 없음 |
| API 스타일 | REST ★ / tRPC / GraphQL |
| 상태 관리 | TanStack Query ★ / Zustand+TanStack / Redux / Context |
| 서비스 간 통신 | REST ★ / Redis / RabbitMQ |
| 파일 업로드 | 없음 ★ / S3 / 로컬 |
| 배포 방식 | Docker ★ / Vercel / PM2 |
| UI 라이브러리 | shadcn/ui ★ / MUI / Ant Design / Tailwind only |

---

## 개발 파이프라인

### 신규 프로젝트

```
/pipeline-full
```

| Phase | 명령 | 산출물 |
|-------|------|--------|
| 0 | `/project-setup` | 프로젝트 초기화, CLAUDE.md |
| 0.5 | `/grill-me` *(선택)* | `grill-result.md` — 요구사항 모호성 사전 제거 |
| 1 | `/analyze-all` | `requirements.md`, `asis.md`, `gap.md` |
| 1.7 | `/design-prompt-gen` *(선택)* | `design-prompts.md` — Claude Design 입력용 프롬프트 |
| 2 | `/design-all` + `/review-design` | `screen.md`, `db.md`, `api.md`, `uat-checklist.md` |
| 3 | `/build-all` + `/impact-check` | 소스코드, `impact-check.md` |
| 4 | `/review-all` | `review-report.md` |
| 5 | `/test-all` | `test-report-*.md`, `ui-test-chrome.md` + `.xlsx` (Chrome 사이드패널 지시문) |
| 5.5 | `/deploy-dev` | Dev 환경 배포, `06.deploy/deploy-dev.md` |
| 6 | UAT | `06.deploy/uat-result.md` — QA 담당자 수행 |
| 7 | `/deploy-prd` | 운영 배포 체크리스트, `06.deploy/deploy-prd.md` |

> Phase 0.5 / 1.7 은 v2.2.0에 추가된 **선택적 Bridge 단계**입니다. AI 산출물을 사람 작업(대화·시각 검토)과 잇는 단계로, 필요할 때만 실행합니다. 자세한 내용은 [`docs/harness/CHANGELOG.md`](docs/harness/CHANGELOG.md) 참고.

### 기존 프로젝트 유지보수 (오류수정 / 기능개선 / 내부 개선)

```
/pipeline-maintenance
```

WHY 정의 → AS-IS 분석 → GAP 확정 → 영향 범위만 설계·구현·테스트·배포합니다.

---

## 디렉토리 구조

```
.
├── CLAUDE.md                    # 프로젝트 컨텍스트 (기술 스택, 가이드라인)
├── .claude/
│   ├── commands/                # 슬래시 명령어 진입점
│   ├── skills/                  # 각 단계별 실행 로직
│   │   └── stacks/              # 기술스택별 패턴 파일
│   │       ├── arch/            # msa.md, monolith.md
│   │       ├── orm/             # prisma.md, typeorm.md, mongoose.md, raw-sql.md
│   │       ├── api-style/       # rest.md, trpc.md, graphql.md
│   │       ├── state/           # tanstack-query.md, zustand.md, redux.md
│   │       ├── framework/       # nextjs.md
│   │       └── ui/              # shadcn.md, mui.md, antd.md, tailwind-only.md
│   └── settings.json            # hooks 설정
└── docs/
    ├── 00.input/                # 요구사항 원본 자료 (여기에 파일 넣기)
    ├── 01.analyze/              # 분석 산출물
    ├── 02.design/               # 설계 산출물
    ├── 03.build/                # 구현 산출물 (impact-check.md)
    ├── 04.review/               # 리뷰 보고서
    ├── 05.test/                 # 테스트 보고서
    ├── 06.deploy/               # 배포 산출물 (deploy-dev, uat-result, deploy-prd)
    └── harness/                 # 하네스 가이드 문서
        ├── presentation-intro.html   # 발표자료 1부 — 체험형 실습
        ├── presentation-intro2.html  # 발표자료 2부 — 스킬 만들기
        ├── presentation-intro3.html  # 발표자료 3부 — 심화
        ├── presentation-intro4.html  # 발표자료 4부 — 운영 단계 (Knowledge Accretion)
        ├── onboarding.md             # 온보딩 가이드
        └── CHANGELOG.md              # 변경 이력
```

---

## Active Skills

`CLAUDE.md`의 `## Active Skills` 섹션이 현재 프로젝트의 기술스택을 정의합니다.
`/project-setup` 실행 시 선택에 따라 자동으로 채워집니다.

```markdown
## Active Skills
- framework: .claude/skills/stacks/framework/nextjs.md
- arch:      .claude/skills/stacks/arch/msa.md
- orm:       .claude/skills/stacks/orm/prisma.md
- api-style: .claude/skills/stacks/api-style/rest.md
- state:     .claude/skills/stacks/state/tanstack-query.md
- ui:        .claude/skills/stacks/ui/shadcn.md
```

---

## 개발 컨벤션

| 항목 | 규칙 |
|------|------|
| 응답 언어 | 한국어 |
| DB 네이밍 | snake_case (테이블명, 컬럼명 모두) |
| 공통 컬럼 | `id`, `created_at`, `updated_at`, `deleted_at` |
| 삭제 정책 | Soft delete (`deleted_at` 설정) — hard delete 금지 |
| 보안 | 시크릿 코드 포함 금지, 파라미터화된 쿼리만 사용 |
| API 문서 | Swagger 자동 생성 (`/api-docs`) |

---

## 요구사항

- Node.js 18 이상
- npm
- Claude Code CLI
- Docker (배포 옵션 선택 시)

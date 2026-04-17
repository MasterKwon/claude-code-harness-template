# Claude Code Harness Engineering Template

Claude Code를 활용한 AI 주도 개발을 위한 템플릿입니다.
이 저장소를 클론하여 새 프로젝트의 시작점으로 사용합니다.

---

## 개념

```
이 템플릿 클론 → 새 프로젝트 디렉토리에서 /project-setup → 개발 시작
```

Claude Code의 slash command와 skill 파일을 통해 **분석 → 설계 → 구현 → 테스트 → 배포** 전 과정을 AI와 함께 진행합니다. 코드를 직접 작성하지 않아도 됩니다.

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
| 0 | `/project-setup` | 프로젝트 초기화 |
| 1 | `/analyze-requirements` | `docs/01.analyze/requirements.md` |
| 2 | `/analyze-asis` | `docs/01.analyze/asis.md` |
| 3 | `/analyze-gap` | `docs/01.analyze/gap.md` |
| 4 | `/design-db` `/design-screen` `/design-api` | `docs/02.design/*.md` |
| 5 | `/build-db` `/build-api` `/build-screen` | 소스코드 |
| 6 | `/review-all` `/test-all` `/ship` | 검증 + 배포 |

### 기존 프로젝트 기능 추가·변경

```
/pipeline-change
```

기술 스택을 자동 감지 (사용자에게 묻지 않음) → 변경 범위만 분석·설계·구현합니다.

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
│   │       └── ui/              # shadcn.md, ...
│   ├── agents/                  # 서브에이전트 (code-reviewer, test-writer, security-auditor)
│   └── settings.json            # hooks 설정
└── docs/
    ├── 00.input/                # 요구사항 원본 자료 (여기에 파일 넣기)
    ├── 01.analyze/              # 분석 산출물 + reviewed/
    └── 02.design/               # 설계 산출물 + reviewed/
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

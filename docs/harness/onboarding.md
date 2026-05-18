# Harness Engineering — 온보딩 가이드

새 프로젝트에 이 하네스를 적용하는 방법과 기술스택 교체 절차를 설명합니다.

---

## 빠른 시작

```bash
# 1. 템플릿 클론
git clone https://github.com/MasterKwon/claude-code-harness-template.git my-project
cd my-project

# 2. 새 저장소로 초기화
rm -rf .git
git init
git checkout -b develop

# 3. Claude Code에서 프로젝트 설정
/project-setup
```

`/project-setup` 이 기술스택 선택 → 패키지 설치 → CLAUDE.md 자동 생성까지 처리합니다.

---

## 디렉토리 구조 이해

```
.
├── CLAUDE.md                        ← 프로젝트마다 달라지는 부분
├── .claude/
│   ├── commands/                    ← 수정 불필요 (범용 레이어)
│   ├── skills/                      ← 수정 불필요 (범용 레이어)
│   │   └── stacks/                  ← 기술스택 선택에 따라 활성화 여부만 달라짐
│   ├── agents/                      ← 수정 불필요 (범용 레이어)
│   ├── hooks/                       ← 수정 불필요 (범용 레이어)
│   └── settings.json                ← 필요 시 수정
└── docs/
    ├── 00.input/                    ← 요구사항 원본 넣는 곳
    ├── 01.analyze/ ~ 06.deploy/     ← 파이프라인 산출물 (자동 생성)
    └── harness/                     ← 이 가이드
```

핵심: **`CLAUDE.md`와 `stacks/` 활성화 설정만 수정하면** 하네스 전체가 동작합니다.

---

## CLAUDE.md 설정

`docs/harness/CLAUDE.md.template`을 복사해서 사용하거나, `/project-setup`이 자동으로 채워줍니다.

반드시 채워야 하는 섹션:

```markdown
## Project
(프로젝트 한 줄 설명)

## Environment
- Platform: macOS / Windows 11 / Ubuntu
- Shell: zsh / bash / powershell
- Working directory: /절대경로

## Tech Stack
(선택한 스택 목록)

## Active Skills
(선택한 스택에 해당하는 파일 경로)
```

---

## 기술스택 교체 가이드 (stacks/)

### Active Skills 섹션 변경

`CLAUDE.md`의 `## Active Skills` 섹션에서 경로만 바꾸면 됩니다.

```markdown
## Active Skills
- framework: .claude/skills/stacks/framework/nextjs.md        ← 고정
- arch:      .claude/skills/stacks/arch/[msa | monolith].md
- orm:       .claude/skills/stacks/orm/[prisma | typeorm | mongoose | raw-sql].md
- api-style: .claude/skills/stacks/api-style/[rest | trpc | graphql].md
- state:     .claude/skills/stacks/state/[tanstack-query | zustand | redux].md
- ui:        .claude/skills/stacks/ui/[shadcn | mui | antd | tailwind-only].md
```

### 스택별 파일 목록

| 카테고리 | 옵션 | 파일 경로 |
|---------|------|----------|
| 아키텍처 | MSA | `stacks/arch/msa.md` |
| 아키텍처 | 모노리스 | `stacks/arch/monolith.md` |
| ORM | Prisma | `stacks/orm/prisma.md` |
| ORM | TypeORM | `stacks/orm/typeorm.md` |
| ORM | Mongoose | `stacks/orm/mongoose.md` |
| ORM | Raw SQL | `stacks/orm/raw-sql.md` |
| API | REST | `stacks/api-style/rest.md` |
| API | tRPC | `stacks/api-style/trpc.md` |
| API | GraphQL | `stacks/api-style/graphql.md` |
| 상태관리 | TanStack Query | `stacks/state/tanstack-query.md` |
| 상태관리 | Zustand | `stacks/state/zustand.md` |
| 상태관리 | Redux | `stacks/state/redux.md` |
| UI | shadcn/ui | `stacks/ui/shadcn.md` |
| UI | MUI | `stacks/ui/mui.md` |
| UI | Ant Design | `stacks/ui/antd.md` |
| UI | Tailwind only | `stacks/ui/tailwind-only.md` |

### 스택 변경 시 절차

1. `CLAUDE.md`의 `## Active Skills` 경로 수정
2. `## Tech Stack` 섹션 수정
3. 기존 패키지 제거 → 새 패키지 설치
4. 설계 문서에 스택 명시 업데이트

---

## 파이프라인 선택 기준

| 상황 | 사용 파이프라인 |
|------|---------------|
| 처음부터 새 기능 개발 | `/pipeline-full` |
| 운영 중인 프로젝트 변경 (오류수정 / 기능개선 / 내부 개선) | `/pipeline-maintenance` |

---

## 커맨드 전체 목록 (48개)

### 파이프라인 (2)
| 커맨드 | 설명 |
|--------|------|
| `/pipeline-full` | 신규 프로젝트 전체 SDLC |
| `/pipeline-maintenance` | 오류수정 / 기능개선 / 내부 개선 |

### 분석 (7)
| 커맨드 | 설명 |
|--------|------|
| `/analyze-requirements` | 요구사항 분석 |
| `/analyze-asis` | AS-IS 현황 분석 |
| `/analyze-gap` | GAP 분석 (변경 범위 확정) |
| `/analyze-all` | 분석 3종 연속 실행 |
| `/refine-analyze-requirements` | 요구사항 분석 보완 |
| `/refine-analyze-asis` | AS-IS 분석 보완 |
| `/refine-analyze-gap` | GAP 분석 보완 |

### 설계 (10)
| 커맨드 | 설명 |
|--------|------|
| `/design-screen` | 화면 설계 |
| `/design-db` | DB 설계 |
| `/design-api` | API 설계 |
| `/design-integration` | 서비스 통합 설계 (MSA) |
| `/design-process` | 프로세스 설계 |
| `/design-tc` | UAT 체크리스트 설계 |
| `/design-all` | 설계 3종 연속 실행 |
| `/refine-design-screen` | 화면 설계 보완 |
| `/refine-design-db` | DB 설계 보완 |
| `/refine-design-api` | API 설계 보완 |

### 구현 (7)
| 커맨드 | 설명 |
|--------|------|
| `/build-db` | DB 구현 (마이그레이션) |
| `/build-api` | API 구현 |
| `/build-screen` | 화면 구현 |
| `/build-all` | 구현 3종 연속 실행 |
| `/refine-build-db` | DB 구현 보완 |
| `/refine-build-api` | API 구현 보완 |
| `/refine-build-screen` | 화면 구현 보완 |

### 리뷰 (6)
| 커맨드 | 설명 |
|--------|------|
| `/review-all` | 전체 코드 리뷰 |
| `/review-analyze` | 분석 산출물 리뷰 |
| `/review-design` | 설계 산출물 리뷰 |
| `/impact-check` | 변경 영향도 검사 |
| `/refine-review-all` | 코드 리뷰 보완 |
| `/refine-review-analyze` | 분석 리뷰 보완 |

### 테스트 (9)
| 커맨드 | 설명 |
|--------|------|
| `/test-db` | DB 테스트 |
| `/test-api` | API 테스트 |
| `/test-screen` | 화면 테스트 |
| `/test-e2e` | E2E 테스트 |
| `/test-all` | 테스트 4종 연속 실행 |
| `/refine-test-db` | DB 테스트 보완 |
| `/refine-test-api` | API 테스트 보완 |
| `/refine-test-screen` | 화면 테스트 보완 |
| `/refine-test-e2e` | E2E 테스트 보완 |

### 배포·운영 (7)
| 커맨드 | 설명 |
|--------|------|
| `/project-setup` | 신규 프로젝트 기술스택 선택 및 초기화 |
| `/deploy-dev` | Dev 서버 배포 |
| `/deploy-prd` | 운영 배포 체크리스트 |
| `/refine-deploy-prd` | 배포 체크리스트 보완 |
| `/customer-request` | 고객 변경 요청 분류 및 처리 |
| `/maintenance-init` | 유지보수 모드 초기화 (설계 문서 동기화) |
| `/refine-impact-check` | 영향도 검사 보완 |

---

## 자주 묻는 질문

**Q. stacks/ 파일을 직접 수정해도 되나요?**
A. 됩니다. 팀 컨벤션에 맞게 수정하면 해당 프로젝트에만 적용됩니다.

**Q. 새 기술스택(예: Bun, Hono)을 추가하려면?**
A. `stacks/{카테고리}/새스택.md` 파일을 생성 후 `CLAUDE.md`의 `Active Skills`에 경로 추가.

**Q. 커맨드를 추가하려면?**
A. `.claude/commands/새커맨드.md` 생성 후 `.claude/skills/새커맨드.md`에 실행 로직 작성.

**Q. `/project-setup` 없이 바로 시작해도 되나요?**
A. 됩니다. `CLAUDE.md`를 수동으로 작성하고 `/pipeline-full`부터 시작하면 됩니다.

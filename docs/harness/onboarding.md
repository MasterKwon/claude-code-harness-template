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
        ├── presentation-intro.html   ← 발표자료 1부 (체험형 실습)
        ├── presentation-intro2.html  ← 발표자료 2부 (스킬 만들기)
        ├── presentation-intro3.html  ← 발표자료 3부 (심화)
        ├── onboarding.md
        └── CHANGELOG.md
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

## 커맨드 전체 목록 (52개)

### 파이프라인 (2)
| 커맨드 | 설명 |
|--------|------|
| `/pipeline-full` | 신규 프로젝트 전체 SDLC |
| `/pipeline-maintenance` | 오류수정 / 기능개선 / 내부 개선 |

### 분석 (8)
| 커맨드 | 설명 |
|--------|------|
| `/grill-me` | 요구사항 인터뷰 (모호한 요구사항 구체화) |
| `/analyze-requirements` | 요구사항 분석 |
| `/analyze-asis` | AS-IS 현황 분석 |
| `/analyze-gap` | GAP 분석 (변경 범위 확정) |
| `/analyze-all` | 분석 3종 연속 실행 |
| `/refine-analyze-requirements` | 요구사항 분석 보완 |
| `/refine-analyze-asis` | AS-IS 분석 보완 |
| `/refine-analyze-gap` | GAP 분석 보완 |

### 설계 (11)
| 커맨드 | 설명 |
|--------|------|
| `/design-screen` | 화면 설계 |
| `/design-db` | DB 설계 |
| `/design-api` | API 설계 |
| `/design-integration` | 서비스 통합 설계 (MSA) |
| `/design-process` | 프로세스 설계 |
| `/design-tc` | UAT 체크리스트 설계 |
| `/design-prompt-gen` | Claude Design용 화면 프롬프트 생성 |
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

### 리뷰 (7)
| 커맨드 | 설명 |
|--------|------|
| `/review-all` | 전체 코드 리뷰 |
| `/review-analyze` | 분석 산출물 리뷰 |
| `/review-design` | 설계 산출물 리뷰 |
| `/impact-check` | 변경 영향도 검사 |
| `/refine-review-all` | 코드 리뷰 보완 |
| `/refine-review-analyze` | 분석 리뷰 보완 |
| `/refine-impact-check` | 영향도 검사 보완 |

### 테스트 (10)
| 커맨드 | 설명 |
|--------|------|
| `/test-db` | DB 테스트 |
| `/test-api` | API 테스트 |
| `/test-screen` | 화면 테스트 |
| `/test-e2e` | E2E 테스트 |
| `/test-ui-chrome` | Chrome UI 테스트 지시문 생성 |
| `/test-all` | 테스트 4종 연속 실행 |
| `/refine-test-db` | DB 테스트 보완 |
| `/refine-test-api` | API 테스트 보완 |
| `/refine-test-screen` | 화면 테스트 보완 |
| `/refine-test-e2e` | E2E 테스트 보완 |

### 배포·운영 (6)
| 커맨드 | 설명 |
|--------|------|
| `/project-setup` | 신규 프로젝트 기술스택 선택 및 초기화 |
| `/deploy-dev` | Dev 서버 배포 |
| `/deploy-prd` | 운영 배포 체크리스트 |
| `/refine-deploy-prd` | 배포 체크리스트 보완 |
| `/customer-request` | 고객 변경 요청 분류 및 처리 |
| `/maintenance-init` | 유지보수 모드 초기화 (설계 문서 동기화) |

### 유틸 (1)
| 커맨드 | 설명 |
|--------|------|
| `/skill-formatter` | 스킬 파일 구조 감사 보고서 생성 |

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

---

## 강사 노트 — 교육 운영 시 주의사항

### 1부 (`presentation-intro.html`) 에서 `-all` 묶음 스킬을 안 쓰는 이유

1부 실습 흐름은 `/analyze-requirements` → `/design-db` 처럼 **개별 스킬**을 호출합니다. `/analyze-all` 같은 묶음 스킬을 쓰지 않습니다. 이유:

1. **교육 효과** — 학습자가 각 단계가 무엇을 하는지 손으로 체험해야 이해. 묶음 스킬은 한 번에 끝나 사이사이 설명 기회 사라짐
2. **안전망 자동 체험을 위해** (v2.4.11+) — `-all` 묶음 스킬은 마지막에 `review-*` 안전망을 자동 포함 (예: `analyze-all` Step 4 = `review-analyze`). `-all` 을 쓰면 reviewed/ 가 자동 채워져 다음 단계 호출 시 안전망이 통과되어 **차단 메시지를 볼 수 없음**

**1부 SLIDE 8.5 (안전망 체험)** 는 이 흐름의 부산물. 학습자가 `/analyze-requirements` 다음에 `/review-analyze` 를 건너뛰고 `/design-db` 를 호출하면 PreToolUse 훅(`.claude/hooks/pre-pipeline-check.sh`)이 자동 차단 → 학습자가 안전망 가치를 직접 체감.

> **유의**: 1부 흐름을 `/analyze-all` 로 단순화하려는 시도는 안전망 체험을 사라지게 합니다.

### `/grill-me` 는 작업 중 언제든 호출 가능 (v2.4.16+)

`/grill-me` 는 분석 단계 시작 전뿐 아니라 **설계·구현·테스트 단계 진행 중에도 자유롭게 호출**할 수 있습니다.

**동작 흐름**:
1. 호출 시 Step 0 에서 현재 단계를 자동 추정 후 사용자에게 한 줄 확인
2. 단계별로 다른 위치에 누적 저장:
   - analyze → `docs/00.input/grill-result.md`
   - design → `docs/02.design/grill-decisions.md`
   - build → `docs/03.build/grill-decisions.md`
   - test → `docs/05.test/grill-decisions.md`
3. 다음번 후속 스킬 실행 시 사전 동작에서 자동으로 grill-decisions 를 읽고 반영

**사용 예시 (설계 단계)**:
```
사용자: /design-api 진행 중인데 응답 페이지네이션 방식이 모호하다. /grill-me
AI: 현재 design 단계로 인식했습니다. 맞습니까?
사용자: 네
AI: (인터뷰 진행 후 docs/02.design/grill-decisions.md 에 인터뷰 1 추가)
사용자: /design-api 재실행
AI: docs/02.design/grill-decisions.md 읽음 → 결정 사항 반영 후 api.md 갱신
```

> **장점**: 설계 도중 떠오른 의사결정도 체계적으로 기록되며, 후속 스킬이 누락 없이 자동 반영합니다.

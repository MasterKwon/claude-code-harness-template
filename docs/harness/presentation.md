# Claude Code 하네스 엔지니어링
## AI 주도 개발 파이프라인 구축 사례

> 발표 대상: 개발팀 내부
> 작성일: 2026-05-17

---

## 목차

1. 배경과 문제 의식
2. 하네스 엔지니어링이란
3. 파이프라인 3개 체계
4. 커맨드 체계 (49개)
5. 실제 동작 방식
6. 01.WebDesktop 적용 사례
7. 기대 효과
8. 시작하기

---

## 1. 배경과 문제 의식

### AI 코딩의 현실

Claude Code를 쓰기 시작하면 처음에는 빠릅니다. 그런데 시간이 지나면서 이런 일이 생깁니다:

- "이거 지난번에도 물어봤는데 또 잊어버렸네"
- "AI가 만들어준 코드인데 왜 DB와 API가 따로 놀지?"
- "어디서부터 다시 시작해야 하지?"
- "테스트는 했는데 배포하고 나서 다른 게 깨졌어"

**핵심 문제**: AI는 강력하지만, 가이드가 없으면 매 세션마다 처음부터 다시 설명해야 합니다.

### 기존 접근의 한계

| 방식 | 문제 |
|------|------|
| 프롬프트 직접 작성 | 매번 다르고, 품질이 들쭉날쭉 |
| 단계별 수동 진행 | 단계 누락, 산출물 불일치 |
| AI에게 전부 맡기기 | 범위 초과, 예상 못한 변경 |

---

## 2. 하네스 엔지니어링이란

### 개념

> "실수가 발생하면 사과하는 대신, 다시는 같은 실수가 반복되지 않도록 환경을 개선한다."
>
> — by Andrej Karpathy & Jeff Hashimoto

**하네스(Harness)**: 말에 채우는 마구(馬具). 힘을 방향 있게 쓰도록 제어하는 장치.

AI의 강력한 능력을 **통제된 방향**으로 흐르게 만드는 구조물입니다.

### 구성 요소

```
Claude Code 하네스
│
├── CLAUDE.md          프로젝트 컨텍스트 (기술스택, 가이드라인, 원칙)
├── .claude/commands/  슬래시 커맨드 진입점 (49개)
├── .claude/skills/    단계별 실행 로직 (상세 지침)
├── .claude/stacks/    기술스택별 패턴 (플러그인 방식)
├── .claude/agents/    전문 서브에이전트 (코드리뷰, 보안, 테스트)
└── .claude/hooks/     자동화 트리거 (수정 후 타입체크 등)
```

### 핵심 원칙

**1. Surgical Changes (수술적 변경)**
요청받은 범위만 건드립니다. 주변 코드를 불필요하게 리팩토링하지 않습니다.

**2. Think Before Coding**
코드 작성 전 가설과 계획을 먼저 수립합니다. 분석 → 설계 → 구현 순서를 지킵니다.

**3. Simplicity First**
불필요한 추상화를 지양합니다. 현재 문제를 해결하는 가장 단순한 코드를 씁니다.

---

## 3. 파이프라인 3개 체계

### 전체 그림

```
상황                                        파이프라인
──────────────────────────────────────────────────────
처음부터 새로 만들기                       →  /pipeline-full
오류수정 / 기능개선 / 내부 개선 (운영 중)  →  /pipeline-maintenance
```

---

### 3.1 pipeline-full — 신규 프로젝트

```
[분석]                    [설계]          [설계리뷰]    [TC설계]       [구현]
analyze-requirements  →  design-screen  →            →  design-tc  →  build-db
analyze-asis          →  design-db      → review-    →             →  build-api
analyze-gap           →  design-api     →  design    →             →  build-screen

                                                              ↓
[영향도 검사]            [리뷰]          [AI QA - Local]   [Dev 배포]  [UAT]     [운영 배포]
impact-check         →  review-all  →  test-db        →  deploy-dev → UAT    →  deploy-prd
                                     →  test-api
                                     →  test-screen
                                     →  test-e2e
```

**Phase 구조 (7개)**

| Phase | 명령 | 산출물 |
|-------|------|--------|
| 0 | `/project-setup` | 프로젝트 초기화, CLAUDE.md |
| 1 | `/analyze-all` | requirements.md, asis.md, gap.md |
| 2 | `/design-all` + `/review-design` | screen.md, db.md, api.md, uat-checklist.md |
| 3 | `/build-all` + `/impact-check` | 소스코드, impact-check.md |
| 4 | `/review-all` | review-report.md |
| 5 | `/test-all` | test-report-*.md |
| 5.5 | `/deploy-dev` | Dev 배포, `06.deploy/deploy-dev.md` |
| 6 | UAT | `06.deploy/uat-result.md` — QA 담당자 수행 |
| 7 | `/deploy-prd` | 운영 배포 체크리스트, `06.deploy/deploy-prd.md` |

---

### 3.2 pipeline-maintenance — 유지보수

오류수정, 기능개선, 내부 개선 모두 이 파이프라인으로 처리합니다.
신규 개발과의 핵심 차이: **먼저 WHY를 정의하고, AS-IS → GAP으로 범위를 확정**합니다.

```
[변경 정의]           [현황 파악]           [범위 확정]
WHY 정의          →  analyze-asis      →  analyze-gap
(유형/이유 명시)      (기존 코드 먼저)      (작업 목록)

      ↓
[영향 범위만 설계]    [영향 범위만 구현]    [리뷰 + 테스트]      [배포]
GAP 결과 기반        GAP 결과 기반          회귀 테스트 포함   deploy-dev → deploy-prd

↺ 다음 변경 → Phase 1부터 반복
```

**변경 유형**

| 유형 | 예시 |
|------|------|
| 오류수정 | 계산 오류, 잘못된 데이터 표시 |
| 기능개선 | 조회 화면 추가, 필드 추가 |
| 내부 개선 | 성능 개선, 리팩토링 |

**핵심 규칙**: GAP에 없는 코드는 건드리지 않습니다.

---

## 4. 커맨드 체계 (51개)

### 구조 원칙

```
진입점: /커맨드명  (.claude/commands/커맨드명.md)
    ↓
실행 로직: .claude/skills/커맨드명.md
    ↓
기술스택 패턴: .claude/skills/stacks/{카테고리}/{스택}.md
```

### 카테고리별 분류

| 카테고리 | 커맨드 수 | 대표 커맨드 |
|---------|----------|-----------|
| 파이프라인 | 2 | pipeline-full, pipeline-maintenance |
| 분석 | 8 | analyze-requirements, asis, gap, **grill-me** |
| 설계 | 11 | design-screen, db, api, tc, **design-prompt-gen** |
| 구현 | 7 | build-db, build-api, build-screen |
| 리뷰 | 7 | review-all, review-design, impact-check |
| 테스트 | 10 | test-db, api, screen, e2e, **test-ui-chrome** |
| 배포·운영 | 6 | deploy-dev, deploy-prd, customer-request |
| **합계** | **51** | |

### refine-* 패턴

모든 주요 단계에는 보완 커맨드가 존재합니다:

```
/analyze-requirements   →   /refine-analyze-requirements
/design-api             →   /refine-design-api
/build-screen           →   /refine-build-screen
/test-e2e               →   /refine-test-e2e
...
```

전체를 다시 실행하지 않고, **미진한 부분만 보완**합니다.

---

## 5. 실제 동작 방식

### 품질 게이트

각 Phase 완료 시 자동으로 품질을 점검합니다:

```
✅ 요구사항: Must/Should/Could 우선순위 부여됨
✅ DB 설계: ERD + 인덱스 전략 포함
✅ API 설계: Swagger 명세 포함
✅ 구현: TypeScript 타입 에러 없음 (hook 자동 체크)
✅ 리뷰: High 심각도 없음
✅ 테스트: E2E 전체 통과
```

게이트 실패 시 다음 Phase로 진행하지 않습니다.

### 롤백 맵

문제 발견 시 어디로 돌아갈지 파이프라인에 명시되어 있습니다:

```
발견 위치         원인              조치
────────────────────────────────────────────────────
테스트 실패    → API 구현 오류  → /refine-build-api → 리뷰 → 테스트 재실행
UAT FAIL      → 기능 누락      → /refine-design-*  → 구현 → 테스트 → 배포 → UAT
운영 배포 실패 → 환경설정 오류  → 직접 수정         → deploy-prd 재실행
```

### 기술스택 플러그인

`CLAUDE.md`의 `Active Skills` 한 줄만 바꾸면 다른 스택으로 전환됩니다:

```markdown
## Active Skills
- orm: .claude/skills/stacks/orm/prisma.md   ← 이것만 typeorm.md로 바꾸면 끝
```

---

## 6. 01.WebDesktop 적용 사례

### 적용 배경

Next.js + MSA 구조를 처음 경험하는 백엔드 20년차 개발자가 바이브코딩으로 실제 프로젝트를 진행하며 하네스를 검증했습니다.

### 발견된 취약점과 보완

| # | 취약점 | 보완 방법 |
|---|--------|----------|
| V1 | 분석 품질 게이트 부재 | 각 분석 단계에 체크리스트 추가 |
| V2 | 설계 리뷰 단계 누락 | review-design 커맨드 + Phase 2.5 추가 |
| V3 | 구현 후 레이어 정합성 미검증 | impact-check + Phase 3.5 추가 |
| V4 | 유지보수 파이프라인 부재 | pipeline-maintenance 신규 구축 |
| V5 | 고객 요청 처리 체계 없음 | customer-request 커맨드 + 6종 분류 체계 |
| V6 | Dev 배포 단계 누락 | deploy-dev 커맨드 추가 |
| V7 | UAT와 AI 테스트 혼재 | 명확히 분리: AI QA(Local) / UAT(사람) |
| V8 | UAT 체크리스트 사후 작성 | design-tc를 구현 전(Phase 2.7)으로 이동 |
| V9 | 롤백 경로 미명시 | 파이프라인 내 롤백 맵 전면 작성 |
| V10 | 요구사항 변경 시나리오 없음 | 변경 발생 시점별 대응 절차 추가 |
| V11 | refine-* 커맨드 일부 누락 | 전체 주요 단계에 refine 커맨드 완비 |
| V12 | 설계 산출물 리뷰 미분리 | review-analyze / review-design 분리 |
| V13 | 유지보수 초기화 절차 없음 | maintenance-init 커맨드 추가 |

### v2.2.0 — Bridge 패턴 확장 (사람 역할 명시화)

V14~V16은 "더 많은 자동화"가 아니라 **"AI가 잘 못하는 영역을 사람에게 명시적으로 넘긴 것"** 입니다.
신규 단계마다 "왜 자동화하지 않고 사람을 끼웠는가" 를 함께 정리합니다.

| # | 취약점 | 신규 단계 | 왜 사람인가? |
|---|--------|----------|------------|
| V14 | 요구사항 모호성 사전 제거 부재 | `grill-me` (Phase 0.5) ↗ 원형: [mattpocock/skills](https://github.com/mattpocock/skills) | 머릿속 결정 트리는 한 번에 텍스트로 못 풉니다. **묻고 답하는 왕복**이 있어야 분기가 닫힙니다. AI 단방향 생성으로는 모호함이 그대로 분석에 전달됩니다. |
| V15 | UI 설계 시 시각적 목업 부재 | `design-prompt-gen` (Phase 1.7) | 색감·여백·정서적 인상은 명세로 표현되지 않습니다. **눈으로 보고** 결정해야 합니다. AI 프롬프트만으로는 시각적 적절성을 검증할 수 없습니다. |
| V16 | 화면 수동 검증 표준화 부재 | `test-ui-chrome` (test-all Step 5) | 단위 테스트가 통과해도 실제 클릭 흐름은 어색할 수 있습니다. **손과 눈**으로만 잡히는 UX 결함이 존재합니다. AI는 자기가 만든 코드를 자기 기준으로만 평가합니다. |

> **핵심 원칙**: 자동화의 가치는 "전부 자동"이 아니라 **"누가 무엇을 책임지는가"의 명확화**입니다.
> V14~V16은 사람 역할을 줄인 게 아니라, 사람이 꼭 해야 하는 일을 **놓치지 않도록 파이프라인에 못 박은 것**입니다.

---

## 7. 기대 효과

### 개발 속도

| 작업 | 기존 (수동) | 하네스 |
|------|-----------|--------|
| 요구사항 → 설계 | 1~2일 | 2~4시간 |
| 설계 → API 구현 | 3~5일 | 반나절~1일 |
| 코드 리뷰 | 2~4시간 (사람) | 10~30분 (AI) |
| 테스트 작성 | 1~2일 | 1~2시간 |

### 품질

- 단계 누락 방지 (품질 게이트)
- 레이어 간 불일치 조기 발견 (impact-check)
- 보안 취약점 자동 검출 (security-auditor 에이전트)
- 회귀 버그 조기 차단 (회귀 테스트 포함)

### 지식 축적

- `CLAUDE.md`에 프로젝트 컨텍스트 영속 보존
- `docs/` 산출물이 자동 문서화
- 변경 이력 자동 기록 (change-requests.md)

---

## 8. 시작하기

### 3단계

```bash
# 1. 템플릿 클론
git clone https://github.com/MasterKwon/claude-code-harness-template.git my-project
cd my-project

# 2. 새 저장소 초기화
rm -rf .git && git init && git checkout -b develop

# 3. Claude Code에서
/project-setup
```

### 그 다음

```
/pipeline-full        ← 신규 프로젝트
/pipeline-maintenance ← 오류수정 / 기능개선 / 내부 개선
```

### 상세 가이드

- 온보딩 가이드: `docs/harness/onboarding.md`
- CLAUDE.md 템플릿: `docs/harness/CLAUDE.md.template`
- 변경 이력: `docs/harness/CHANGELOG.md`

---

## 부록: 파일 구조 전체

```
.
├── CLAUDE.md
├── .claude/
│   ├── commands/       (51개)
│   ├── skills/
│   │   ├── *.md        (29개 — 범용 로직)
│   │   └── stacks/     (17개 — 기술스택 플러그인)
│   └── hooks/          (1개 — post-edit.sh)
└── docs/
    ├── 00.input/       요구사항 원본
    ├── 01.analyze/     분석 산출물
    ├── 02.design/      설계 산출물
    ├── 03.build/       구현 산출물 (impact-check)
    ├── 04.review/      리뷰 보고서
    ├── 05.test/        테스트 보고서
    ├── 06.deploy/      배포 산출물 (deploy-dev, uat-result, deploy-prd)
    └── harness/        이 문서들
```

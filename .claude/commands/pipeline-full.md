# 전체 파이프라인 실행

분석 → 설계 → 구현 → 리뷰 → 테스트 → 배포의 전체 SDLC를 순서대로 실행합니다.

> **Agent 위임 규칙**: `[fast]`, `[balanced]`, `[best]` 태그는 CLAUDE.md 모델 티어 기준으로 Agent를 생성하여 위임합니다. 태그 없는 단계는 현재 모델로 직접 실행합니다.

## 파이프라인 구조

```
[킥오프]      [분석]                   [설계 프롬프트]      [설계]         [설계리뷰]  [TC설계]      [구현]
grill-me  →  analyze-requirements  →  design-prompt-gen → design-screen → review-  → design-tc → build-db
             analyze-asis             (claude.ai/design   design-db        design                build-api
             analyze-gap              에서 목업 확인)      design-api                              build-screen

                                                                              ↓
[영향도 검사]    [리뷰]           [AI QA - Local]              [Dev 배포]    [UAT]      [운영 배포]
impact-check → review-all  →  test-db                    → deploy-dev → UAT    →  deploy-prd
                              test-api
                              test-screen
                              test-e2e
                              test-ui-chrome (Chrome 지시문)
```

## 실행 순서

### Phase 0 — 프로젝트 설정

> 기술 스택이 이미 결정되어 있다면 `CLAUDE.md`를 확인하고 Phase 1로 넘어가세요.
> 스택을 아직 결정하지 않았다면 아래를 실행합니다.

Read `.claude/skills/project-setup.md` and follow all instructions.

- 9가지 항목 선택 → 프로젝트 초기화 → 패키지 자동 설치
- 완료 후 `CLAUDE.md` Tech Stack 섹션 자동 업데이트

**→ 설치 완료 및 CLAUDE.md 확인 후 Phase 0.5로 진행하세요.**

---

### Phase 0.5 — 집중 인터뷰 (Grill Me) [선택, 권장]

> 요구사항이 머릿속에만 있고 모호한 경우, 분석 진입 **전에** 의사결정 트리를 정리합니다.
> `docs/00.input/` 에 잘 정리된 문서가 이미 있으면 이 단계는 건너뛰어도 됩니다.

[best] Read `.claude/skills/grill-me.md` and follow all instructions.
산출물: `docs/00.input/grill-result.md`

**→ 인터뷰 결과 확인 후 Phase 1로 진행하세요.**
`analyze-requirements` 가 이 파일을 추가 입력으로 자동 활용합니다.

---

### Phase 1 — 분석
Read `.claude/skills/analyze-requirements.md` and follow all instructions. (`docs/01.analyze/requirements.md` 생성)
[fast] Read `.claude/skills/analyze-asis.md` and follow all instructions. (`docs/01.analyze/asis.md` 생성)
[best] Read `.claude/skills/analyze-gap.md` and follow all instructions. (`docs/01.analyze/gap.md` 생성)

**→ 분석 Phase 완료 후 반드시 사용자 확인을 받고 다음 Phase로 진행하세요.**

품질 게이트 통과 및 사용자 확인 후 커밋:
```bash
git add docs/01.analyze/
git commit -m "phase1: analyze-all 완료"
git push
```

### Phase 1.7 — Claude Design 프롬프트 생성 [선택, 권장]

> 화면을 텍스트로만 설계하면 시각적 누락이 생기기 쉽습니다.
> `design-screen` 진입 **전에** Claude Design 용 프롬프트를 생성하고, 사람이 `claude.ai/design` 에서 목업을 확인합니다.

[balanced] Read `.claude/skills/design-prompt-gen.md` and follow all instructions.
산출물: `docs/02.design/design-prompts.md`

**→ 목업 검토 후 Phase 2로 진행하세요.**
검토 결과(레이아웃 결정, 컴포넌트 선택 등)는 `design-screen` 입력에 반영합니다.

---

### Phase 2 — 설계
Read `.claude/skills/design-screen.md` and follow all instructions. (`docs/02.design/screen.md` 생성)
Read `.claude/skills/design-db.md` and follow all instructions. (`docs/02.design/db.md` 생성)
Read `.claude/skills/design-api.md` and follow all instructions. (`docs/02.design/api.md` 생성)

**→ 설계 Phase 완료 후 반드시 사용자 확인을 받고 다음 Phase로 진행하세요.**

품질 게이트 통과 및 사용자 확인 후 커밋:
```bash
git add docs/02.design/
git commit -m "phase2: design-all 완료"
git push
```

### Phase 2.5 — 설계 리뷰
[best] Read `.claude/skills/review-design.md` and follow all instructions.
산출물: `docs/02.design/design-review-report.md`

- PASS → `docs/02.design/cross-check.md` 자동 생성 (타 LLM 교차검증 브리핑) → Phase 2.7로 진행
- FAIL (설계 문제만) → 해당 설계 스킬 Patch 모드 실행 (`/design-api`, `/design-screen`, `/design-db`) 후 재리뷰
- FAIL (분석 보완 사항 있음) → `/refine-analyze-requirements` → 영향 설계 재실행 → 재리뷰

> **교차검증 권장**: `docs/02.design/cross-check.md`를 타 LLM에 붙여넣고 개발 시작 전 설계를 검증하세요.

---

### Phase 2.7 — UAT 체크리스트 설계
Read `.claude/skills/design-tc.md` and follow all instructions.
산출물: `docs/02.design/tc/uat-checklist.md`

> 구현 시작 전에 **사람이 Dev 환경에서 직접 수행할 UAT 항목**을 먼저 정의합니다.
> Phase 5.5 Dev 배포 완료 후, 이 체크리스트를 QA 담당자에게 전달합니다.

**→ UAT 체크리스트 작성 완료 후 Phase 3으로 진행하세요.**

---

### Phase 3 — 구현
Read `.claude/skills/build-db.md` and follow all instructions.
Read `.claude/skills/build-api.md` and follow all instructions.
Read `.claude/skills/build-screen.md` and follow all instructions.

**→ 구현 Phase 완료 후 반드시 사용자 확인을 받고 다음 Phase로 진행하세요.**

품질 게이트 통과 및 사용자 확인 후 커밋:
```bash
git add .
git commit -m "phase3: build-all 완료"
git push
```

### Phase 3.5 — 구현 영향도 검사
[best] Read `.claude/skills/impact-check.md` and follow all instructions.
산출물: `docs/03.build/impact-check.md`

> 신규 개발에서는 회귀 위험보다 **레이어 간 정합성**을 검증합니다.
> build-db → build-api → build-screen 순서로 구현했을 때 각 레이어 간 가정이 일치하는지 확인합니다.

**불일치 항목 발견 시**: 해당 레이어 `/refine-build-*` 실행 후 재검사.
**High 항목 없으면**: 즉시 Phase 4로 진행.

---

### Phase 4 — 리뷰
[best] Read `.claude/skills/review-all.md` and follow all instructions. (`docs/04.review/report.md` 생성)

> `docs/03.build/impact-check.md`의 High/Medium 항목을 중점 검토합니다.

- High 심각도 문제 발견 시: 해당 구현 단계로 롤백 후 재실행
- 모두 통과 시: `docs/04.review/reviewed/report.md`로 복사 후 다음 Phase 진행

**→ 리뷰 통과 확인 후 다음 Phase로 진행하세요.**

리뷰 통과 후 커밋:
```bash
git add docs/04.review/
git commit -m "phase4: review-all 통과"
git push
```

### Phase 5 — AI 자동화 테스트 (Local)

> 로컬 환경에서 AI가 자동 실행하는 테스트입니다.

[fast] Read `.claude/skills/test-db.md` and follow all instructions. (`docs/05.test/report-db.md` 생성)
[fast] Read `.claude/skills/test-api.md` and follow all instructions. (`docs/05.test/report-api.md` 생성)
[fast] Read `.claude/skills/test-screen.md` and follow all instructions. (`docs/05.test/report-screen.md` 생성)
Read `.claude/skills/test-e2e.md` and follow all instructions. (`docs/05.test/report-e2e.md` 생성)
[balanced] Read `.claude/skills/test-ui-chrome.md` and follow all instructions. (`docs/05.test/ui-test-chrome.md` + `.xlsx` 생성)

> `test-ui-chrome` 은 자동 테스트가 아닙니다. AI 자동 테스트 통과 후, **사람이 Chrome 사이드패널로 이중 검증**할 수 있도록 지시문/체크리스트를 생성하는 Bridge 단계입니다.
> QA 담당자는 `ui-test-chrome.xlsx` 를 복사하여 `ui-test-chrome_result.xlsx` 로 작업합니다.

**→ 테스트 Phase 완료 후 반드시 사용자 확인을 받고 다음 Phase로 진행하세요.**

테스트 통과 후 커밋:
```bash
git add docs/05.test/
git commit -m "phase5: test-all 통과"
git push
```

---

### Phase 5.5 — Dev 서버 배포

> UAT를 수행할 수 있는 Dev/Staging 서버에 배포합니다.

[fast] Read `.claude/skills/deploy-dev.md` and follow all instructions.

배포 완료 후:
- `docs/02.design/tc/uat-checklist.md` 를 QA 담당자(개발팀 외 인원)에게 전달합니다.
- UAT 완료를 기다립니다.

---

### Phase 6 — UAT (Dev 환경)

> QA 담당자가 Dev 서버에서 `docs/02.design/tc/uat-checklist.md` 기준으로 직접 수행합니다.
> 개발팀이 대신 수행하지 않습니다.

UAT 완료 기준:
- 체크리스트 전체 P/F 기입 완료
- FAIL 항목 없음
- 결과를 `docs/06.deploy/uat-result.md` 에 기록

**→ UAT PASS 확인 후 Phase 7로 진행합니다.**

---

### Phase 7 — 운영 배포

Read `.claude/skills/deploy-prd.md` and follow all instructions. (`docs/06.deploy/deploy-prd.md` 생성)

배포 체크리스트 완료 후 커밋 및 main 머지:
```bash
git add docs/06.deploy/
git commit -m "phase7: deploy-prd 완료"
git push
# GitHub에서 PR → main 머지
```

**→ 전체 파이프라인 완료.**

---

### 운영 전환 — Knowledge Accretion 시작

> 운영 배포 이후 이 시스템은 신규 개발이 아닌 **유지보수 단계**로 들어갑니다.
> 첫 변경 작업 전에 `/maintenance-init` 을 **한 번** 실행하여 CONTEXT 누적 구조를 활성화하세요.

```
Read `.claude/skills/maintenance-init.md` and follow all instructions.
```

`maintenance-init` 은 코드를 역공학하여 분석/설계 문서를 재구성하고 `docs/context/` 도메인 노트 스켈레톤을 생성합니다.
이후 모든 변경은 `/pipeline-maintenance` 로 진행되며, 각 작업 끝에 CONTEXT 가 자동 누적됩니다.

---
각 Phase 사이에 사용자 확인을 받는 것은 필수입니다.

## 롤백 맵 — 문제 발생 시 어디로 돌아갈지

문제를 발견한 위치에서 원인을 찾아 해당 단계로 되돌아갑니다.
보완 후에는 그 단계 이후의 모든 산출물을 재실행해야 합니다.

```
문제 발견 위치          원인                       조치 커맨드                       이후 재실행 범위
─────────────────────────────────────────────────────────────────────────────────────────────────
[운영 배포]
  deploy-prd 실패           → UAT 미완료                 UAT 재수행                        deploy-prd
  deploy-prd 실패           → 환경설정 오류              직접 수정                         deploy-prd

[UAT]
  UAT FAIL            → 화면 구현 오류             /refine-build-screen              test-screen, deploy-dev, UAT
  UAT FAIL            → API 오류                   /refine-build-api                 test-api, deploy-dev, UAT
  UAT FAIL            → 기능 누락                  /refine-design-{api|screen|db}    build-*, test-*, deploy-dev, UAT

[Dev 배포]
  deploy-dev 실패     → 테스트 미통과              /test-all                         deploy-dev
  deploy-dev 실패     → 환경설정 오류              직접 수정                         deploy-dev

[테스트]
  test-e2e 실패      → 화면 구현 오류             /refine-build-screen              review-all, test-screen, test-e2e
  test-e2e 실패      → API 구현 오류              /refine-build-api                 review-all, test-api, test-e2e
  test-e2e 실패      → DB 구현 오류               /refine-build-db                  review-all, test-db, test-api, test-e2e
  test-e2e 실패      → API 설계 오류              /refine-design-api                build-api, build-screen, review-all, test-* 전체
  test-e2e 실패      → DB 설계 오류               /refine-design-db                 build-db 이후 전체
  test-e2e 실패      → 요구사항 오류              /refine-analyze-requirements      설계 이후 전체

[리뷰]
  review-all High    → 구현 코드 오류             /refine-build-{api|db|screen}     review-all 재실행
  review-all High    → 보안 취약점                /refine-build-{api|db|screen}     review-all 재실행

[구현]
  build-screen 중    → API 설계 누락              /refine-design-api                build-api, build-screen 재실행
  build-api 중       → DB 설계 누락               /refine-design-db                 build-db, build-api 재실행
  build-db 중        → DB 설계 오류               /refine-design-db                 build-db 재실행

[설계 리뷰]
  review-design FAIL → 설계 문제                  /design-{api|screen|db}           review-design 재실행
  review-design FAIL → 분석 보완 필요              /refine-analyze-requirements      영향 설계 재실행, review-design

[설계]
  design-api 중      → 화면 설계 누락             /refine-design-screen             design-api 재실행
  design-api 중      → DB 설계 누락               /refine-design-db                 design-api 재실행
  design-* 중        → 요구사항 불명확            /refine-analyze-requirements      design-* 재실행

[분석]
  analyze-gap 중     → AS-IS 누락                /refine-analyze-asis              analyze-gap 재실행
  analyze-gap 중     → 요구사항 불명확            /refine-analyze-requirements      analyze-gap 재실행
```

### 원칙
- 보완(`refine-*`)은 기존 문서를 유지하면서 미진한 부분만 채웁니다.
- 롤백 후 재실행 범위는 해당 산출물에 의존하는 모든 하위 단계입니다.
- 롤백 범위가 2단계 이상이면 사용자에게 범위를 먼저 확인하세요.

---

## 요구사항 변경 시나리오

진행 중 요구사항이 바뀌는 경우, 현재 위치에 따라 다르게 대응합니다.

```
변경 발생 시점              대응 방법
──────────────────────────────────────────────────────────────────────────
분석 단계 중               /refine-analyze-requirements 후 이후 단계 재실행
설계 단계 중               변경 범위 확인 후 영향받는 설계 문서만 /refine-design-*
구현 단계 중               /refine-analyze-requirements → 설계 → 구현 재실행
리뷰/테스트 단계 중         변경 범위가 크면 분석부터, 작으면 구현부터 롤백
```

### 변경 범위 판단 기준

| 변경 내용 | 범위 |
|-----------|------|
| 텍스트/레이블/문구 수정 | 화면 구현만 재실행 |
| 필드 추가/삭제 | DB → API → Screen 순 재실행 |
| 기능 추가 | 요구사항부터 전체 재실행 |
| 기능 제거 | 영향받는 설계/구현 문서 삭제 후 재검증 |

### 변경 이력 관리
요구사항이 변경될 때마다 `docs/01.analyze/requirements.md` 하단에 변경 이력을 추가합니다:
```
## 변경 이력
| 날짜 | 변경 내용 | 영향 범위 |
|------|-----------|-----------|
| YYYY-MM-DD | ... | ... |
```

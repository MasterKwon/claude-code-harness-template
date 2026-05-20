# Pipeline 한눈 가이드

> 신규 개발(`pipeline-full`)과 운영 변경(`pipeline-maintenance`) 두 파이프라인을 한 파일에서 비교.
> 교육·실습 시 옆에 두고 진행하면 한 단계도 빠뜨리지 않습니다. (HTML 버전은 탭으로 분리)

---

## 범례 (공통)

- **필수 여부**: 🟢 안전망 (절대 생략 불가) · 🔵 필수 · ⚪ 선택 / 조건부
- **모델**: `fast` = haiku · `balanced` = sonnet · `best` = opus
- **안전망 / 무효화** 컬럼: 재실행 시 `reviewed/` 의 어떤 파일이 자동 삭제되는가 + 다음 단계 진입 조건
- **⚙️ 표시**: PreToolUse 훅(`.claude/hooks/pre-pipeline-check.sh`)이 **코드로 진입 조건을 검사하고 미충족 시 차단**. 자연어 지시 + 코드 강제 두 층위 안전망

---

# 1. 신규 개발 — `pipeline-full`

## 단계 전환 안전망 흐름도

```
[Phase 0 ~ 0.5]   준비 (project-setup · grill-me)
                  ↓
[Phase 1.1~1.7]  분석 (requirements · asis · gap · design-prompts)
                  ↓
              🟢 review-analyze  ← PASS 시 reviewed/ 일괄 복사
                  ↓
[Phase 2.1~2.5]  설계 (process · screen · db · api · integration)
                  ↓
              🟢 review-design  ← PASS 시 reviewed/ + cross-check + deliverable 자동 연쇄
                  ↓
[Phase 2.7]      UAT 체크리스트 (design-tc)
                  ↓
[Phase 3.1~3.3]  구현 (build-db · build-api · build-screen)
                  ↓
              🟢 impact-check  ← 변경 영향도 검사 (Phase 3.5)
                  ↓
              🟢 review-all  ← PASS 시 docs/04.review/reviewed/report.md 복사
                  ↓
[Phase 5.1~5.4]  AI 테스트 (test-db · test-api · test-screen · test-e2e)
                  ↓
[Phase 5.5]      Chrome UI 지시문 (선택)
                  ↓
              🟢 cross-check-test  ← 4개 보고서 reviewed/ 일괄 복사
                  ↓
[Phase 5.7]   🟢 Dev 배포 (deploy-dev)
                  ↓
[Phase 6]     🟢 UAT (사람 수행 → uat-result.md)
                  ↓
[Phase 7]     🟢 운영 배포 (deploy-prd)
```

## 전체 흐름

| # | Phase | 단계 | 호출 명령 | 입력 | 출력 | 필수 | 모델 | 안전망 / 무효화 |
|---|------|------|----------|------|------|------|------|---------|
| 0 | 0 | 프로젝트 초기화 | `/project-setup` | 사용자 선택 (9가지 스택) | `CLAUDE.md` · `package.json` · 환경설정 | 🔵 필수 (1회) | balanced | — |
| 1 | 0.5 | 집중 인터뷰 | `/grill-me` | 사용자 머릿속 요구사항 | `docs/00.input/grill-result.md` (분석 단계 호출 시) — **단계 인지형: 설계/구현/테스트 단계에서 호출 시 해당 단계 `grill-decisions.md` 에 누적** | ⚪ 선택 (권장) | best | 후속 스킬이 사전 동작에서 자동 읽음 |
| 2 | 1.1 | 요구사항 분석 | `/analyze-requirements` | `docs/00.input/` 자료 (grill 결과 포함) | `docs/01.analyze/requirements.md` (원본) | 🔵 필수 | balanced | 재실행 시 `reviewed/{req, gap}.md` 자동 삭제 |
| 3 | 1.2 | AS-IS 분석 | `/analyze-asis` | 기존 코드베이스 | `docs/01.analyze/asis.md` (원본) | ⚪ 조건부 | fast | **신규 개발 시 사실상 N/A** (기존 시스템 없음). 재실행 시 `reviewed/{asis, gap}.md` 자동 삭제 |
| 4 | 1.3 | GAP 분석 | `/analyze-gap` | `docs/01.analyze/{req, asis}.md` | `docs/01.analyze/gap.md` (원본) | ⚪ 조건부 | best | **신규 개발 시 사실상 N/A** (AS-IS 없음 → GAP = requirements 전체). 재실행 시 `reviewed/gap.md` 자동 삭제 |
| 5 | 1.4 | 분석 종합 리뷰 | `/review-analyze` | `docs/01.analyze/*.md` (원본) | `analyze-review-report.md` + PASS 시 `reviewed/` 일괄 복사 | 🟢 안전망 | best | **진입 조건**: `reviewed/` 3개 |
| 6 | 1.7 | Claude Design 프롬프트 | `/design-prompt-gen` | `docs/01.analyze/reviewed/requirements.md` | `docs/02.design/design-prompts.md` | ⚪ 선택 | balanced | ⚙️ 진입 조건: analyze reviewed/ 필요 |
| 7 | 2.1 | 프로세스 설계 | `/design-process` | `analyze/reviewed/requirements.md` | `docs/02.design/process.md` | 🔵 필수 | balanced | ⚙️ 재실행 시 `reviewed/process.md` 자동 삭제 |
| 8 | 2.2 | 화면 설계 | `/design-screen` | `analyze/reviewed/{req, gap}.md` | `docs/02.design/screen.md` | 🔵 필수 | balanced | ⚙️ 재실행 시 `reviewed/{screen, api, tc}.md` 자동 삭제 (의존 연쇄) |
| 9 | 2.3 | DB 설계 | `/design-db` | `analyze/reviewed/{req, gap}.md` | `docs/02.design/db.md` | 🔵 필수 | balanced | ⚙️ 재실행 시 `reviewed/{db, api, tc}.md` 자동 삭제 |
| 10 | 2.4 | API 설계 | `/design-api` | `docs/02.design/{screen, db}.md` | `docs/02.design/api.md` | 🔵 필수 | balanced | ⚙️ 재실행 시 `reviewed/{api, tc}.md` 자동 삭제 |
| 11 | 2.5 | 외부 연계 설계 | `/design-integration` | `analyze/reviewed/{req, asis}.md` | `docs/02.design/integration.md` | ⚪ 선택 | balanced | ⚙️ 재실행 시 `reviewed/integration.md` 자동 삭제 |
| 12 | 2.6 | 설계 종합 리뷰 | `/review-design` | `docs/02.design/*.md` + analyze reviewed | `design-review-report.md` + PASS 시 `reviewed/` 5개 + cross-check + deliverable 자동 연쇄 | 🟢 안전망 | best | **진입 조건**: `reviewed/` 5개 design 파일 |
| 13 | 2.7 | UAT 체크리스트 | `/design-tc` | `design/reviewed/{screen, api, db}.md` | `docs/02.design/tc/uat-checklist.md` | 🔵 필수 | balanced | ⚙️ 재실행 시 `reviewed/tc/uat-checklist.md` 자동 삭제 |
| 14 | 3.1 | DB 구현 | `/build-db` | `design/reviewed/db.md` | 소스코드 (마이그레이션, 스키마) | 🔵 필수 | balanced | ⚙️ 재실행 시 `impact-check.md` + `review/reviewed/report.md` 자동 삭제 |
| 15 | 3.2 | API 구현 | `/build-api` | `design/reviewed/{api, db}.md` | 소스코드 (라우터, 서비스) | 🔵 필수 | balanced | ⚙️ 동일 (위) |
| 16 | 3.3 | 화면 구현 | `/build-screen` | `design/reviewed/{screen, api}.md` | 소스코드 (페이지, 컴포넌트) | 🔵 필수 | balanced | ⚙️ 동일 (위) |
| 17 | 3.5 | 변경 영향도 검사 | `/impact-check` | `analyze/reviewed/gap.md` + `git diff` | `docs/03.build/impact-check.md` | 🟢 안전망 | best | 재실행 시 `review/reviewed/report.md` 자동 삭제 |
| 18 | 4 | 코드 리뷰 | `/review-all` | `design/reviewed/*` + 소스코드 + `impact-check.md` | `docs/04.review/report.md` + PASS 시 `reviewed/report.md` | 🟢 안전망 | best | **진입 조건**: `review/reviewed/report.md` |
| 19 | 5.1 | DB 테스트 | `/test-db` | `design/reviewed/db.md` + 스키마 | `docs/05.test/report-db.md` | 🔵 필수 | fast | ⚙️ 재실행 시 `reviewed/report-db.md` + `cross-check.md` 자동 삭제 |
| 20 | 5.2 | API 테스트 | `/test-api` | `design/reviewed/api.md` + 코드 | `docs/05.test/report-api.md` | 🔵 필수 | fast | ⚙️ 동일 (위) |
| 21 | 5.3 | 화면 테스트 | `/test-screen` | `design/reviewed/screen.md` + 코드 | `docs/05.test/report-screen.md` | 🔵 필수 | fast | ⚙️ 동일 (위) |
| 22 | 5.4 | E2E 테스트 | `/test-e2e` | `analyze/reviewed/req.md` + 전체 코드 | `docs/05.test/report-e2e.md` + PASS 시 `manual-testcases.md` 자동 생성 | 🔵 필수 | balanced | ⚙️ 동일 (위) |
| 23 | 5.5 | Chrome UI 지시문 | `/test-ui-chrome` | `docs/02.design/tc/uat-checklist.md` | `ui-test-chrome.md` + `.xlsx` | ⚪ 선택 | balanced | — |
| 24 | 5.6 | 테스트 교차검증 | `/cross-check-test` | `docs/05.test/report-*.md` (원본) + `analyze/reviewed/req.md` | `cross-check.md` + 4개 보고서 `reviewed/` 일괄 복사 | 🟢 안전망 | fast | **진입 조건**: `test/reviewed/report-*` 4개 |
| 25 | 5.7 | Dev 배포 | `/deploy-dev` | `test/reviewed/` + `uat-checklist.md` | `docs/06.deploy/deploy-dev.md` + Dev 배포 | 🟢 안전망 | fast | ⚙️ 진입 조건: test/reviewed/ 4개 보고서 + UAT 진입 |
| 26 | 6 | UAT (사람) | (수동) | `uat-checklist.md` (QA 수행) | `docs/06.deploy/uat-result.md` | 🟢 안전망 | — | 운영 배포 진입 조건: 전체 PASS |
| 27 | 7 | 운영 배포 | `/deploy-prd` | `uat-result.md` (PASS) + `test/reviewed/` | `docs/06.deploy/deploy-prd.md` + 운영 배포 | 🟢 안전망 | balanced | ⚙️ 진입 조건: test/reviewed/ 4개 + uat-result.md |

---

# 2. 운영 변경 — `pipeline-maintenance`

운영 중인 시스템에 대한 모든 변경(오류수정 / 기능개선 / 내부개선) 처리. **GAP 범위만** 진행하며, 마지막에 **CONTEXT 누적**으로 시스템 지식이 쌓입니다.

## 단계 전환 안전망 흐름도

```
[사전 1회]   /maintenance-init  ← 운영 시스템 진입 시 단 1번 (역공학 + CONTEXT 스켈레톤 생성)
                  ↓
[Phase 1]     변경 정의 (유형 / 요청자 / 변경 내용)
                  ↓
[Phase 1.5]   grill-task  ← CONTEXT 도메인 노트 우선 참조 + 모르는 것만 인터뷰
                  ↓
[Phase 1.6]   권장 Phase 흐름 합의 (이번 작업의 contract)
                  ↓
[Phase 2~4]   분석 (asis · requirements · gap, contract 에 따라 ⏭ 축약 가능)
                  ↓
              🟢 Phase 4.5 — review-analyze  ← PASS 시 reviewed/ 일괄 복사
                  ↓
[Phase 5]     영향 범위 설계 (GAP 있는 레이어만)
                  ↓
              🟢 Phase 5.5 — review-design  ← PASS 시 reviewed/ 복사
                  ↓
[Phase 5.7]   UAT 체크리스트 (Screen 변경 시, design-tc)
                  ↓
[Phase 6]     영향 범위 구현 (GAP 있는 레이어만, GAP 외 코드 건드리지 않음)
                  ↓
              🟢 Phase 6.5 — impact-check  ← 자동 강등: High 발견 시 ⏭ 표시됐던 Phase 자동 복원
                  ↓
              🟢 Phase 7 — review-all
                  ↓
[Phase 8]     AI 테스트 (변경 기능 + 회귀)
                  ↓
              🟢 cross-check-test  ← 4개 보고서 reviewed/ 일괄 복사
                  ↓
[Phase 8.5] 🟢 Dev 배포
                  ↓
[Phase 9]   🟢 UAT (사람)
                  ↓
[Phase 10]  🟢 운영 배포
                  ↓
[Phase 11]  🟢 변경 이력 + CONTEXT 반자동 갱신 (도메인 노트 누적)
```

## 전체 흐름

| # | Phase | 단계 | 호출 명령 | 입력 | 출력 | 필수 | 모델 | 안전망 / 무효화 |
|---|------|------|----------|------|------|------|------|---------|
| 0 | 사전 | 운영 시스템 초기화 (1회) | `/maintenance-init` | 기존 코드베이스 | `01.analyze/reviewed/{req, asis, gap}.md` + `02.design/reviewed/{db, api, screen}.md` + `docs/context/INDEX.md` + 도메인 노트 스켈레톤 | 🔵 필수 (운영 진입 1회) | balanced | 재실행 시 기존 reviewed/ 덮어쓰기 확인 |
| 1 | 1 | 변경 정의 | (대화) | 사용자 변경 요청 | 변경 유형 / 요청자 / 내용 분류 | 🔵 필수 | — | — |
| 2 | 1.5 | 작업 단위 인터뷰 (Grill Task) | `/grill-task` | `docs/context/INDEX.md` + 작업 키워드 | `docs/00.input/grill-task-{YYYYMMDD}-{slug}.md` | 🔵 필수 (기본 진입점) | best | CONTEXT 우선 참조 → 모르는 것만 인터뷰 → contract 제안 |
| 3 | 1.6 | 권장 Phase 흐름 합의 | (대화) | grill-task Step 4 contract 제안 | 이번 작업의 진행 contract | 🟢 안전망 | — | 안전망 Phase 7건 (6.5/7/8/8.5/9/10/11) 절대 생략 불가 |
| 4 | 2 | AS-IS 분석 | `/analyze-asis` | 기존 코드 (변경 대상 주변) | `docs/01.analyze/asis.md` | 🔵 필수 (contract ⏭ 가능) | fast | 재실행 시 `reviewed/{asis, gap}.md` 삭제 |
| 5 | 3 | 변경 요구사항 정의 | `/analyze-requirements` | grill-task 결과 + Phase 1 변경 정의 | `docs/01.analyze/requirements.md` | 🔵 필수 (contract ⏭ 가능) | balanced | 재실행 시 `reviewed/{req, gap}.md` 삭제 |
| 6 | 4 | GAP 분석 (작업 범위 확정) | `/analyze-gap` | `docs/01.analyze/{req, asis}.md` | `docs/01.analyze/gap.md` ← **이후 모든 단계의 작업 목록** | 🔵 필수 | best | 재실행 시 `reviewed/gap.md` 삭제 |
| 7 | 4.5 | 분석 종합 리뷰 | `/review-analyze` | `docs/01.analyze/*.md` (원본) | + PASS 시 `reviewed/` 일괄 복사 | 🟢 안전망 | best | **진입 조건**: `reviewed/` 3개 |
| 8 | 5.0 | Claude Design 프롬프트 | `/design-prompt-gen` | `analyze/reviewed/{req, gap}.md` | `docs/02.design/design-prompts.md` | ⚪ 선택 (Screen 변경 시) | balanced | ⚙️ 진입 조건: analyze reviewed/ 필요 |
| 9 | 5 | 영향 범위 설계 | `/design-screen` `/design-db` `/design-api` (해당 레이어만) | `analyze/reviewed/gap.md` 기반 | `docs/02.design/{screen, db, api, ...}.md` (변경 부분만 병합) | 🔵 필수 (해당 레이어) | balanced | ⚙️ 재실행 시 `reviewed/` 의존 파일 자동 삭제. **GAP 외 레이어는 건드리지 않음** |
| 10 | 5.5 | 설계 종합 리뷰 | `/review-design` | `docs/02.design/*.md` (원본) | + PASS 시 `reviewed/` 복사 + cross-check + deliverable | 🟢 안전망 | best | **진입 조건**: `reviewed/` |
| 11 | 5.7 | UAT 체크리스트 | `/design-tc` | `design/reviewed/{screen, api, db}.md` | `docs/02.design/tc/uat-checklist.md` (신규/병합) | ⚪ 선택 (Screen 변경 시) | balanced | ⚙️ 진입 조건: design reviewed/ 필요 |
| 12 | 6 | 영향 범위 구현 | `/build-db` `/build-api` `/build-screen` (해당 레이어만) | `design/reviewed/{db, api, screen}.md` | 소스코드 (변경 범위만) | 🔵 필수 (해당 레이어) | balanced | ⚙️ 재실행 시 `impact-check.md` + `review/reviewed/report.md` 자동 삭제. **GAP 외 코드 건드리지 않음** |
| 13 | 6.5 | 변경 영향도 검사 (자동 강등) | `/impact-check` | `analyze/reviewed/gap.md` + `git diff` | `docs/03.build/impact-check.md` | 🟢 안전망 | best | **자동 강등**: High 발견 시 contract ⏭ 표시됐던 Phase 자동 복원. 계획 외 레이어 변경 시 해당 design 재실행 |
| 14 | 7 | 코드 리뷰 | `/review-all` | impact-check.md High/Medium 중점 | `docs/04.review/report.md` + PASS 시 `reviewed/report.md` | 🟢 안전망 | best | **진입 조건**: `review/reviewed/report.md` |
| 15 | 8 | 변경 기능 테스트 (GAP만) | `/test-db` `/test-api` `/test-screen` | `design/reviewed/*` + 코드 | `docs/05.test/report-{type}.md` | 🔵 필수 (해당 레이어) | fast | ⚙️ 재실행 시 `reviewed/report-*` + `cross-check.md` 자동 삭제 |
| 16 | 8 | 회귀 테스트 | (test-* 안에서) | `impact-check.md` 회귀 대상 | report 안 회귀 결과 포함 | 🟢 안전망 (High 필수) | fast | High 실패 시 흐름 중단 + 사용자 보고 |
| 17 | 8 | E2E 테스트 | `/test-e2e` | 변경 전 흐름 + 신규 흐름 모두 | `docs/05.test/report-e2e.md` | 🔵 필수 | balanced | ⚙️ 재실행 시 `reviewed/report-e2e.md` 삭제 |
| 18 | 8 | Chrome UI 지시문 | `/test-ui-chrome` | `docs/02.design/tc/uat-checklist.md` | `ui-test-chrome.md` + `.xlsx` | ⚪ 선택 (Screen 변경 시) | balanced | — |
| 19 | 8 | 테스트 교차검증 | `/cross-check-test` | `docs/05.test/report-*` (원본) | `cross-check.md` + 4개 `reviewed/` 일괄 복사 | 🟢 안전망 | fast | **진입 조건**: `test/reviewed/report-*` 4개 |
| 20 | 8.5 | Dev 배포 | `/deploy-dev` | `test/reviewed/` + `uat-checklist.md` | `docs/06.deploy/deploy-dev.md` | 🟢 안전망 | fast | ⚙️ 진입 조건: test/reviewed/ 4개 + UAT 진입 |
| 21 | 9 | UAT (사람) | (수동) | `uat-checklist.md` (QA 수행) | `docs/06.deploy/uat-result.md` | 🟢 안전망 | — | 운영 배포 진입 |
| 22 | 10 | 운영 배포 | `/deploy-prd` | `uat-result.md` (PASS) | `docs/06.deploy/deploy-prd.md` | 🟢 안전망 | balanced | ⚙️ 진입 조건: test/reviewed/ + uat-result.md |
| 23 | 11.1 | 변경 이력 기록 | (작성) | 작업 산출물 전체 | `docs/change-requests.md` (이력 누적) | 🟢 안전망 | — | 유형 / 요청자 / 영향 범위 / 관련 도메인 |
| 24 | 11.2 | **CONTEXT 반자동 갱신** | (Claude 후보 추출 → 사용자 체크박스) | grill-task 결과 + gap + impact-check + 새 사실 | `docs/context/{domain}.md` append + INDEX 최근 갱신일 업데이트 | 🟢 안전망 | balanced | **다음 작업의 grill-task에서 활용** → 시스템이 점점 똑똑해진다 |

---

## 신규 vs 운영 — 핵심 차이

| 항목 | 신규 개발 (pipeline-full) | 운영 변경 (pipeline-maintenance) |
|---|---|---|
| 사전 단계 | `project-setup` (1회) | `maintenance-init` (운영 진입 1회, 역공학 + CONTEXT 스켈레톤) |
| 진입점 | `grill-me` (큰 주제) — 선택 | **`grill-task`** (작업 단위, CONTEXT 참조) — 기본 진입 |
| 동적 흐름 | 모든 Phase 진행 | **권장 흐름 contract** 합의 → ⏭ 축약 가능 |
| 범위 | 전체 시스템 | **GAP 범위만** (GAP 외 코드 건드리지 않음) |
| AS-IS / GAP | 사실상 N/A (조건부) | **핵심 단계** (작업 목록 확정) |
| 자동 강등 | 없음 | impact-check High → ⏭ Phase 자동 복원 |
| 회귀 테스트 | 없음 (신규라 회귀 대상 없음) | **필수**: impact-check 기준 High 항목 차단 |
| 학습 자산 | 없음 | **CONTEXT 누적** (Phase 11) — 도메인 노트가 작업할수록 풍부해짐 |

---

## `reviewed/` 의미 통일 (양 파이프라인 공통)

각 단계의 "리뷰" 가 PASS 한 시점의 사본만 `reviewed/` 폴더에 들어갑니다. 다음 단계는 `reviewed/` 만 읽으면 자동 안전 보장.

| 단계 | "리뷰" 역할 | reviewed/ 경로 |
|---|---|---|
| 분석 | `review-analyze` | `docs/01.analyze/reviewed/` |
| 설계 | `review-design` | `docs/02.design/reviewed/` |
| 구현 | `review-all` | `docs/04.review/reviewed/` |
| 테스트 | `cross-check-test` | `docs/05.test/reviewed/` |

---

## `/grill-me` 단계 인지형 자유 호출 (v2.4.16+)

`/grill-me` 는 분석 단계 시작 전뿐 아니라 **설계/구현/테스트 진행 중에도 자유롭게 호출 가능**합니다. 호출 시점의 단계에 맞는 위치에 누적 저장되며, 후속 스킬이 사전 동작에서 자동으로 읽어 반영합니다.

| 호출 단계 | 저장 위치 | 반영하는 후속 스킬 |
|----------|----------|------------------|
| analyze | `docs/00.input/grill-result.md` | `analyze-requirements` |
| design  | `docs/02.design/grill-decisions.md` | `design-db`, `design-api`, `design-screen`, `design-tc`, `design-integration`, `design-process` |
| build   | `docs/03.build/grill-decisions.md` | `build-db`, `build-api`, `build-screen` |
| test    | `docs/05.test/grill-decisions.md` | `test-db`, `test-api`, `test-screen`, `test-e2e` |

**저장 방식**: 같은 단계에서 여러 번 호출하면 파일 하단에 `## 인터뷰 {N} — YYYY-MM-DD HH:MM — {주제}` 헤더로 새 블록이 추가됩니다 (덮어쓰기 X).

**사용 예시 (설계 단계)**:
```
1) /design-api 진행 중 페이지네이션 방식이 모호 → /grill-me 호출
2) grill-me 가 "설계 단계" 자동 인식 후 사용자 확인
3) 인터뷰 결과 → docs/02.design/grill-decisions.md 에 추가
4) /design-api 재실행 → 사전 동작에서 grill-decisions.md 자동 읽기 → 결정 반영
```

**원본 산출물 변경 시 → `reviewed/` 의 해당 파일과 의존 파일이 자동 무효화 (스킬 사전 동작)**. 따라서 다음 단계 진입을 위해 리뷰를 다시 받아야 합니다.

---

> 마지막 갱신: 2026-05-20 (CHANGELOG v2.4.10 참조)

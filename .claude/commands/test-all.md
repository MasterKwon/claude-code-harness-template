# 테스트 단계 전체 실행

테스트 4단계를 순서대로 실행합니다. 각 단계 완료 후 자동으로 품질을 검증하고, 통과하면 `reviewed/`로 승격합니다.

> **Agent 위임 규칙**: `[fast]`, `[balanced]`, `[best]` 태그는 CLAUDE.md 모델 티어 기준으로 Agent를 생성하여 위임합니다. 태그 없는 단계는 현재 모델로 직접 실행합니다.

## 사전 조건 확인
구현 단계(`/build-all`)가 완료되어 소스코드가 존재해야 합니다.

---

## Step 1 — DB 테스트

[fast] Read `.claude/skills/test-db.md` and follow all instructions.
산출물: `docs/05.test/report-db.md`

### 자동 품질 게이트
- [ ] `docs/02.design/reviewed/db.md`의 모든 테이블 검증 완료
- [ ] FK/UNIQUE 제약 조건 동작 확인
- [ ] 마이그레이션 rollback(down) 검증 완료
- [ ] 실패 항목에 원인 및 조치 방안 명시

**실패 항목 있으면**:
  - DB 구현 오류 → `/refine-build-db` 실행 후 재테스트
  - DB 설계 오류 → `/refine-design-db` → `/refine-build-db` 후 재테스트
**모두 통과하면**: `docs/05.test/report-db.md`를 `docs/05.test/reviewed/report-db.md`로 복사 후 Step 2로 진행.

---

## Step 2 — API 테스트

[fast] Read `.claude/skills/test-api.md` and follow all instructions.
산출물: `docs/05.test/report-api.md`

### 자동 품질 게이트
- [ ] `docs/02.design/reviewed/api.md`의 모든 엔드포인트 테스트 완료
- [ ] 인증/인가 케이스(401/403) 테스트 완료
- [ ] 경계값 테스트 완료
- [ ] 실패 항목에 원인 및 조치 방안 명시

**실패 항목 있으면**:
  - API 구현 오류 → `/refine-build-api` 실행 후 재테스트
  - API 설계 오류 → `/refine-design-api` → `/refine-build-api` 후 재테스트
**모두 통과하면**: `docs/05.test/report-api.md`를 `docs/05.test/reviewed/report-api.md`로 복사 후 Step 3으로 진행.

---

## Step 3 — 화면 테스트

[fast] Read `.claude/skills/test-screen.md` and follow all instructions.
산출물: `docs/05.test/report-screen.md`

### 자동 품질 게이트
- [ ] `docs/02.design/reviewed/screen.md`의 모든 페이지 테스트 완료
- [ ] 페이지 이동 흐름 테스트 완료
- [ ] 에러/로딩 상태 테스트 완료
- [ ] 실패 항목에 원인 및 조치 방안 명시

**실패 항목 있으면**:
  - 화면 구현 오류 → `/refine-build-screen` 실행 후 재테스트
  - 화면 설계 오류 → `/refine-design-screen` → `/refine-build-screen` 후 재테스트
**모두 통과하면**: `docs/05.test/report-screen.md`를 `docs/05.test/reviewed/report-screen.md`로 복사 후 Step 4로 진행.

---

## Step 4 — E2E 테스트

Step 1~3의 reviewed 보고서가 모두 존재하는 것을 확인 후 진행.
Read `.claude/skills/test-e2e.md` and follow all instructions.
산출물: `docs/05.test/report-e2e.md`

### 자동 품질 게이트
- [ ] `docs/01.analyze/reviewed/requirements.md`의 모든 핵심 시나리오 테스트 완료
- [ ] 서비스 간 데이터 일관성 검증 완료
- [ ] 에러 전파 테스트 완료
- [ ] 실패 항목에 원인 및 조치 방안 명시

**실패 항목 있으면**: 롤백 맵(`/pipeline-full` 참조)을 기준으로 원인 단계 특정 후 조치.
**모두 통과하면**: `docs/05.test/report-e2e.md`를 `docs/05.test/reviewed/report-e2e.md`로 복사 후 Step 5로 진행.

---

## Step 5 — Claude in Chrome UI 테스트 지시문 생성 (Bridge)

> AI 자동 테스트가 모두 통과한 뒤, **사람이 Chrome 사이드패널로 한 번 더 검증**할 수 있도록 지시문과 체크리스트를 준비합니다.
> 동일 TC 를 AI(자동)와 사람(Chrome)이 이중 검증하여 자동화가 놓친 시각·UX 이슈를 잡습니다.

사전 조건: `docs/02.design/tc/uat-checklist.md` 존재.

[balanced] Read `.claude/skills/test-ui-chrome.md` and follow all instructions.

산출물:
- `docs/05.test/ui-test-chrome.md` (Chrome 사이드패널 지시문)
- `docs/05.test/ui-test-chrome.xlsx` (QA 체크리스트 템플릿)

### 자동 품질 게이트
- [ ] `docs/02.design/tc/uat-checklist.md` 의 모든 TC 가 Chrome 지시문으로 변환됨
- [ ] xlsx 가 정상 생성됨 (헤더, 행 수 일치)
- [ ] 사람에게 다음 행동(`_result.xlsx` 작성) 안내 포함

---

테스트 단계 완료. 사용자에게 묻지 말고 즉시 [fast] `.claude/skills/cross-check-test.md` 스킬을 연계 실행하여 `docs/05.test/cross-check.md`를 생성합니다.
생성 완료 후 최종 결과를 보고합니다.

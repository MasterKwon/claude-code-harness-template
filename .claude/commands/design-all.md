# 설계 단계 전체 실행

설계 5단계를 순서대로 실행하고, 마지막에 `review-design` 으로 종합 리뷰하여 PASS 시 `reviewed/` 로 승격합니다.

> **`reviewed/` 의 의미**: `review-design` 이 PASS 판정을 내린 시점의 사본만 들어갑니다. 자동 품질 게이트만 통과한 상태로는 들어가지 않습니다 (다음 단계 진입 안전망).

## 사전 조건 확인
`docs/01.analyze/reviewed/requirements.md` 또는 `docs/01.analyze/reviewed/gap.md` 중 하나가 반드시 존재해야 합니다.
없으면 `/analyze-all`을 먼저 실행하도록 안내하세요.

---

## Step 1 — 프로세스 정의
Read `.claude/skills/design-process.md` and follow all instructions.
산출물: `docs/02.design/process.md` (원본 위치)

> 스킬 본문 "사전 동작" 에 따라 실행 시 `reviewed/process.md` 자동 삭제.

### 자동 품질 게이트
- [ ] 핵심 비즈니스 흐름 도출 여부
- [ ] 예외 케이스 처리 정책 명시

**미흡 시**: 보완 후 재검증. **통과 시**: Step 2 진행 (`reviewed/` 복사는 Step 6 review-design PASS 시점).

---

## Step 2 — 화면 설계
Read `.claude/skills/design-screen.md` and follow all instructions.
산출물: `docs/02.design/screen.md` (원본 위치)

> 사전 동작: `reviewed/{screen, api, tc/uat-checklist}.md` 자동 삭제 (api·tc 는 screen 의존).

### 자동 품질 게이트
- [ ] 프로세스에 정의된 흐름이 모두 화면으로 구현됨
- [ ] 인터랙션 및 컴포넌트 명세

**미흡 시**: 보완 후 재검증. **통과 시**: Step 3 진행.

---

## Step 3 — API 명세 설계
Read `.claude/skills/design-api.md` and follow all instructions.
산출물: `docs/02.design/api.md` (원본 위치)

> 사전 동작: `reviewed/{api, tc/uat-checklist}.md` 자동 삭제. 입력은 `docs/02.design/{screen, db}.md` (원본 위치).

### 자동 품질 게이트
- [ ] 화면의 모든 데이터 통신이 API로 정의됨
- [ ] 에러 코드 및 응답 스키마 명시

**미흡 시**: 보완 후 재검증. **통과 시**: Step 4 진행.

---

## Step 4 — DB 명세 설계
Read `.claude/skills/design-db.md` and follow all instructions.
산출물: `docs/02.design/db.md` (원본 위치)

> 사전 동작: `reviewed/{db, api, tc/uat-checklist}.md` 자동 삭제 (api·tc 는 db 의존).

### 자동 품질 게이트
- [ ] API와 프로세스를 수용할 수 있는 엔티티 및 속성 도출
- [ ] 관계(ERD) 및 제약조건 명시

**미흡 시**: 보완 후 재검증. **통과 시**: Step 5 진행.

---

## Step 5 — 외부시스템 연계 정의
Read `.claude/skills/design-integration.md` and follow all instructions.
산출물: `docs/02.design/integration.md` (원본 위치)

> 사전 동작: `reviewed/integration.md` 자동 삭제.

### 자동 품질 게이트
- [ ] 연동 프로토콜 및 인증 방식 명시 (해당 시)
- [ ] N/A 처리의 경우 명확한 사유 존재

**미흡 시**: 보완 후 재검증. **통과 시**: Step 6 진행.

---

## Step 6 — 설계 종합 리뷰 (필수)

다섯 산출물을 종합 검토하여 다음 단계 진입 여부를 확정합니다. **이 Step 을 건너뛰면 `reviewed/` 가 비어 있어 design-tc, build-* 가 진입을 거부합니다.**

[best] Read `.claude/skills/review-design.md` and follow all instructions.
산출물: `docs/02.design/design-review-report.md`

- **PASS 시 자동 동작** (review-design.md 안에 명시):
  1. 다섯 파일을 `docs/02.design/reviewed/` 로 일괄 복사
  2. `deliverable-design.md` 실행 — 고객용 보고서 생성
  3. `cross-check-design.md` 실행 — 타 LLM 교차검증 브리핑 생성
- **FAIL 시**: 문제 문서별 `/refine-design-{screen|db|api|process|integration}` 로 보완 후 Step 6 재실행

---

설계 5+1 단계 완료. `reviewed/` 에 다섯 파일이 모두 들어간 것을 확인한 후 `/design-tc` (UAT 체크리스트) → `/build-all` 로 진행합니다.

# 설계 단계 전체 실행

설계 5단계를 순서대로 실행합니다. 각 단계 완료 후 자동으로 품질을 검증하고, 통과하면 `reviewed/`로 승격합니다.

## 사전 조건 확인
`docs/01.analyze/reviewed/requirements.md` 또는 `docs/01.analyze/reviewed/gap.md` 중 하나가 반드시 존재해야 합니다.
없으면 `/analyze-all`을 먼저 실행하도록 안내하세요.

---

## Step 1 — 프로세스 정의
Read `.claude/skills/design-process.md` and follow all instructions.
산출물: `docs/02.design/process.md`

### 자동 품질 게이트
- [ ] 핵심 비즈니스 흐름 도출 여부
- [ ] 예외 케이스 처리 정책 명시
**미흡 시**: 보완 후 재검증. **통과 시**: `reviewed/process.md`로 복사 후 Step 2 진행.

---

## Step 2 — 화면 설계
Read `.claude/skills/design-screen.md` and follow all instructions.
산출물: `docs/02.design/screen.md`

### 자동 품질 게이트
- [ ] 프로세스에 정의된 흐름이 모두 화면으로 구현됨
- [ ] 인터랙션 및 컴포넌트 명세
**미흡 시**: 보완 후 재검증. **통과 시**: `reviewed/screen.md`로 복사 후 Step 3 진행.

---

## Step 3 — API 명세 설계
Read `.claude/skills/design-api.md` and follow all instructions.
산출물: `docs/02.design/api.md`

### 자동 품질 게이트
- [ ] 화면의 모든 데이터 통신이 API로 정의됨
- [ ] 에러 코드 및 응답 스키마 명시
**미흡 시**: 보완 후 재검증. **통과 시**: `reviewed/api.md`로 복사 후 Step 4 진행.

---

## Step 4 — DB 명세 설계
Read `.claude/skills/design-db.md` and follow all instructions.
산출물: `docs/02.design/db.md`

### 자동 품질 게이트
- [ ] API와 프로세스를 수용할 수 있는 엔티티 및 속성 도출
- [ ] 관계(ERD) 및 제약조건 명시
**미흡 시**: 보완 후 재검증. **통과 시**: `reviewed/db.md`로 복사 후 Step 5 진행.

---

## Step 5 — 외부시스템 연계 정의
Read `.claude/skills/design-integration.md` and follow all instructions.
산출물: `docs/02.design/integration.md`

### 자동 품질 게이트
- [ ] 연동 프로토콜 및 인증 방식 명시 (해당 시)
- [ ] N/A 처리의 경우 명확한 사유 존재
**미흡 시**: 보완 후 재검증. **통과 시**: `reviewed/integration.md`로 복사.

설계 5단계 완료. 이후 `/review-design`을 실행할 수 있습니다.

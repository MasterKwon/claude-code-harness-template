# 구현 단계 전체 실행

구현 3단계를 순서대로 실행합니다. 각 단계 완료 후 자동으로 품질을 검증하고, 통과하면 `reviewed/`에 체크리스트를 기록합니다.

## 사전 조건 확인
`docs/02.design/reviewed/screen.md`, `docs/02.design/reviewed/db.md`, `docs/02.design/reviewed/api.md`가 모두 존재해야 합니다.
없으면 `/design-all`을 먼저 실행하도록 안내하세요.

---

## Step 1 — DB 구현

의존성이 없는 기반 레이어부터 구현합니다.
Read `.claude/skills/build-db.md` and follow all instructions.

### 자동 품질 게이트
- [ ] `docs/02.design/reviewed/db.md`의 모든 테이블 구현
- [ ] FK 제약 조건 적용
- [ ] 인덱스 생성
- [ ] up/down 마이그레이션 쌍 존재

**미흡 항목 있으면**: 해당 항목만 보완 후 재검증.
**모두 통과하면**: `docs/03.build/reviewed/checklist.md`에 DB 구현 완료 기록 후 Step 2로 진행.

---

## Step 2 — API 구현

Read `.claude/skills/build-api.md` and follow all instructions.

### 자동 품질 게이트
- [ ] `docs/02.design/reviewed/api.md`의 모든 엔드포인트 구현
- [ ] 요청 유효성 검사 적용
- [ ] HTTP 상태코드 설계서와 일치
- [ ] 에러 응답 형식 통일
- [ ] 인증 미들웨어 연결

**미흡 항목 있으면**: 해당 항목만 보완 후 재검증.
**모두 통과하면**: `docs/03.build/reviewed/checklist.md`에 API 구현 완료 기록 후 Step 3으로 진행.

---

## Step 3 — 화면 구현

Read `.claude/skills/build-screen.md` and follow all instructions.

### 자동 품질 게이트
- [ ] `docs/02.design/reviewed/screen.md`의 모든 페이지 구현
- [ ] 페이지 간 이동(Link/router) 연결
- [ ] API 호출 연결
- [ ] 로딩/에러 상태 처리

**미흡 항목 있으면**: 해당 항목만 보완 후 재검증.
**모두 통과하면**: `docs/03.build/reviewed/checklist.md`에 화면 구현 완료 기록 후 Step 4로 진행.

---

## Step 4 — 변경 영향도 검사

[best] Read `.claude/skills/impact-check.md` and follow all instructions.
산출물: `docs/03.build/impact-check.md`

> impact-check 의 사전 동작에 따라 실행 시 `docs/04.review/reviewed/report.md` 가 자동 삭제됩니다 (영향도 재분석 → 리뷰 재실행).

---

## Step 5 — 코드 리뷰 (필수)

다음 단계(`/test-all`) 진입 안전망. **이 Step 을 건너뛰면 `docs/04.review/reviewed/report.md` 가 비어 있어 test 단계가 진입을 거부합니다.**

[best] Read `.claude/skills/review-all.md` and follow all instructions.
산출물: `docs/04.review/report.md`

- **PASS 시 자동 동작** (review-all.md 안에 명시): `docs/04.review/reviewed/report.md` 로 복사 → `/test-all` 진입 가능
- **FAIL 시**: 문제 항목별 `/refine-build-{db|api|screen}` 로 보완 후 Step 4 부터 재실행 (build-* 사전 동작이 reviewed/ 자동 무효화)

---

구현 단계 완료. `docs/04.review/reviewed/report.md` 가 생성된 것을 확인한 후 `/test-all` 로 진행하세요.

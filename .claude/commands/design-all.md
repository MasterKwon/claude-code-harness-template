# 설계 단계 전체 실행

설계 3단계를 순서대로 실행합니다. 각 단계 완료 후 자동으로 품질을 검증하고, 통과하면 `reviewed/`로 승격합니다.

## 사전 조건 확인
`docs/01.analyze/reviewed/requirements.md` 또는 `docs/01.analyze/reviewed/gap.md` 중 하나가 반드시 존재해야 합니다.
없으면 `/analyze-all`을 먼저 실행하도록 안내하세요.

---

## Step 1 — 화면 설계

Read `.claude/skills/design-screen.md` and follow all instructions.
산출물: `docs/02.design/screen.md`

### 자동 품질 게이트
- [ ] 요구사항의 모든 화면이 페이지 목록에 존재
- [ ] 페이지 흐름도 존재
- [ ] 각 페이지에 주요 컴포넌트 및 인터랙션 정의
- [ ] 각 페이지에 호출 API 명시
- [ ] 공통 컴포넌트 섹션 존재

**미흡 항목 있으면**: 해당 항목만 `docs/02.design/screen.md`에 보완 후 재검증.
**모두 통과하면**: `docs/02.design/screen.md`를 `docs/02.design/reviewed/screen.md`로 복사 후 Step 2로 진행.

---

## Step 2 — DB 설계

Read `.claude/skills/design-db.md` and follow all instructions.
산출물: `docs/02.design/db.md`

### 자동 품질 게이트
- [ ] 엔티티 관계 다이어그램 존재
- [ ] 모든 테이블에 컬럼 타입 및 제약(PK/FK/UNIQUE/NOT NULL) 명시
- [ ] 인덱스 전략 섹션 존재
- [ ] 설계 결정 사항(트레이드오프) 기술

**미흡 항목 있으면**: 해당 항목만 `docs/02.design/db.md`에 보완 후 재검증.
**모두 통과하면**: `docs/02.design/db.md`를 `docs/02.design/reviewed/db.md`로 복사 후 Step 3으로 진행.

---

## Step 3 — API 설계

`docs/02.design/reviewed/screen.md`, `docs/02.design/reviewed/db.md` 존재 확인 후 진행.
Read `.claude/skills/design-api.md` and follow all instructions.
산출물: `docs/02.design/api.md`

### 자동 품질 게이트
- [ ] 화면의 모든 API 호출이 엔드포인트로 정의됨
- [ ] 모든 엔드포인트에 요청/응답 스키마 존재
- [ ] 모든 엔드포인트에 HTTP 상태코드(성공/실패) 정의
- [ ] 인증/인가 처리 방식 명시
- [ ] 공통 규칙(에러 형식, 페이지네이션) 존재

**미흡 항목 있으면**: 해당 항목만 `docs/02.design/api.md`에 보완 후 재검증.
**모두 통과하면**: `docs/02.design/api.md`를 `docs/02.design/reviewed/api.md`로 복사.

설계 단계 완료. 사용자에게 결과를 보고하고 다음 단계(`/build-all`) 진행 여부를 확인합니다.

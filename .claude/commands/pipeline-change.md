# 기존 프로젝트 변경 파이프라인

기능 추가 또는 수정 작업을 위한 파이프라인입니다.
신규 개발(`/pipeline-full`)과 달리 **AS-IS 분석이 먼저** 실행되고, **GAP이 작업 범위를 결정**합니다.

## 파이프라인 구조

```
[현황 파악]              [변경 정의]              [범위 확정]
analyze-asis         →  analyze-requirements  →  analyze-gap
(기존 코드 먼저)          (변경/추가할 것만)         (작업 목록 확정)

      ↓
[영향 범위만 설계]        [영향 범위만 구현]        [리뷰]
GAP 결과 기반            GAP 결과 기반             review-all

      ↓
[테스트]                                          [배포]
변경 기능 + 회귀 테스트                             ship
```

---

## 실행 순서

### Phase 1 — 현황 파악 (AS-IS)

> 기존 코드를 먼저 파악하지 않으면 변경 범위를 특정할 수 없습니다.
> **기술 스택은 사용자에게 묻지 않습니다.** `analyze-asis.md`의 Step 0에서 파일을 읽어 자동 감지합니다.

Read `.claude/skills/analyze-asis.md` and follow all instructions.
산출물: `docs/01.analyze/asis.md`

#### 자동 품질 게이트
- [ ] 변경 대상과 관련된 화면/API/DB 구조 파악 완료
- [ ] 기존 데이터 흐름 파악 완료
- [ ] 현재 이슈 또는 제약사항 파악 완료

**모두 통과하면**: `docs/01.analyze/asis.md`를 `docs/01.analyze/reviewed/asis.md`로 복사 후 Phase 2 진행.

---

### Phase 2 — 변경 요구사항 분석

Read `.claude/skills/analyze-requirements.md` and follow all instructions.
산출물: `docs/01.analyze/requirements.md`

> 전체 시스템이 아닌 **변경/추가할 기능만** 정의합니다.
> "기존 기능 A는 유지한다"는 명시적으로 기록하지 않아도 됩니다.

#### 자동 품질 게이트
- [ ] 수정 항목과 신규 항목이 명확히 구분되어 있는가
- [ ] Must/Should/Could 우선순위 부여
- [ ] [질문 필요] 항목 없거나 명시적 보류 처리

**모두 통과하면**: `docs/01.analyze/requirements.md`를 `docs/01.analyze/reviewed/requirements.md`로 복사 후 Phase 3 진행.

---

### Phase 3 — GAP 분석 (작업 범위 확정) ← 핵심

`docs/01.analyze/reviewed/asis.md`, `docs/01.analyze/reviewed/requirements.md` 확인 후 진행.
Read `.claude/skills/analyze-gap.md` and follow all instructions.
산출물: `docs/01.analyze/gap.md`

> GAP 분석 결과가 이후 모든 단계의 작업 목록이 됩니다.
> 레이어별로 **신규 / 변경 / 유지 / 제거** 를 명확히 분류하세요.

#### 자동 품질 게이트
- [ ] Screen / API / DB 3개 영역 모두 분류 완료
- [ ] 각 항목에 신규/변경/유지/제거 명시
- [ ] 각 항목에 영향도(High/Medium/Low) 부여
- [ ] 권장 작업 순서 존재

**모두 통과하면**: `docs/01.analyze/gap.md`를 `docs/01.analyze/reviewed/gap.md`로 복사.

**→ GAP 분석 완료 후 반드시 사용자 확인을 받고 다음 Phase로 진행하세요.**
사용자가 범위를 조정할 수 있는 마지막 지점입니다.

---

### Phase 4 — 영향 범위 설계

`docs/01.analyze/reviewed/gap.md`를 읽고 **신규/변경 항목이 있는 레이어만** 설계합니다.

#### 레이어별 실행 여부 판단

```
GAP에 Screen 신규/변경 항목 있음  → Read `.claude/skills/design-screen.md` and follow all instructions.
GAP에 DB 신규/변경 항목 있음      → Read `.claude/skills/design-db.md` and follow all instructions.
GAP에 API 신규/변경 항목 있음     → Read `.claude/skills/design-api.md` and follow all instructions.
해당 레이어 GAP 항목 없음         → 해당 설계 단계 건너뜀
```

> 기존 설계 문서(`docs/02.design/reviewed/`)가 있다면 덮어쓰지 말고,
> 변경/추가 내용만 해당 문서에 **병합**합니다.

**→ 설계 완료 후 사용자 확인을 받고 다음 Phase로 진행하세요.**

---

### Phase 5 — 영향 범위 구현

`docs/01.analyze/reviewed/gap.md`를 읽고 **신규/변경 항목이 있는 레이어만** 구현합니다.

```
GAP에 DB 신규/변경 항목 있음      → Read `.claude/skills/build-db.md` and follow all instructions.
GAP에 API 신규/변경 항목 있음     → Read `.claude/skills/build-api.md` and follow all instructions.
GAP에 Screen 신규/변경 항목 있음  → Read `.claude/skills/build-screen.md` and follow all instructions.
```

> 기존 코드를 수정할 때는 반드시 기존 로직을 먼저 읽고 영향 범위를 파악한 후 수정합니다.
> GAP에 없는 코드는 건드리지 않습니다.

**→ 구현 완료 후 사용자 확인을 받고 다음 Phase로 진행하세요.**

---

### Phase 6 — 리뷰

Read `.claude/skills/review-all.md` and follow all instructions.
산출물: `docs/04.review/report.md`

> 변경된 코드와 **기존 코드와의 연결 지점**을 중점 검토합니다.
> (수정된 API를 호출하는 기존 화면, 변경된 DB 컬럼을 쓰는 기존 로직 등)

**→ High 심각도 없으면** `docs/04.review/reviewed/report.md`로 복사 후 Phase 7 진행.

---

### Phase 7 — 테스트 (변경 기능 + 회귀)

#### 변경/신규 기능 테스트
GAP에 있는 항목만 테스트합니다.

```
GAP에 DB 신규/변경 있음     → Read `.claude/skills/test-db.md` and follow all instructions.
GAP에 API 신규/변경 있음    → Read `.claude/skills/test-api.md` and follow all instructions.
GAP에 Screen 신규/변경 있음 → Read `.claude/skills/test-screen.md` and follow all instructions.
```

#### 회귀 테스트 ← 신규 파이프라인과의 차이점

변경 사항이 기존 기능을 깨뜨리지 않았는지 확인합니다.

```
회귀 테스트 대상 식별:
1. 수정된 API를 호출하는 기존 화면/서비스
2. 변경된 DB 테이블/컬럼을 사용하는 기존 로직
3. 수정된 공통 컴포넌트를 사용하는 기존 화면
```

각 대상에 대해 **기존 동작이 유지되는지** 확인하고 결과를 테스트 보고서에 포함합니다.

#### E2E 테스트
Read `.claude/skills/test-e2e.md` and follow all instructions.

> E2E 시나리오에 **변경 전 기존 흐름도 포함**합니다.
> 새 기능만 통과해도 기존 흐름이 깨지면 실패입니다.

**→ 테스트 완료 후 사용자 확인을 받고 다음 Phase로 진행하세요.**

---

### Phase 8 — 배포

Read `.claude/skills/ship.md` and follow all instructions.
산출물: `docs/06.ship/checklist.md`

**→ 변경 파이프라인 완료.**

---

## 롤백 맵

```
문제 발견 위치          원인                       조치                              이후 재실행 범위
──────────────────────────────────────────────────────────────────────────────────────────────
[테스트 — 회귀 실패]
  기존 화면 깨짐       → 구현 부작용              /refine-build-{api|screen}        review-all, 해당 테스트
  기존 API 깨짐        → 구현 부작용              /refine-build-api                 review-all, test-api, test-e2e
  기존 DB 깨짐         → 마이그레이션 오류         /refine-build-db                  review-all, test-db 이후 전체

[테스트 — 신규 기능 실패]
  신규 화면 실패       → 구현 오류                /refine-build-screen              review-all, test-screen, test-e2e
  신규 API 실패        → 구현 오류                /refine-build-api                 review-all, test-api, test-e2e
  신규 DB 실패         → 구현 오류                /refine-build-db                  review-all, test-db 이후 전체

[구현 중]
  기존 코드 충돌       → AS-IS 분석 부족          /refine-analyze-asis              GAP 재확인 후 구현 재실행
  설계 누락 발견       → GAP 범위 오류            /refine-analyze-gap               영향 설계 재실행

[설계 중]
  기존 API 충돌        → AS-IS 분석 부족          /refine-analyze-asis              analyze-gap, 해당 설계 재실행
  범위 과다/과소       → 요구사항 불명확           /refine-analyze-requirements      analyze-gap, 설계 재실행
```

### 원칙
- GAP에 없는 코드를 건드렸다가 문제가 생기면 즉시 되돌립니다.
- 회귀 실패는 기존 코드 보호가 우선 — 신규 기능보다 기존 기능 복구를 먼저 합니다.
- 롤백 범위가 2단계 이상이면 사용자에게 범위를 먼저 확인하세요.

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
[AI QA - Local]         [Dev 배포]               [UAT]            [운영 배포]
변경 기능 + 회귀 테스트  →  deploy-dev           →  uat-checklist  →  ship
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

**모두 통과하면**: `docs/01.analyze/asis.md`를 `docs/01.analyze/reviewed/asis.md`로 복사 후 커밋:
```bash
git add docs/01.analyze/asis.md docs/01.analyze/reviewed/asis.md
git commit -m "change-phase1: analyze-asis 완료"
git push
```

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

**모두 통과하면**: `docs/01.analyze/requirements.md`를 `docs/01.analyze/reviewed/requirements.md`로 복사 후 커밋:
```bash
git add docs/01.analyze/requirements.md docs/01.analyze/reviewed/requirements.md
git commit -m "change-phase2: analyze-requirements 완료"
git push
```

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

사용자 확인 후 커밋:
```bash
git add docs/01.analyze/gap.md docs/01.analyze/reviewed/gap.md
git commit -m "change-phase3: analyze-gap 완료 — 작업 범위 확정"
git push
```

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

사용자 확인 후 커밋:
```bash
git add docs/02.design/
git commit -m "change-phase4: design 완료 (영향 범위만)"
git push
```

### Phase 4.5 — 설계 리뷰
Read `.claude/skills/review-design.md` and follow all instructions.
산출물: `docs/02.design/design-review-report.md`

- PASS → Phase 5로 진행
- FAIL (설계 문제만) → 해당 설계 스킬 Patch 모드 실행 후 재리뷰
- FAIL (분석 보완 사항 있음) → `/refine-analyze-requirements` → 영향 설계 재실행 → 재리뷰

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

사용자 확인 후 커밋:
```bash
git add .
git commit -m "change-phase5: build 완료 (영향 범위만)"
git push
```

---

### Phase 5.5 — 변경 영향도 검사

Phase 5 구현 완료 직후 실행합니다.
Read `.claude/skills/impact-check.md` and follow all instructions.
산출물: `docs/03.build/impact-check.md`

> GAP에서 계획한 변경 범위와 실제 구현된 변경 범위를 교차 검증합니다.
> 기존 기능에 미치는 영향을 파악하여 리뷰와 회귀 테스트 범위를 결정합니다.

**계획 외 변경 발견 시**: 작업 중단 후 사용자에게 보고. 의도된 변경이면 GAP에 추가, 아니면 롤백.
**High 영향도 항목 발견 시**: 사용자에게 보고하고 확인 후 Phase 6 진행.
**Medium 이하만 있으면**: 즉시 Phase 6으로 진행.

---

### Phase 6 — 리뷰

Read `.claude/skills/review-all.md` and follow all instructions.
산출물: `docs/04.review/report.md`

> `docs/03.build/impact-check.md`의 High/Medium 항목을 중점 검토합니다.
> (수정된 API를 호출하는 기존 화면, 변경된 DB 컬럼을 쓰는 기존 로직 등)

**→ High 심각도 없으면** `docs/04.review/reviewed/report.md`로 복사 후 커밋:
```bash
git add docs/04.review/
git commit -m "change-phase6: review-all 통과"
git push
```

---

### Phase 7 — AI 자동화 테스트 (Local)

> 로컬 환경에서 AI가 자동 실행하는 테스트입니다.

#### 변경/신규 기능 테스트
GAP에 있는 항목만 테스트합니다.

```
GAP에 DB 신규/변경 있음     → Read `.claude/skills/test-db.md` and follow all instructions.
GAP에 API 신규/변경 있음    → Read `.claude/skills/test-api.md` and follow all instructions.
GAP에 Screen 신규/변경 있음 → Read `.claude/skills/test-screen.md` and follow all instructions.
```

#### 회귀 테스트 ← 신규 파이프라인과의 차이점

`docs/03.build/impact-check.md`의 회귀 테스트 대상 목록을 참조합니다.

- **High 항목**: 반드시 테스트. 실패 시 릴리즈 차단.
- **Medium 항목**: 테스트. 실패 시 사용자에게 보고.
- **Low 항목**: 선택적으로 테스트.

각 대상에 대해 **기존 동작이 유지되는지** 확인하고 결과를 테스트 보고서에 포함합니다.

#### E2E 테스트
Read `.claude/skills/test-e2e.md` and follow all instructions.

> E2E 시나리오에 **변경 전 기존 흐름도 포함**합니다.
> 새 기능만 통과해도 기존 흐름이 깨지면 실패입니다.

**→ 테스트 완료 후 사용자 확인을 받고 다음 Phase로 진행하세요.**

사용자 확인 후 커밋:
```bash
git add docs/05.test/
git commit -m "change-phase7: test-all 통과 (변경 기능 + 회귀)"
git push
```

---

### Phase 7.5 — Dev 서버 배포

> UAT를 수행할 수 있는 Dev/Staging 서버에 배포합니다.

Read `.claude/skills/deploy-dev.md` and follow all instructions.

배포 완료 후:
- `docs/02.design/tc/uat-checklist.md` 를 QA 담당자에게 전달합니다.

---

### Phase 8 — UAT (Dev 환경)

> QA 담당자가 Dev 서버에서 `docs/02.design/tc/uat-checklist.md` 기준으로 직접 수행합니다.

UAT 완료 기준:
- 체크리스트 전체 P/F 기입 완료
- FAIL 항목 없음
- 결과를 `docs/06.uat/uat-result.md` 에 기록

**→ UAT PASS 확인 후 Phase 9로 진행합니다.**

---

### Phase 9 — 운영 배포

Read `.claude/skills/ship.md` and follow all instructions.
산출물: `docs/06.ship/checklist.md`

배포 체크리스트 완료 후 커밋 및 main 머지:
```bash
git add docs/06.ship/
git commit -m "change-phase9: ship 완료"
git push
# GitHub에서 PR → main 머지
```

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

[설계 리뷰]
  review-design FAIL → 설계 문제                  /design-{api|screen|db}           review-design 재실행
  review-design FAIL → 분석 보완 필요              /refine-analyze-requirements      영향 설계 재실행, review-design

[설계 중]
  기존 API 충돌        → AS-IS 분석 부족          /refine-analyze-asis              analyze-gap, 해당 설계 재실행
  범위 과다/과소       → 요구사항 불명확           /refine-analyze-requirements      analyze-gap, 설계 재실행
```

### 원칙
- GAP에 없는 코드를 건드렸다가 문제가 생기면 즉시 되돌립니다.
- 회귀 실패는 기존 코드 보호가 우선 — 신규 기능보다 기존 기능 복구를 먼저 합니다.
- 롤백 범위가 2단계 이상이면 사용자에게 범위를 먼저 확인하세요.

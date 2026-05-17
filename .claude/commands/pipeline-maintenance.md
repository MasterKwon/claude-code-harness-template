# 유지보수 파이프라인

운영 중인 시스템에 고객 변경 요청을 처리하는 반복 파이프라인입니다.
신규 개발(`/pipeline-full`)과 달리 **설계 문서가 이미 존재함**을 전제로 합니다.

## 파이프라인 구조 (변경 요청 1건 기준)

```
[요청 수집/분류]         [설계 변경]            [영향도 검증]
고객 요청 접수       →  해당 레이어 설계 수정 →  impact-check
유형 분류(REQ/SCR…)      (변경 범위만)             (연쇄 영향 파악)

      ↓
[구현]                   [리뷰]         [AI QA - Local]   [Dev 배포]   [UAT]           [운영 배포]
영향 범위만 수정      →  review-all  →  변경 기능 테스트 →  deploy-dev → uat-checklist →  ship (선택)
                                        + 회귀 테스트
```

반복: 다음 변경 요청이 오면 처음부터 다시 실행합니다.

---

## 사전 조건 확인

아래 문서가 존재해야 합니다:
- `docs/02.design/reviewed/db.md`
- `docs/02.design/reviewed/api.md`
- `docs/02.design/reviewed/screen.md`

**없을 경우**: `/maintenance-init` 을 먼저 실행하도록 안내하고 중단합니다.

---

## Phase 1 — 변경 요청 수집 및 분류

고객 변경 요청을 접수하고 유형을 분류합니다.

Read `.claude/skills/customer-request.md` — **Step 1 ~ Step 3만** 실행합니다.
(분류 결과를 받은 후 아래 Phase 2부터 이 파일의 지시를 따릅니다)

분류 결과를 사용자에게 보고하고, 진행 승인을 받습니다:
```
[변경 요청 분류 결과]
유형: (REQ / SCR / API / DB / INT / OPS)
영향 단계: (시작 단계) → (끝 단계)
예상 영향 범위: (영향받는 문서/파일 목록)
변경 비용: 낮음 / 중간 / 높음

→ 진행하시겠습니까? (Y/N)
```

---

## Phase 2 — 설계 변경 (변경 범위만)

분류 유형에 따라 해당 설계 문서를 수정합니다.

```
REQ → /refine-analyze-requirements + /refine-design-{api|screen|db} (영향 레이어)
SCR → /refine-design-screen
API → /refine-design-api
DB  → /refine-design-db
INT → /design-integration
OPS → 설계 변경 없음, Phase 4로 건너뜀
```

> 기존 설계 문서를 전체 삭제하지 않습니다. 변경/추가 부분만 업데이트합니다.

설계 변경 완료 후 커밋:
```bash
git add docs/
git commit -m "maint: 설계 변경 — (변경 요청 내용 요약)"
```

---

## Phase 3 — 영향도 검증

Read `.claude/skills/impact-check.md` and follow all instructions.
산출물: `docs/03.build/impact-check.md`

> 변경된 설계가 기존 구현의 어떤 파일에 영향을 주는지 파악합니다.
> 연쇄 변경 대상(DB 변경 → API 변경 → 화면 변경)을 미리 확정합니다.

**High 항목 발견 시**: 사용자에게 보고 후 진행 여부 확인.
**확정된 구현 대상 목록**을 다음 Phase에 전달합니다.

---

## Phase 4 — 구현 (영향 범위만)

impact-check 결과를 기준으로 영향받는 레이어만 구현합니다.

```
DB 변경 대상 있음    → Read `.claude/skills/build-db.md` — Patch 모드
API 변경 대상 있음   → Read `.claude/skills/build-api.md` — Patch 모드
Screen 변경 대상 있음 → Read `.claude/skills/build-screen.md` — Patch 모드
```

> **Patch 모드**: 기존 구현을 전체 재작성하지 않습니다.
> impact-check에서 확정된 파일만 수정합니다.
> GAP에 없는 코드는 건드리지 않습니다.

구현 완료 후 커밋:
```bash
git add .
git commit -m "maint: 구현 완료 — (변경 요청 내용 요약)"
```

---

## Phase 5 — 코드 리뷰

Read `.claude/skills/review-all.md` and follow all instructions.
산출물: `docs/04.review/report.md`

> `docs/03.build/impact-check.md`의 High/Medium 항목 중점 검토.
> 기존 코드에 의도치 않은 영향이 없는지 확인합니다.

**High 심각도 발견 시**: Phase 4 롤백 후 재구현.
**통과 시**: 다음 Phase로 진행.

---

## Phase 6 — AI 자동화 테스트 (Local)

> 로컬 환경에서 AI가 자동 실행하는 테스트입니다.

#### 변경 기능 테스트
분류 유형에 따라 해당 테스트 실행:
```
DB 변경  → Read `.claude/skills/test-db.md` and follow all instructions.
API 변경 → Read `.claude/skills/test-api.md` and follow all instructions.
SCR 변경 → Read `.claude/skills/test-screen.md` and follow all instructions.
```

#### 회귀 테스트
`docs/03.build/impact-check.md`의 회귀 대상 목록을 참조합니다:
- **High 항목**: 반드시 테스트. 실패 시 릴리즈 차단.
- **Medium 항목**: 테스트 후 결과 보고.

#### E2E (필요 시)
변경 범위가 핵심 사용자 흐름에 영향을 주는 경우:
Read `.claude/skills/test-e2e.md` and follow all instructions.

QA 통과 후 커밋:
```bash
git add docs/05.test/
git commit -m "maint: AI QA 통과 — (변경 요청 내용 요약)"
```

---

## Phase 7 — Dev 서버 배포 (선택)

변경 규모에 따라 즉시 배포 또는 다음 배포 묶음으로 처리합니다.

```
즉시 배포 필요 (긴급 수정, 고객 요청 SLA 등)
  → Read `.claude/skills/deploy-dev.md` and follow all instructions.
  → 배포 완료 후 docs/02.design/tc/uat-checklist.md 를 QA 담당자에게 전달합니다.

다음 배포로 묶음 (우선순위 낮음, 배치 배포)
  → 변경 이력만 기록하고 보류
```

---

## Phase 8 — UAT (선택, Dev 환경)

> Phase 7에서 Dev 배포를 진행한 경우에만 실행합니다.

QA 담당자가 Dev 서버에서 `docs/02.design/tc/uat-checklist.md` 기준으로 직접 수행합니다.

UAT 결과를 `docs/06.uat/uat-result.md` 에 기록합니다.

**→ UAT PASS 시에만 Phase 9 운영 배포로 진행합니다.**

---

## Phase 9 — 운영 배포 (선택)

UAT PASS 확인 후 운영 배포를 진행합니다.

```
UAT PASS → Read `.claude/skills/ship.md` and follow all instructions.
UAT FAIL → Phase 5(코드 리뷰) 또는 Phase 4(구현)로 롤백 후 재실행
```

---

## Phase 10 — 변경 이력 기록

`docs/change-requests.md` 에 이력을 추가합니다 (파일 없으면 신규 생성):

```markdown
## [날짜] 변경 요청 #N
**요청자**: (고객명 또는 역할)
**내용**: (요청 내용 요약)
**유형**: (REQ / SCR / API / DB / INT / OPS)
**영향 범위**: (impact-check 결과 요약)
**처리 결과**: 완료 / 보류
**배포 여부**: 즉시 배포 / 다음 배포 묶음 / 미배포
```

**→ 다음 변경 요청이 오면 Phase 1부터 다시 시작합니다.**

---

## 롤백 맵

```
문제 발견 위치           원인                      조치
──────────────────────────────────────────────────────────
[QA — 회귀 실패]
  기존 기능 깨짐        → 구현 부작용             /refine-build-{api|screen|db} → Phase 5 재실행
  기존 API 계약 깨짐    → 연쇄 영향 미반영        /refine-build-api → Phase 5 재실행

[QA — 변경 기능 실패]
  신규 기능 미동작      → 구현 오류               /refine-build-{api|screen|db} → Phase 5 재실행

[구현 중]
  의도치 않은 코드 충돌 → impact-check 범위 부족  /refine-impact-check → Phase 4 재실행

[설계 변경 중]
  기존 문서와 충돌      → 설계 검토 필요          사용자 확인 후 결정
```

---

## pipeline-change와의 차이점

| 항목 | pipeline-change | pipeline-maintenance |
|------|----------------|---------------------|
| 시작점 | AS-IS 분석부터 | 설계 문서 이미 존재 |
| 범위 | 내부 주도 기능 추가/수정 | 외부(고객) 변경 요청 처리 |
| 반복성 | 기능 단위 (비정기) | 변경 요청 단위 (반복) |
| 문서화 | GAP 분석 중심 | 변경 이력(change-requests.md) 중심 |

# 분석 단계 전체 실행

분석 3단계를 순서대로 실행하고, 마지막에 `review-analyze` 로 종합 리뷰하여 PASS 시 `reviewed/` 로 승격합니다.

> **`reviewed/` 의 의미**: `review-analyze` 가 PASS 판정을 내린 시점의 사본만 들어갑니다. 자동 품질 게이트만 통과한 상태로는 들어가지 않습니다 (다음 단계 진입 안전망).

> **Agent 위임 규칙**: `[fast]`, `[balanced]`, `[best]` 태그는 CLAUDE.md 모델 티어 기준으로 Agent를 생성하여 위임합니다. 태그 없는 단계는 현재 모델로 직접 실행합니다.

---

## Step 1 — 요구사항 분석

Read `.claude/skills/analyze-requirements.md` and follow all instructions.
산출물: `docs/01.analyze/requirements.md` (원본 위치)

> 스킬 본문의 "사전 동작" 에 따라 실행 시작 시 `docs/01.analyze/reviewed/requirements.md` 와 `reviewed/gap.md` 가 있으면 자동 삭제됩니다 (이전 리뷰 통과 무효화).

### 자동 품질 게이트
- [ ] 이해관계자 정의 존재
- [ ] 기능 요구사항에 Must/Should/Could 우선순위 부여
- [ ] 비기능 요구사항 섹션 존재
- [ ] [질문 필요] 항목 없거나 명시적 보류 처리

**미흡 항목 있으면**: 해당 항목만 `docs/01.analyze/requirements.md`에 보완 후 재검증.
**모두 통과하면**: Step 2로 진행 (`reviewed/` 복사는 아직 안 함 — review-analyze PASS 시점에 일괄 복사).

---

## Step 2 — AS-IS 분석

`docs/01.analyze/requirements.md` 존재 확인 후 진행.
[fast] Read `.claude/skills/analyze-asis.md` and follow all instructions.
산출물: `docs/01.analyze/asis.md` (원본 위치)

> 스킬 본문 "사전 동작" 에 따라 실행 시 `reviewed/asis.md` 와 `reviewed/gap.md` 자동 삭제.

### 자동 품질 게이트
- [ ] 화면 구성 섹션 존재
- [ ] 소스코드 구조 섹션 존재
- [ ] 아키텍처 섹션 존재
- [ ] 데이터 구조 섹션 존재
- [ ] 관찰된 이슈 섹션 존재

**미흡 항목 있으면**: 해당 항목만 `docs/01.analyze/asis.md`에 보완 후 재검증.
**모두 통과하면**: Step 3로 진행.

---

## Step 3 — GAP 분석

`docs/01.analyze/requirements.md`, `docs/01.analyze/asis.md` 존재 확인 후 진행.
[best] Read `.claude/skills/analyze-gap.md` and follow all instructions.
산출물: `docs/01.analyze/gap.md` (원본 위치)

> 스킬 본문 "사전 동작" 에 따라 실행 시 `reviewed/gap.md` 자동 삭제.

### 자동 품질 게이트
- [ ] 화면 / DB / API 3개 영역 모두 분석
- [ ] 모든 항목에 분류(신규/변경/유지/제거) 부여
- [ ] 모든 항목에 영향도(High/Medium/Low) 부여
- [ ] 권장 개발 순서 존재

**미흡 항목 있으면**: 해당 항목만 `docs/01.analyze/gap.md`에 보완 후 재검증.
**모두 통과하면**: Step 4로 진행.

---

## Step 4 — 분석 종합 리뷰 (필수)

세 산출물을 종합 검토하여 다음 단계 진입 여부를 확정합니다. **이 Step 을 건너뛰면 `reviewed/` 가 비어 있어 design 단계가 진입을 거부합니다.**

[best] Read `.claude/skills/review-analyze.md` and follow all instructions.
산출물: `docs/01.analyze/analyze-review-report.md`

- **PASS 시 자동 동작**: 세 파일을 `docs/01.analyze/reviewed/` 로 일괄 복사 (review-analyze.md 안에 명시)
- **FAIL 시**: 문제 문서별 라우팅 (`/refine-analyze-requirements` / `/refine-analyze-asis` / `/refine-analyze-gap`) 후 Step 4 재실행

---

분석 단계 완료. `reviewed/` 에 세 파일이 모두 들어간 것을 확인한 후 `/design-all` 로 진행합니다.

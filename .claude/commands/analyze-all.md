# 분석 단계 전체 실행

분석 3단계를 순서대로 실행합니다. 각 단계 완료 후 자동으로 품질을 검증하고, 통과하면 `reviewed/`로 승격합니다.

---

## Step 1 — 요구사항 분석

Read `.claude/skills/analyze-requirements.md` and follow all instructions. (standalone 모드 — 다음 스킬 자동 연계 없이 이 단계만 실행)
산출물: `docs/01.analyze/requirements.md`

### 자동 품질 게이트
- [ ] 이해관계자 정의 존재
- [ ] 기능 요구사항에 Must/Should/Could 우선순위 부여
- [ ] 비기능 요구사항 섹션 존재
- [ ] [질문 필요] 항목 없거나 명시적 보류 처리

**미흡 항목 있으면**: 해당 항목만 `docs/01.analyze/requirements.md`에 보완 후 재검증.
**모두 통과하면**: `docs/01.analyze/requirements.md`를 `docs/01.analyze/reviewed/requirements.md`로 복사 후 Step 2로 진행.

---

## Step 2 — AS-IS 분석

`docs/01.analyze/reviewed/requirements.md` 존재 확인 후 진행.
Read `.claude/skills/analyze-asis.md` and follow all instructions. (standalone 모드 — 다음 스킬 자동 연계 없이 이 단계만 실행)
산출물: `docs/01.analyze/asis.md`

### 자동 품질 게이트
- [ ] 화면 구성 섹션 존재
- [ ] 소스코드 구조 섹션 존재
- [ ] 아키텍처 섹션 존재
- [ ] 데이터 구조 섹션 존재
- [ ] 관찰된 이슈 섹션 존재

**미흡 항목 있으면**: 해당 항목만 `docs/01.analyze/asis.md`에 보완 후 재검증.
**모두 통과하면**: `docs/01.analyze/asis.md`를 `docs/01.analyze/reviewed/asis.md`로 복사 후 Step 3으로 진행.

---

## Step 3 — GAP 분석

`docs/01.analyze/reviewed/requirements.md`, `docs/01.analyze/reviewed/asis.md` 존재 확인 후 진행.
Read `.claude/skills/analyze-gap.md` and follow all instructions. (standalone 모드)
산출물: `docs/01.analyze/gap.md`

### 자동 품질 게이트
- [ ] 화면 / DB / API 3개 영역 모두 분석
- [ ] 모든 항목에 분류(신규/변경/유지/제거) 부여
- [ ] 모든 항목에 영향도(High/Medium/Low) 부여
- [ ] 권장 개발 순서 존재

**미흡 항목 있으면**: 해당 항목만 `docs/01.analyze/gap.md`에 보완 후 재검증.
**모두 통과하면**: `docs/01.analyze/gap.md`를 `docs/01.analyze/reviewed/gap.md`로 복사.

분석 단계 완료. 사용자에게 결과를 보고하고 다음 단계(`/design-all`) 진행 여부를 확인합니다.

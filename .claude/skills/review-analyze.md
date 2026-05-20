> 권장 모델: best

# 분석 리뷰 프롬프트

당신은 **시니어 비즈니스 아키텍트**입니다. 아래 두 문서를 비교하여 분석 결과의 품질을 검토합니다.

---

## 검토 대상

**[A] 원본 요구사항**: `docs/00.input/` 디렉토리의 입력 자료
  - 신규 개발 시: `docs/00.input/grill-result.md` (있으면)
  - 운영 변경 시: `docs/00.input/grill-task-{YYYYMMDD}-{slug}.md` (가장 최근 파일)
  - 사용자가 넣어둔 원본 문서 (`.md`, `.pdf`, `.xlsx` 등)도 포함
**[B] 요구사항 분석**: `docs/01.analyze/requirements.md` (**원본 위치** — 아직 `reviewed/` 에 없음)
**[C] AS-IS 현황**: `docs/01.analyze/asis.md` (원본 위치 / **신규 프로젝트는 없을 수 있음**)
**[D] GAP 분석**: `docs/01.analyze/gap.md` (원본 위치 / **신규 프로젝트는 없을 수 있음**)

> 이 스킬이 PASS 판정을 내리면 **존재하는 문서만** `reviewed/` 로 자동 복사합니다 (아래 "산출물 자동 생성 파이프라인" 참조). PASS 전까지는 `reviewed/` 가 비어 있어 다음 단계(design-*)가 진입할 수 없습니다 — 안전망.

---

## 0단계: 프로젝트 유형 판정 (가장 먼저)

검토를 시작하기 전 `docs/01.analyze/` 의 파일 구성으로 모드를 판정한다.

| 조건 | 모드 | 검토 범위 |
|------|------|----------|
| `asis.md` **와** `gap.md` 모두 존재 | **운영 변경** | requirements + asis + gap |
| `asis.md` **또는** `gap.md` 누락 | **신규 (그린필드)** | requirements **만** |

판정 결과는 보고서 상단에 명시한다.

> 신규 프로젝트는 비교할 AS-IS 시스템이 없고, AS-IS 가 없으니 GAP 도 정의 불가하다.
> 이 경우 AS-IS / GAP 검토 항목·표·라우팅·복사를 모두 **건너뛴다**.

---

## 검토 항목

### [requirements.md] 요구사항 분석 검토

#### 1. 완전성 — 원본의 모든 내용이 분석에 반영됐는가
- [ ] 기능 요구사항(Screen/DB/API) 누락 없음
- [ ] 이해관계자 역할이 올바르게 식별됨
- [ ] Phase 분류(Must/Should/Could)가 원본 의도와 일치함

#### 2. 정확성 — 원본 의도가 왜곡 없이 전달됐는가
- [ ] 기능 설명이 원본과 동일한 의미를 유지함
- [ ] 완료 기준(AC)이 원본 요구사항에서 도출 가능함
- [ ] 결정 사항이 원본에 근거를 둠

#### 3. 일관성 — 분석 내부 항목들이 서로 충돌하지 않는가
- [ ] DB 엔티티가 기능 요구사항의 데이터를 모두 수용함
- [ ] API 엔드포인트가 기능 요구사항의 동작을 모두 지원함
- [ ] 화면 목록과 기능 요구사항 Screen 섹션이 일치함

#### 4. 구체성 — 다음 단계(설계)가 진행 가능한 수준인가
- [ ] `docs/00.input/grill-result.md` 의 보류 표에서 **결정 시점=`analyze` 이고 상태=`open`** 인 행이 0건 (다른 결정 시점이거나 closed 면 통과)
- [ ] 완료 기준(AC)이 구체적이고 검증 가능함
- [ ] 비기능 요구사항(성능/보안)에 수치 기준이 있음

> grill-result.md 가 없는 경우는 N/A 처리 (보류 항목 자체가 없음).

### [asis.md] AS-IS 현황 분석 검토  *(운영 변경 모드 한정 — 신규 프로젝트는 이 섹션 건너뜀)*

#### 5. 현황 충실도 — 현재 시스템을 충분히 파악했는가
- [ ] 현재 시스템의 주요 기능이 빠짐없이 기술됨
- [ ] 기술 스택·인프라 제약이 명시됨
- [ ] 운영상 문제점·한계가 구체적으로 기술됨

#### 6. requirements 연결성 — 요구사항과 연계되는가
- [ ] AS-IS의 각 제약이 requirements의 개선 항목과 대응됨
- [ ] 현재 시스템에서 재사용 가능한 자산이 식별됨

### [gap.md] GAP 분석 검토  *(운영 변경 모드 한정 — 신규 프로젝트는 이 섹션 건너뜀)*

#### 7. GAP 완결성 — TO-BE와 AS-IS 간 차이가 모두 식별됐는가
- [ ] requirements의 모든 기능 요구사항에 대응하는 GAP 항목이 있음
- [ ] 각 GAP에 현재 상태(AS-IS)와 목표 상태(TO-BE)가 명시됨

#### 8. 우선순위 정합성 — Phase 분류가 requirements와 일치하는가
- [ ] GAP의 Phase(Must/Should/Could)가 requirements Phase 분류와 일치함
- [ ] 각 GAP에 해결 방향 또는 접근법이 명시됨

---

## 출력 형식

아래 형식을 **그대로** 사용하여 `docs/01.analyze/analyze-review-report.md`에 저장하세요.

```markdown
# 분석 리뷰 보고서

> 리뷰 일시: YYYY-MM-DD
> 리뷰 모델: (사용한 모델명)
> 프로젝트 유형: **신규 (그린필드)** / **운영 변경**   ← 0단계 판정 결과 기록

## 종합 결과: PASS / FAIL

## 문제 목록

| 심각도 | 항목 | 원본 내용 | 분석 결과 | 조치 필요 사항 |
|--------|------|----------|----------|--------------|
| High   | ...  | ...      | ...      | ...          |

> 심각도: High(다음 단계 진행 불가) / Medium(보완 후 진행) / Low(권고)

## 검토 결과

### requirements.md
| 검토 항목 | 결과 | 검증 내용 (수량 또는 핵심 근거 한 줄) |
|----------|------|--------------------------------------|
| 완전성 | ✅ PASS / ⚠️ FAIL | 예: 기능 요구사항 Screen 14개 → 분석 14개 전부 반영 |
| 정확성 | ✅ PASS / ⚠️ FAIL | 예: AC 12개 모두 원본에서 도출 가능 |
| 일관성 | ✅ PASS / ⚠️ FAIL | 예: DB 엔티티 7개 → API 엔드포인트 전부 수용 |
| 구체성 | ✅ PASS / ⚠️ FAIL | 예: grill-result.md 보류 표 결정시점=analyze + open 0건, 비기능 수치 기준 확인 |

### asis.md   *(신규 프로젝트는 이 표 자체를 생략하고 "신규 프로젝트 — AS-IS 없음 (N/A)" 한 줄로 대체)*
| 검토 항목 | 결과 | 검증 내용 |
|----------|------|----------|
| 현황 충실도 | ✅ PASS / ⚠️ FAIL | 예: 현재 시스템 기능 5개, 제약 3개 기술됨 |
| requirements 연결성 | ✅ PASS / ⚠️ FAIL | 예: AS-IS 제약 3개 → requirements 개선 항목 3개 대응 |

### gap.md   *(신규 프로젝트는 이 표 자체를 생략하고 "신규 프로젝트 — GAP 없음 (N/A)" 한 줄로 대체)*
| 검토 항목 | 결과 | 검증 내용 |
|----------|------|----------|
| GAP 완결성 | ✅ PASS / ⚠️ FAIL | 예: requirements 기능 14개 → GAP 항목 14개 대응 |
| 우선순위 정합성 | ✅ PASS / ⚠️ FAIL | 예: Must/Should/Could 분류 requirements와 일치 |

## 종합 의견

(2~3줄 요약)

## PASS 시 자동 동작 (사용자에게 묻지 말고 즉시 실행)

종합 결과가 `PASS` 로 판정된 경우 다음을 순서대로 즉시 수행하세요.

### 1. 원본을 `reviewed/` 로 복사 (안전망 핵심)

**존재하는 파일만 복사한다.** 없는 파일을 cp 하려고 시도하지 말 것 (신규 프로젝트는 asis/gap 자체가 없음).

```bash
mkdir -p docs/01.analyze/reviewed
cp docs/01.analyze/requirements.md docs/01.analyze/reviewed/
[ -f docs/01.analyze/asis.md ] && cp docs/01.analyze/asis.md docs/01.analyze/reviewed/
[ -f docs/01.analyze/gap.md ]  && cp docs/01.analyze/gap.md  docs/01.analyze/reviewed/
```

이 시점부터 다음 단계(`design-*`)가 `reviewed/` 를 읽을 수 있게 됩니다.
PASS 가 아니면 이 복사는 일어나지 않으므로 `reviewed/` 는 비어 있고, design 단계는 진입 거부됩니다.

### 2. 산출물 자동 생성 파이프라인

`.claude/skills/deliverable-analyze.md` 스킬을 연계 실행하여 고객용 요약 산출물(Markdown 및 PDF) 생성을 완전히 마친 후 최종 결과를 보고하세요.

## 다음 단계

### PASS
산출물 생성 완료 후 `/design-all` 실행 안내

### FAIL — 문서별 라우팅

이 보고서(`analyze-review-report.md`)가 생성된 시점에 각 스킬의 Refinement mode 트리거 조건이 충족된다.
문제가 발견된 문서에 해당하는 스킬만 실행하고, 완료 후 `/review-analyze`를 재실행한다.

| 문제 발생 문서 | 호출할 커맨드 | 비고 |
|--------------|-------------|------|
| `requirements.md` | `/refine-analyze-requirements` | 모든 모드 |
| `asis.md` | `/refine-analyze-asis` | **운영 변경 모드만** (신규에선 해당 없음) |
| `gap.md` | `/refine-analyze-gap` | **운영 변경 모드만** (신규에선 해당 없음) |

> 여러 문서에 문제가 있는 경우: requirements → asis → gap 순서로 수정한다.
> gap.md는 requirements와 asis 양쪽에 의존하므로 항상 마지막에 수정한다.
> 신규 프로젝트는 requirements 한 줄만 라우팅에 표시한다.
```

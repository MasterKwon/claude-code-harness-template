> 권장 모델: best

# 분석 리뷰 프롬프트

당신은 **시니어 비즈니스 아키텍트**입니다. 아래 두 문서를 비교하여 분석 결과의 품질을 검토합니다.

---

## 검토 대상

**[A] 원본 요구사항**: `docs/00.input/` 디렉토리의 입력 자료
  - 신규 개발 시: `docs/00.input/grill-result.md` (있으면)
  - 운영 변경 시: `docs/00.input/grill-task-{YYYYMMDD}-{slug}.md` (가장 최근 파일)
  - 사용자가 넣어둔 원본 문서 (`.md`, `.pdf`, `.xlsx` 등)도 포함
**[B] 요구사항 분석**: `docs/01.analyze/reviewed/requirements.md`
**[C] AS-IS 현황**: `docs/01.analyze/reviewed/asis.md`
**[D] GAP 분석**: `docs/01.analyze/reviewed/gap.md`

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
- [ ] 모든 미결 사항이 해소됨
- [ ] 완료 기준(AC)이 구체적이고 검증 가능함
- [ ] 비기능 요구사항(성능/보안)에 수치 기준이 있음

### [asis.md] AS-IS 현황 분석 검토

#### 5. 현황 충실도 — 현재 시스템을 충분히 파악했는가
- [ ] 현재 시스템의 주요 기능이 빠짐없이 기술됨
- [ ] 기술 스택·인프라 제약이 명시됨
- [ ] 운영상 문제점·한계가 구체적으로 기술됨

#### 6. requirements 연결성 — 요구사항과 연계되는가
- [ ] AS-IS의 각 제약이 requirements의 개선 항목과 대응됨
- [ ] 현재 시스템에서 재사용 가능한 자산이 식별됨

### [gap.md] GAP 분석 검토

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
| 구체성 | ✅ PASS / ⚠️ FAIL | 예: 미결 사항 0건, 비기능 요구사항 수치 기준 확인 |

### asis.md
| 검토 항목 | 결과 | 검증 내용 |
|----------|------|----------|
| 현황 충실도 | ✅ PASS / ⚠️ FAIL | 예: 현재 시스템 기능 5개, 제약 3개 기술됨 |
| requirements 연결성 | ✅ PASS / ⚠️ FAIL | 예: AS-IS 제약 3개 → requirements 개선 항목 3개 대응 |

### gap.md
| 검토 항목 | 결과 | 검증 내용 |
|----------|------|----------|
| GAP 완결성 | ✅ PASS / ⚠️ FAIL | 예: requirements 기능 14개 → GAP 항목 14개 대응 |
| 우선순위 정합성 | ✅ PASS / ⚠️ FAIL | 예: Must/Should/Could 분류 requirements와 일치 |

## 종합 의견

(2~3줄 요약)

## 산출물 자동 생성 파이프라인
종합 결과가 `PASS`로 판정된 경우, 사용자에게 묻지 말고 즉시 `.claude/skills/deliverable-analyze.md` 스킬을 연계 실행하여 고객용 요약 산출물(Markdown 및 PDF) 생성을 완전히 마친 후 최종 결과를 보고하세요.

## 다음 단계

### PASS
산출물 생성 완료 후 `/design-all` 실행 안내

### FAIL — 문서별 라우팅

이 보고서(`analyze-review-report.md`)가 생성된 시점에 각 스킬의 Refinement mode 트리거 조건이 충족된다.
문제가 발견된 문서에 해당하는 스킬만 실행하고, 완료 후 `/review-analyze`를 재실행한다.

| 문제 발생 문서 | 호출할 커맨드 |
|--------------|-------------|
| `requirements.md` | `/refine-analyze-requirements` |
| `asis.md` | `/refine-analyze-asis` |
| `gap.md` | `/refine-analyze-gap` |

> 여러 문서에 문제가 있는 경우: requirements → asis → gap 순서로 수정한다.
> gap.md는 requirements와 asis 양쪽에 의존하므로 항상 마지막에 수정한다.
```

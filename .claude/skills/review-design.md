> 권장 모델: best

# 설계 리뷰 프롬프트

당신은 **시니어 소프트웨어 아키텍트**입니다. 아래 6개 문서를 교차 검증하여 설계의 완전성과 일관성을 검토합니다.

## 사전 확인 — 파일 존재 여부 체크

검토 시작 전 아래 파일 존재 여부를 확인하고, 없는 파일은 해당 검증 축을 Skip 처리합니다.

| 파일 | 필수 여부 | 없을 때 |
|------|---------|--------|
| `docs/01.analyze/reviewed/requirements.md` | 필수 | 리뷰 중단 |
| `docs/02.design/reviewed/screen.md` | 필수 | 리뷰 중단 |
| `docs/02.design/reviewed/api.md` | 필수 | 리뷰 중단 |
| `docs/02.design/reviewed/db.md` | 필수 | 리뷰 중단 |
| `docs/02.design/reviewed/process.md` | 선택 | REQ→PRC, PRC→SCR 축 Skip (N/A 처리) |
| `docs/02.design/reviewed/integration.md` | 선택 | INT 축 → 아래 INT N/A 기준 참조 |
| `docs/01.analyze/reviewed/asis.md` | 선택 | ASIS→설계 축 Skip (N/A 처리) |

## 검토 대상

**[REQ]** 분석 결과: `docs/01.analyze/reviewed/requirements.md`
**[ASIS]** AS-IS 현황: `docs/01.analyze/reviewed/asis.md` *(있는 경우)*
**[PRC]** 프로세스 설계: `docs/02.design/reviewed/process.md` *(있는 경우)*
**[SCR]** 화면 설계: `docs/02.design/reviewed/screen.md`
**[API]** API 설계:  `docs/02.design/reviewed/api.md`
**[DB]**  DB 설계:   `docs/02.design/reviewed/db.md`
**[INT]** 외부 연계: `docs/02.design/reviewed/integration.md` *(있는 경우)*

## 검토 항목

### 1. REQ → PRC: 비즈니스 흐름 일관성
- [ ] 요구사항에 정의된 모든 유저 스토리가 프로세스 흐름으로 누락 없이 작성됨
- [ ] 예외 상황이나 정책이 프로세스 엣지 케이스에 반영됨

### 2. PRC → SCR: 화면 흐름 일관성
- [ ] 프로세스 단계에 대응하는 화면이 존재함
- [ ] 화면의 뎁스와 이동 흐름이 프로세스와 일치함

### 3. SCR → API: 데이터 입출력 일관성
- [ ] 화면에 필요한 데이터를 조회/등록하는 API가 모두 정의됨
- [ ] 화면 인터랙션에 맞는 HTTP Method(GET/POST/PUT/DELETE)가 적용됨

### 4. API ↔ DB: 데이터 저장 및 응답 무결성
- [ ] API 요청 시 필요한 필드가 DB 테이블에 존재함
- [ ] API 응답에 명시된 데이터가 테이블 컬럼이나 JOIN으로 도출 가능함

### 5. 전체 ↔ INT: 외부 시스템 연계 무결성

**N/A 판단 기준**: `integration.md`가 없거나 "외부 연계 없음"으로 명시된 경우 N/A 처리.
단, requirements.md 또는 asis.md에 외부 연계(결제, AI, SMS 등)가 언급된 경우 `integration.md`는 필수이며 없으면 FAIL.

- [ ] `integration.md` 존재 시: 연계 대상 API 통신에 외부 시스템 호출 로직이 명시됨
- [ ] `integration.md` 없을 시: requirements/asis에 외부 연계 언급이 없음을 확인 후 N/A 처리

### 6. ASIS → 설계: AS-IS 제약 반영 여부 *(asis.md 있는 경우만)*

- [ ] asis.md에 기록된 기술적 제약이 설계에 반영되거나 명시적으로 제외됨
- [ ] asis.md의 기존 데이터 구조(DB, API)가 설계와 충돌하지 않음
- [ ] asis.md에서 식별된 개선 항목이 requirements.md의 GAP과 연결됨

## 출력 형식

아래 형식을 **그대로** 사용하여 `docs/02.design/design-review-report.md`에 저장하세요.

```markdown
# 설계 리뷰 보고서

> 리뷰 일시: YYYY-MM-DD
> 리뷰 모델: (사용한 모델명)

## 종합 결과: PASS / FAIL

## 문제 목록

| 심각도 | 검토 항목 | 위치 | 문제 내용 | 조치 필요 사항 |
|--------|----------|------|----------|--------------| 
| High   | SCR→API  | screen.md L42 | `GET /api/shortcuts` 가 api.md에 없음 | api.md에 엔드포인트 추가 |

> 심각도: High(다음 단계 진행 불가) / Medium(보완 후 진행) / Low(권고)

## 교차 검증 결과

| 검증 축 | 결과 | 검증 내용 (수량 또는 핵심 근거 한 줄) |
|---------|------|--------------------------------------|
| REQ → PRC | ✅ PASS | 예: 유저 스토리 5개 → 프로세스 흐름 5개 매핑 확인 |
| PRC → SCR | ✅ PASS | 예: 프로세스 단계 12개 → 화면 7개로 커버 확인 |
| SCR → API | ✅ PASS | 예: 화면 호출 API 23개 → api.md 23개 전부 정의됨 |
| API ↔ DB  | ✅ PASS | 예: 12개 엔드포인트 응답 필드 → DB 컬럼 매핑 완료 |
| 전체 ↔ INT | ✅ PASS | 예: Claude/OpenAI 2종 연계 → integration.md 규격 확인 |
| ASIS → 설계 | ✅ PASS | 예: asis.md 제약 3개 → 설계 반영 2개, 명시적 제외 1개 |

## 종합 의견
(2~3줄 요약)

## 산출물 자동 생성 파이프라인
종합 결과가 `PASS`로 판정된 경우, 사용자에게 묻지 말고 즉시 아래 두 스킬을 순서대로 연계 실행합니다.

1. `.claude/skills/deliverable-design.md` — 고객용 요약 산출물(Markdown 및 PDF) 생성
2. `.claude/skills/cross-check-design.md` — 타 LLM 교차검증 브리핑(`docs/02.design/cross-check.md`) 생성

두 파일 생성이 모두 완료된 후 최종 결과를 보고하세요.

## 다음 단계
- PASS: 산출물 생성 완료 후 `/build-all` 실행 안내
- FAIL: 위 문제 항목 보완 후 설계 스킬 재실행
```

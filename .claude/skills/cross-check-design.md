> 권장 모델: balanced

# 설계 교차검증 브리핑 생성

설계 리뷰 PASS 직후 실행됩니다.
타 LLM이 이 파일 하나만 읽고 즉시 교차검증할 수 있는 브리핑을 생성합니다.

## 읽을 파일

아래 파일을 순서대로 읽습니다.

1. `CLAUDE.md` — 기술스택, 아키텍처
2. `docs/01.analyze/reviewed/requirements.md` — 요구사항
3. `docs/01.analyze/reviewed/gap.md` — 작업 범위 (있는 경우)
4. `docs/02.design/reviewed/db.md` — DB 설계
5. `docs/02.design/reviewed/api.md` — API 설계
6. `docs/02.design/reviewed/screen.md` — 화면 설계
7. `docs/02.design/design-review-report.md` — 리뷰 보고서 (Medium/Low 항목 파악용)

## 생성할 파일

`docs/02.design/cross-check.md`

아래 형식을 **그대로** 사용합니다.

---

```markdown
# 설계 교차검증 브리핑
> 생성 일시: YYYY-MM-DD  
> 용도: 타 LLM 교차검증 — 이 파일만 읽으면 됩니다  
> 다음 단계: 이 설계를 바탕으로 개발을 시작합니다

---

## 프로젝트 컨텍스트

- **아키텍처**: (MSA / 모노리스)
- **기술스택**: (DB, ORM, API Style, Framework, UI)
- **한 줄 요약**: (이 프로젝트가 무엇을 만드는가)

---

## 작업 범위

(requirements.md의 Must 항목 중심으로 3~5줄 요약)
(gap.md가 있으면 신규/변경 항목 수 명시)

---

## 핵심 설계 결정과 근거

| 레이어 | 결정 내용 | 선택 근거 |
|--------|----------|---------|
| DB     | (예: soft delete 정책 채택) | (예: 복구 요구사항 존재) |
| API    | (예: JWT 만료 1시간) | (예: 보안 요건 우선) |
| 화면   | (예: SSR 방식 선택) | (예: SEO 요구사항) |
| ...    | | |

---

## 의도적으로 제외한 것

| 항목 | 제외 이유 |
|------|---------|
| (예: 실시간 알림) | (예: 이번 스코프 외, 다음 버전 예정) |
| (예: 다국어 지원) | (예: 현재 한국어 단일 서비스) |

---

## 설계자가 불확실하다고 느낀 부분

> 교차검증 시 이 항목에 집중해 주세요

(design-review-report.md의 Medium/Low 항목 또는 설계 중 판단이 어려웠던 지점을 구체적으로 서술)

예:
- API 응답 페이지네이션 방식 (cursor vs offset) — 대용량 데이터 시 성능 차이 불확실
- DB 인덱스 전략 — 실제 쿼리 패턴 예측이 어려움

---

## 교차검증 요청

개발 시작 전에 아래 질문에 답해 주세요.

1. 이 설계에서 요구사항을 충족하지 못하는 부분이 있나요?
2. 레이어 간(DB↔API↔화면) 불일치나 누락된 연결이 보이나요?
3. 위 "불확실한 부분"에 대해 더 나은 접근 방식이 있다면 알려주세요.
4. 개발 시작 전에 반드시 결정해야 할 사항이 있나요?

---

## 원본 산출물 위치

- `docs/02.design/reviewed/db.md`
- `docs/02.design/reviewed/api.md`
- `docs/02.design/reviewed/screen.md`
- `docs/02.design/design-review-report.md`
```

---

## 생성 후 처리

파일 생성 완료 후 사용자에게 보고합니다:

```
[교차검증 브리핑 생성 완료]

docs/02.design/cross-check.md 가 생성되었습니다.
개발 시작 전 타 LLM(Gemini 등)에 이 파일을 붙여넣고
"이 설계에서 보완할 부분이 있나요?" 로 교차검증하세요.

확인 후 개발을 시작하려면 /build-all 을 실행하세요.
```

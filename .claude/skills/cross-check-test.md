> 권장 모델: fast

# 테스트 교차검증 브리핑 생성

테스트 전 단계(DB/API/화면/E2E) 완료 직후 실행됩니다.
타 LLM이 이 파일 하나만 읽고 즉시 추가 테스트 관점을 제안할 수 있는 브리핑을 생성합니다.

## 읽을 파일

아래 파일을 순서대로 읽습니다.

1. `CLAUDE.md` — 기술스택, 아키텍처
2. `docs/01.analyze/reviewed/requirements.md` — 원래 요구사항 (테스트 커버리지 판단 기준)
3. `docs/05.test/report-db.md` — DB 테스트 결과 (원본 위치)
4. `docs/05.test/report-api.md` — API 테스트 결과 (원본 위치)
5. `docs/05.test/report-screen.md` — 화면 테스트 결과 (원본 위치)
6. `docs/05.test/report-e2e.md` — E2E 테스트 결과 (원본 위치)

## 생성할 파일

`docs/05.test/cross-check.md`

아래 형식을 **그대로** 사용합니다.

---

```markdown
# 테스트 교차검증 브리핑
> 생성 일시: YYYY-MM-DD  
> 용도: 타 LLM 교차검증 — 이 파일만 읽으면 됩니다  
> 다음 단계: 교차검증 후 Dev 배포 → UAT 진행 예정

---

## 프로젝트 컨텍스트

- **아키텍처**: (MSA / 모노리스)
- **기술스택**: (DB, ORM, API Style, Framework)
- **한 줄 요약**: (이 프로젝트가 무엇을 만드는가)

---

## 테스트 전략

- **테스트 유형**: DB 단위 / API 통합 / 화면 / E2E 시나리오
- **테스트 환경**: (로컬 / Docker / 테스트 DB 등)
- **데이터 전략**: (고정 fixture / 랜덤 생성 / 실데이터 샘플 등)

---

## 커버된 주요 시나리오

### DB
(테이블/제약조건/마이그레이션 검증 항목 핵심만 3~5줄)

### API
(엔드포인트 수, 인증/인가, 경계값 테스트 핵심만 3~5줄)

### 화면
(페이지 수, 주요 인터랙션, 에러 상태 핵심만 3~5줄)

### E2E
(핵심 사용자 시나리오 목록)

---

## 테스트하지 않은 것과 이유

| 항목 | 제외 이유 |
|------|---------|
| (예: 동시 접속 부하 테스트) | (예: 로컬 환경 한계, 스테이징 환경 미구성) |
| (예: 결제 실패 복구 시나리오) | (예: 이번 스코프 외) |
| (예: 모바일 브라우저 호환성) | (예: 데스크탑 우선 요구사항) |

---

## 테스터가 불확실하다고 느낀 부분

> 교차검증 시 이 항목에 집중해 주세요

(각 테스트 보고서에서 "미흡" 또는 "추가 검토 필요"로 표시된 항목 서술)

예:
- 트랜잭션 롤백 시나리오 — 네트워크 단절 케이스 재현 어려움
- 화면 렌더링 — 대용량 목록(1만 건 이상) 성능 미검증

---

## 교차검증 요청

당신이 이 프로젝트를 테스트한다면 추가로 무엇을 확인하겠습니까?

1. 위 "테스트하지 않은 것" 중 실제로 위험하다고 판단되는 항목이 있나요?
2. 이 테스트 결과에서 놓쳤을 가능성이 있는 엣지 케이스가 보이나요?
3. 실제 사용자 행동 패턴과 다를 것 같은 테스트 시나리오가 있나요?
4. UAT 전에 반드시 추가해야 할 테스트가 있다면 알려주세요.

---

## 원본 산출물 위치

- `docs/05.test/reviewed/report-db.md`
- `docs/05.test/reviewed/report-api.md`
- `docs/05.test/reviewed/report-screen.md`
- `docs/05.test/reviewed/report-e2e.md`
```

---

## 생성 후 처리 — 사용자에게 묻지 말고 즉시 실행

### 1. 테스트 보고서를 `reviewed/` 로 일괄 복사 (안전망 핵심)

`cross-check.md` 생성에 성공하면 (입력 4개 보고서가 모두 존재한다는 것을 의미함), 다음을 즉시 수행:

- `mkdir -p docs/05.test/reviewed`
- `cp docs/05.test/report-db.md docs/05.test/reviewed/`
- `cp docs/05.test/report-api.md docs/05.test/reviewed/`
- `cp docs/05.test/report-screen.md docs/05.test/reviewed/`
- `cp docs/05.test/report-e2e.md docs/05.test/reviewed/`

이 시점부터 `deploy-dev` / `deploy-prd` 가 `reviewed/` 를 읽을 수 있습니다.
**`cross-check-test` 가 실행되지 않으면 `reviewed/` 가 비어 있어 배포 단계가 진입을 거부합니다 (안전망).**

### 2. 사용자에게 보고

```
[교차검증 브리핑 생성 완료]

docs/05.test/cross-check.md 가 생성되었습니다.
4개 테스트 보고서가 docs/05.test/reviewed/ 로 복사되었습니다 (배포 진입 가능).

Dev 배포 전 타 LLM(Gemini 등)에 cross-check.md 를 붙여넣고
"당신이 테스트한다면 무엇을 추가로 확인하겠습니까?" 로 교차검증하세요.

확인 후 /deploy-dev 를 실행하세요.
```

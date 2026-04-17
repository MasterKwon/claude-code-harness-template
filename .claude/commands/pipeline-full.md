# 전체 파이프라인 실행

분석 → 설계 → 구현 → 리뷰 → 테스트 → 배포의 전체 SDLC를 순서대로 실행합니다.

## 파이프라인 구조

```
[분석]                    [설계]                    [구현]
analyze-requirements  →  design-screen         →  build-db
analyze-asis          →  design-db             →  build-api
analyze-gap           →  design-api            →  build-screen

      ↓
[리뷰]                    [테스트]                  [배포]
review-all            →  test-db               →  ship
                      →  test-api
                      →  test-screen
                      →  test-e2e
```

## 실행 순서

### Phase 0 — 프로젝트 설정

> 기술 스택이 이미 결정되어 있다면 `CLAUDE.md`를 확인하고 Phase 1로 넘어가세요.
> 스택을 아직 결정하지 않았다면 아래를 실행합니다.

Read `.claude/skills/project-setup.md` and follow all instructions.

- 9가지 항목 선택 → 프로젝트 초기화 → 패키지 자동 설치
- 완료 후 `CLAUDE.md` Tech Stack 섹션 자동 업데이트

**→ 설치 완료 및 CLAUDE.md 확인 후 Phase 1로 진행하세요.**

---

### Phase 1 — 분석
Read `.claude/skills/analyze-requirements.md` and follow all instructions. (`docs/01.analyze/requirements.md` 생성)
Read `.claude/skills/analyze-asis.md` and follow all instructions. (`docs/01.analyze/asis.md` 생성)
Read `.claude/skills/analyze-gap.md` and follow all instructions. (`docs/01.analyze/gap.md` 생성)

**→ 분석 Phase 완료 후 반드시 사용자 확인을 받고 다음 Phase로 진행하세요.**

### Phase 2 — 설계
Read `.claude/skills/design-screen.md` and follow all instructions. (`docs/02.design/screen.md` 생성)
Read `.claude/skills/design-db.md` and follow all instructions. (`docs/02.design/db.md` 생성)
Read `.claude/skills/design-api.md` and follow all instructions. (`docs/02.design/api.md` 생성)

**→ 설계 Phase 완료 후 반드시 사용자 확인을 받고 다음 Phase로 진행하세요.**

### Phase 3 — 구현
Read `.claude/skills/build-db.md` and follow all instructions.
Read `.claude/skills/build-api.md` and follow all instructions.
Read `.claude/skills/build-screen.md` and follow all instructions.

**→ 구현 Phase 완료 후 반드시 사용자 확인을 받고 다음 Phase로 진행하세요.**

### Phase 4 — 리뷰
Read `.claude/skills/review-all.md` and follow all instructions. (`docs/04.review/report.md` 생성)

- High 심각도 문제 발견 시: 해당 구현 단계로 롤백 후 재실행
- 모두 통과 시: `docs/04.review/reviewed/report.md`로 복사 후 다음 Phase 진행

**→ 리뷰 통과 확인 후 다음 Phase로 진행하세요.**

### Phase 5 — 테스트
Read `.claude/skills/test-db.md` and follow all instructions. (`docs/05.test/report-db.md` 생성)
Read `.claude/skills/test-api.md` and follow all instructions. (`docs/05.test/report-api.md` 생성)
Read `.claude/skills/test-screen.md` and follow all instructions. (`docs/05.test/report-screen.md` 생성)
Read `.claude/skills/test-e2e.md` and follow all instructions. (`docs/05.test/report-e2e.md` 생성)

**→ 테스트 Phase 완료 후 반드시 사용자 확인을 받고 다음 Phase로 진행하세요.**

### Phase 6 — 배포
Read `.claude/skills/ship.md` and follow all instructions. (`docs/06.ship/checklist.md` 생성)

**→ 전체 파이프라인 완료.**

---
각 Phase 사이에 사용자 확인을 받는 것은 필수입니다.

## 롤백 맵 — 문제 발생 시 어디로 돌아갈지

문제를 발견한 위치에서 원인을 찾아 해당 단계로 되돌아갑니다.
보완 후에는 그 단계 이후의 모든 산출물을 재실행해야 합니다.

```
문제 발견 위치          원인                       조치 커맨드                       이후 재실행 범위
─────────────────────────────────────────────────────────────────────────────────────────────────
[배포]
  ship 실패           → 테스트 미완료              /test-all                         ship
  ship 실패           → 환경설정 오류              직접 수정                         ship

[테스트]
  test-e2e 실패      → 화면 구현 오류             /refine-build-screen              review-all, test-screen, test-e2e
  test-e2e 실패      → API 구현 오류              /refine-build-api                 review-all, test-api, test-e2e
  test-e2e 실패      → DB 구현 오류               /refine-build-db                  review-all, test-db, test-api, test-e2e
  test-e2e 실패      → API 설계 오류              /refine-design-api                build-api, build-screen, review-all, test-* 전체
  test-e2e 실패      → DB 설계 오류               /refine-design-db                 build-db 이후 전체
  test-e2e 실패      → 요구사항 오류              /refine-analyze-requirements      설계 이후 전체

[리뷰]
  review-all High    → 구현 코드 오류             /refine-build-{api|db|screen}     review-all 재실행
  review-all High    → 보안 취약점                /refine-build-{api|db|screen}     review-all 재실행

[구현]
  build-screen 중    → API 설계 누락              /refine-design-api                build-api, build-screen 재실행
  build-api 중       → DB 설계 누락               /refine-design-db                 build-db, build-api 재실행
  build-db 중        → DB 설계 오류               /refine-design-db                 build-db 재실행

[설계]
  design-api 중      → 화면 설계 누락             /refine-design-screen             design-api 재실행
  design-api 중      → DB 설계 누락               /refine-design-db                 design-api 재실행
  design-* 중        → 요구사항 불명확            /refine-analyze-requirements      design-* 재실행

[분석]
  analyze-gap 중     → AS-IS 누락                /refine-analyze-asis              analyze-gap 재실행
  analyze-gap 중     → 요구사항 불명확            /refine-analyze-requirements      analyze-gap 재실행
```

### 원칙
- 보완(`refine-*`)은 기존 문서를 유지하면서 미진한 부분만 채웁니다.
- 롤백 후 재실행 범위는 해당 산출물에 의존하는 모든 하위 단계입니다.
- 롤백 범위가 2단계 이상이면 사용자에게 범위를 먼저 확인하세요.

---

## 요구사항 변경 시나리오

진행 중 요구사항이 바뀌는 경우, 현재 위치에 따라 다르게 대응합니다.

```
변경 발생 시점              대응 방법
──────────────────────────────────────────────────────────────────────────
분석 단계 중               /refine-analyze-requirements 후 이후 단계 재실행
설계 단계 중               변경 범위 확인 후 영향받는 설계 문서만 /refine-design-*
구현 단계 중               /refine-analyze-requirements → 설계 → 구현 재실행
리뷰/테스트 단계 중         변경 범위가 크면 분석부터, 작으면 구현부터 롤백
```

### 변경 범위 판단 기준

| 변경 내용 | 범위 |
|-----------|------|
| 텍스트/레이블/문구 수정 | 화면 구현만 재실행 |
| 필드 추가/삭제 | DB → API → Screen 순 재실행 |
| 기능 추가 | 요구사항부터 전체 재실행 |
| 기능 제거 | 영향받는 설계/구현 문서 삭제 후 재검증 |

### 변경 이력 관리
요구사항이 변경될 때마다 `docs/01.analyze/requirements.md` 하단에 변경 이력을 추가합니다:
```
## 변경 이력
| 날짜 | 변경 내용 | 영향 범위 |
|------|-----------|-----------|
| YYYY-MM-DD | ... | ... |
```

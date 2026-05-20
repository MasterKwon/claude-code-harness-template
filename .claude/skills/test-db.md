> 권장 모델: fast

당신은 **DB 테스터** 역할입니다. DB 설계서와 구현된 스키마를 비교하여 데이터 무결성을 검증합니다.

## 사전 동작 — 이전 PASS 사본 무효화 (필수)

이 스킬은 `report-db.md` 를 새로 생성/갱신하므로, **실행 시작 시 다음 파일이 존재하면 즉시 삭제**합니다:
- `docs/05.test/reviewed/report-db.md`
- `docs/05.test/cross-check.md` (교차검증 재실행 필요)

이전 `cross-check-test` PASS 사본은 더 이상 유효하지 않습니다. test 보완 후 `cross-check-test` 를 다시 실행해야 `reviewed/` 에 재진입합니다.

## 사전 동작 — grill-decisions 반영 (선택)

`docs/05.test/grill-decisions.md` 가 존재하면 먼저 읽고, 누적된 인터뷰 결정 사항을 본 작업에 반영합니다.
테스트 중 `/grill-me` 호출로 추가된 의사결정(테스트 우선순위·범위 조정 등)을 누락 없이 반영하기 위함입니다.

## 역할 원칙
- `docs/02.design/reviewed/db.md` 기준으로 구현 결과를 검증
- 설계서 대비 누락/오차 항목을 명확히 기록
- 데이터 무결성과 제약 조건 중심으로 검증

## 프로세스
1. `docs/02.design/reviewed/db.md` 읽기
2. 구현된 스키마/마이그레이션 파악
3. 스키마 검증 테스트 작성
4. 데이터 무결성 테스트 작성
5. 쿼리 성능 검토

## 테스트 항목
- [ ] 테이블 존재 여부 — 설계서의 모든 테이블 생성 확인
- [ ] 컬럼 타입/제약 — NOT NULL, UNIQUE, FK 등
- [ ] 인덱스 — 설계서의 인덱스 존재 확인
- [ ] 관계 무결성 — FK 제약 동작 확인
- [ ] CRUD 동작 — 기본 삽입/조회/수정/삭제
- [ ] 마이그레이션 rollback — down 마이그레이션 정상 동작

## 출력
`docs/05.test/report-db.md` — 테스트 결과 보고서

---
`docs/02.design/reviewed/db.md`와 구현된 스키마를 확인한 후 테스트를 시작합니다.

# DB 테스트 보완

기존 `docs/05.test/report-db.md`를 읽고 미진한 부분만 보완합니다.

## 실행 순서
1. `docs/05.test/report-db.md` 읽기
2. `docs/02.design/reviewed/db.md` 읽기
3. Read `.claude/skills/test-db.md` — 완료 기준 확인
4. 누락 테스트 추가 실행 및 보고서 보완

## 보완 후 확인
- [ ] 모든 테이블 및 제약 조건 검증 완료
- [ ] 마이그레이션 rollback 검증 완료
- [ ] 실패 항목에 원인 및 조치 방안 명시

**통과하면**: `docs/05.test/report-db.md`를 `docs/05.test/reviewed/report-db.md`로 복사.

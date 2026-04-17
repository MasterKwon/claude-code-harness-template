# DB 구현 보완

구현된 스키마/마이그레이션을 읽고 미진한 부분만 보완합니다.

## 실행 순서
1. `docs/02.design/reviewed/db.md` 읽기
2. 구현된 스키마/마이그레이션 파일 파악
3. Read `.claude/skills/build-db.md` — 완료 기준 확인
4. 누락/불완전 항목 식별 후 해당 항목만 보완

## 보완 후 확인
- [ ] 설계서의 모든 테이블 구현
- [ ] FK 및 인덱스 적용
- [ ] up/down 마이그레이션 쌍 존재

**통과하면**: `docs/03.build/reviewed/checklist.md`에 DB 구현 완료 갱신.

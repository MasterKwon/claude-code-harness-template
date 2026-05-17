# 변경 영향도 검사 보완

기존 `docs/03.build/impact-check.md`를 읽고 누락된 영향 범위를 보완합니다.

## 실행 순서
1. `docs/03.build/impact-check.md` 읽기 — 현재 영향도 분석 결과 확인
2. Read `.claude/skills/impact-check.md` — 검사 항목 재확인
3. 추가로 발견된 영향 항목 또는 회귀 테스트 대상 보완

## 보완 후 확인
- [ ] 변경 파일 목록과 영향 받는 기능 목록이 일치함
- [ ] 각 항목에 영향도(High/Medium/Low) 부여됨
- [ ] 회귀 테스트 대상 목록 최신화됨

**완료 후**: `docs/03.build/impact-check.md` 갱신 후 `/review-all` 또는 `/test-all`로 복귀.

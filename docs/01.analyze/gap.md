# GAP 분석

> 이 파일은 `/analyze-gap` 실행 시 자동 생성됩니다.
> `reviewed/gap.md` 로 복사 후 검토·승인하세요.
> 신규 프로젝트의 경우 모든 항목이 "신규"로 분류됩니다.

---

## 화면 영역

| 항목 | AS-IS | TO-BE | 분류 | 영향도 |
|------|-------|-------|------|--------|
| 로그인 화면 | 있음 | 유지 + 소셜 로그인 추가 | 변경 | Medium |
| 회원가입 화면 | 없음 | 신규 생성 | 신규 | High |
| 비밀번호 찾기 | 없음 | 신규 생성 | 신규 | Medium |
| 대시보드 | 있음 | 유지 | 유지 | Low |

---

## DB 영역

| 항목 | AS-IS | TO-BE | 분류 | 영향도 |
|------|-------|-------|------|--------|
| users 테이블 | INT PK, hard delete | UUID PK, soft delete 추가 | 변경 | High |
| login_histories 테이블 | 없음 | 신규 생성 | 신규 | Medium |
| users.email 인덱스 | 없음 | 추가 | 변경 | Low |

---

## API 영역

| 항목 | AS-IS | TO-BE | 분류 | 영향도 |
|------|-------|-------|------|--------|
| POST /api/auth/login | 있음 | 응답 형식 통일 필요 | 변경 | Medium |
| POST /api/auth/register | 없음 | 신규 | 신규 | High |
| POST /api/auth/logout | 없음 | 신규 | 신규 | Medium |
| GET /api/users/me | 없음 | 신규 | 신규 | High |

---

## 권장 개발 순서

1. DB 마이그레이션 (users 테이블 변경, login_histories 신규)
2. 인증 API (register → login → logout → me)
3. 화면 (회원가입 → 로그인 → 대시보드)

# API 설계

> 이 파일은 `/design-api` 실행 시 자동 생성됩니다.
> `reviewed/api.md` 로 복사 후 검토·승인하세요.

---

## 서비스 구성 (MSA)

| 서비스 | 포트 | 담당 도메인 |
|--------|------|------------|
| gateway | 3000 | 라우팅, 인증 미들웨어 |
| user-service | 3001 | 사용자, 인증 |

---

## 공통 규칙

- **인증**: `Authorization: Bearer {JWT}` 헤더
- **에러 응답 형식**:
  ```json
  { "code": "UNAUTHORIZED", "message": "인증이 필요합니다" }
  ```
- **페이지네이션**: `?page=1&size=20` (offset 방식)
- **날짜 형식**: ISO 8601 (`2024-01-15T09:00:00Z`)
- **Soft Delete**: 삭제된 리소스 조회 시 404 반환

---

## [user-service] 인증 API

### POST /api/auth/register
- **설명**: 회원가입
- **인증**: 불필요
- **Request**:
  ```json
  {
    "email": "user@example.com",
    "password": "password123",
    "name": "홍길동"
  }
  ```
- **Response 201**:
  ```json
  {
    "id": "uuid",
    "email": "user@example.com",
    "name": "홍길동",
    "created_at": "2024-01-15T09:00:00Z"
  }
  ```
- **Response 409**: 이메일 중복 `{ "code": "EMAIL_DUPLICATE" }`
- **Response 400**: 입력값 오류 `{ "code": "VALIDATION_ERROR", "fields": [...] }`

---

### POST /api/auth/login
- **설명**: 로그인 — JWT 발급
- **인증**: 불필요
- **Request**:
  ```json
  { "email": "user@example.com", "password": "password123" }
  ```
- **Response 200**:
  ```json
  {
    "token": "eyJhbGci...",
    "expires_in": 604800,
    "user": { "id": "uuid", "email": "user@example.com", "name": "홍길동" }
  }
  ```
- **Response 401**: 인증 실패 `{ "code": "INVALID_CREDENTIALS" }`

---

### POST /api/auth/logout
- **설명**: 로그아웃 (클라이언트 토큰 폐기 안내)
- **인증**: 필요
- **Response 204**: No Content

---

## [user-service] 사용자 API

### GET /api/users/me
- **설명**: 내 정보 조회
- **인증**: 필요
- **Response 200**:
  ```json
  {
    "id": "uuid",
    "email": "user@example.com",
    "name": "홍길동",
    "created_at": "2024-01-15T09:00:00Z"
  }
  ```

---

### PATCH /api/users/me
- **설명**: 내 정보 수정 (이름, 비밀번호)
- **인증**: 필요
- **Request** (변경할 필드만):
  ```json
  { "name": "김철수" }
  ```
  ```json
  { "current_password": "old123", "new_password": "new456" }
  ```
- **Response 200**: 수정된 사용자 정보
- **Response 400**: 현재 비밀번호 불일치 `{ "code": "WRONG_PASSWORD" }`

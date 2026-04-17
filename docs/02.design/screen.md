# 화면 설계

> 이 파일은 `/design-screen` 실행 시 자동 생성됩니다.
> `reviewed/screen.md` 로 복사 후 검토·승인하세요.

---

## 페이지 목록

| 경로 | 페이지명 | 설명 | 인증 필요 |
|------|----------|------|----------|
| `/login` | 로그인 | 이메일/비밀번호 로그인 | X |
| `/register` | 회원가입 | 신규 계정 생성 | X |
| `/` | 대시보드 | 메인 화면, 요약 정보 | O |
| `/profile` | 내 정보 | 계정 정보 조회·수정 | O |

---

## 페이지 흐름

```
[로그인] ──── 성공 ────▶ [대시보드]
    │                        │
    │                    [내 정보]
    ▼
[회원가입] ── 완료 ────▶ [로그인]

비인증 접근 시 → /login 리다이렉트 (미들웨어 처리)
```

---

## 페이지별 설계

### /login (로그인)
- **목적**: 기존 사용자 로그인
- **레이아웃**: 중앙 정렬 카드
- **주요 컴포넌트**:
  - 이메일 입력 (type=email, required)
  - 비밀번호 입력 (type=password, required)
  - [로그인] 버튼: `POST /api/auth/login` 호출 → 성공 시 `/` 이동
  - [회원가입] 링크: `/register` 이동
- **에러 처리**: 인증 실패 시 "이메일 또는 비밀번호가 올바르지 않습니다" 인라인 표시

### /register (회원가입)
- **목적**: 신규 계정 생성
- **레이아웃**: 중앙 정렬 카드
- **주요 컴포넌트**:
  - 이름 입력 (required)
  - 이메일 입력 (required, 중복 체크)
  - 비밀번호 입력 (required, 8자 이상)
  - 비밀번호 확인 입력 (required)
  - [가입하기] 버튼: `POST /api/auth/register` 호출 → 성공 시 `/login` 이동
- **에러 처리**: 이메일 중복 시 "이미 사용 중인 이메일입니다" 표시

### / (대시보드)
- **목적**: 로그인 후 메인 화면
- **레이아웃**: 사이드바 + 메인 콘텐츠
- **주요 컴포넌트**:
  - Header: 사용자 이름, [로그아웃] 버튼
  - Sidebar: 메뉴 네비게이션
  - Body: 요약 카드 (통계, 최근 항목)
- **호출 API**: `GET /api/users/me`

### /profile (내 정보)
- **목적**: 계정 정보 조회 및 수정
- **레이아웃**: 단일 컬럼 폼
- **주요 컴포넌트**:
  - 이름 수정 필드
  - 비밀번호 변경 섹션 (현재/신규/확인)
  - [저장] 버튼: `PATCH /api/users/me` 호출
- **호출 API**: `GET /api/users/me`, `PATCH /api/users/me`

---

## 공통 컴포넌트

| 컴포넌트 | 위치 | 사용 페이지 |
|----------|------|------------|
| Header | `components/layout/Header` | 인증 필요 페이지 전체 |
| Sidebar | `components/layout/Sidebar` | 인증 필요 페이지 전체 |
| InputField | `components/ui/InputField` | 로그인, 회원가입, 내 정보 |
| Button | `components/ui/Button` | 전체 |
| ErrorMessage | `components/ui/ErrorMessage` | 폼이 있는 페이지 전체 |

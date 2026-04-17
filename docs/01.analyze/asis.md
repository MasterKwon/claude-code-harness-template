# AS-IS 현황 분석

> 이 파일은 `/analyze-asis` 실행 시 자동 생성됩니다.
> `reviewed/asis.md` 로 복사 후 검토·승인하세요.
> 신규 프로젝트의 경우 이 파일은 생략할 수 있습니다.

---

## 화면 구성

### 페이지 목록
| 경로 | 페이지명 | 설명 |
|------|----------|------|
| `/login` | 로그인 | 이메일/비밀번호 입력 |
| `/dashboard` | 대시보드 | 메인 화면 |

### 페이지 흐름
```
[로그인] → 성공 → [대시보드]
         → 실패 → 오류 메시지 표시
```

---

## 소스코드 구조

### 기술 스택
- Framework: Next.js 14 (App Router)
- Language: TypeScript
- DB: PostgreSQL + Prisma

### 디렉터리 구조
```
src/
├── app/
│   ├── (auth)/login/page.tsx
│   └── dashboard/page.tsx
├── components/
└── lib/
    └── db.ts
```

### 주요 모듈
- 인증: JWT (jsonwebtoken)
- DB 접근: Prisma ORM

---

## 아키텍처

- 단일 Next.js 앱 (모노리스)
- Vercel 배포

---

## 데이터 구조

### users 테이블
| 컬럼 | 타입 | 설명 |
|------|------|------|
| id | INT | PK, auto increment |
| email | VARCHAR | 이메일 |
| password | VARCHAR | 비밀번호 해시 |
| created_at | TIMESTAMP | 생성일 |

---

## 관찰된 이슈

- `deleted_at` 컬럼 없음 (hard delete만 존재)
- 페이지네이션 미구현
- 인덱스 미설정 (users.email 조회 빈번하나 인덱스 없음)

# Architecture Skill — 모노리스 (Single Next.js App)

## 폴더 구조

```
프로젝트 루트/
├── app/                      # Next.js App Router (화면 + API)
│   ├── (auth)/               # 인증 관련 페이지 그룹
│   ├── (dashboard)/          # 주요 기능 페이지 그룹
│   ├── api/                  # API Routes
│   │   └── {domain}/
│   │       └── route.ts
│   └── components/           # 페이지 전용 컴포넌트
├── components/               # 전역 공통 컴포넌트
│   ├── ui/                   # 순수 UI (Button, Input, Modal 등)
│   └── layout/               # 레이아웃 (Header, Sidebar 등)
├── services/                 # 비즈니스 로직 레이어
│   └── {domain}.service.ts
├── repositories/             # DB 접근 레이어
│   └── {domain}.repository.ts
├── lib/                      # 유틸리티, 헬퍼
│   ├── auth.ts
│   └── db.ts                 # DB 클라이언트 싱글톤
└── types/                    # 전역 타입 정의
    └── index.ts
```

## 레이어 분리 원칙

### app/api/ (Controller 역할)
- 요청 파싱, 응답 반환만
- Service를 호출하는 진입점

### services/ (비즈니스 로직)
- 모든 비즈니스 규칙 위치
- Repository를 통해서만 DB 접근

### repositories/ (데이터 접근)
- DB 쿼리만 담당
- ORM/Raw SQL 코드가 여기에만 존재

### components/ (UI)
- 비즈니스 로직 포함 금지
- 데이터는 props 또는 TanStack Query로만 수신

## 공통 영역 기준

| 코드 종류 | 위치 |
|-----------|------|
| 재사용 가능한 UI | `components/ui/` |
| 레이아웃 구성요소 | `components/layout/` |
| 비즈니스 로직 | `services/` |
| DB 쿼리 | `repositories/` |
| 여러 서비스에서 쓰는 순수 함수 | `lib/` |
| 타입 / 인터페이스 | `types/` |

## 페이지별 컴포넌트 vs 전역 컴포넌트 기준

```
3개 이상의 페이지에서 사용 → components/ (전역)
1~2개 페이지에서만 사용   → app/{페이지}/components/ (로컬)
```

# Framework Skill — Next.js (App Router)

## 폴더 구조

```
gateway/
├── app/
│   ├── layout.tsx              # 루트 레이아웃 (전역 Provider, 폰트)
│   ├── page.tsx                # 홈 페이지
│   ├── (auth)/                 # 인증 필요 없는 페이지 그룹
│   │   ├── login/page.tsx
│   │   └── register/page.tsx
│   ├── (dashboard)/            # 인증 필요한 페이지 그룹
│   │   ├── layout.tsx          # 대시보드 레이아웃 (사이드바 등)
│   │   └── {기능}/
│   │       ├── page.tsx        # 목록 페이지
│   │       ├── [id]/page.tsx   # 상세 페이지
│   │       └── components/     # 이 페이지에서만 쓰는 컴포넌트
│   └── api/
│       ├── docs/route.ts       # Swagger UI 서빙
│       └── {도메인}/
│           ├── route.ts        # GET(목록), POST(생성)
│           └── [id]/route.ts   # GET(단건), PUT(수정), DELETE(삭제)
├── components/
│   ├── ui/                     # 순수 UI 컴포넌트 (Button, Input, Modal 등)
│   └── layout/                 # 레이아웃 구성요소 (Header, Sidebar, Footer)
├── lib/
│   ├── swagger.ts              # Swagger 스펙 생성
│   └── auth.ts                 # 인증 헬퍼
├── middleware.ts                # 인증/권한 체크, 리디렉션
├── providers.tsx               # 전역 Provider (QueryClient, Redux 등)
└── types/
    └── index.ts                # 전역 타입 정의
```

## 서버 컴포넌트 vs 클라이언트 컴포넌트

### 판단 기준

```
서버 컴포넌트 (기본값 — 'use client' 없음):
  - DB/API 직접 호출이 있는 경우
  - 민감한 환경변수 사용
  - 큰 라이브러리 import (번들 크기 절감)
  - SEO가 중요한 콘텐츠

클라이언트 컴포넌트 ('use client' 필요):
  - useState, useEffect 사용
  - onClick, onChange 등 이벤트 핸들러
  - 브라우저 API 사용 (localStorage, window 등)
  - TanStack Query / Zustand / Redux 훅 사용
```

### 패턴

```typescript
// 서버 컴포넌트 — 데이터 직접 fetch
async function UserList() {
  const users = await fetch(`${process.env.USER_SERVICE_URL}/api/users`).then(r => r.json())
  return <ul>{users.map(u => <li key={u.id}>{u.name}</li>)}</ul>
}

// 클라이언트 컴포넌트 — TanStack Query 사용
'use client'
function UserListClient() {
  const { data: users } = useQuery({ queryKey: ['users'], queryFn: () => fetch('/api/users').then(r => r.json()) })
  return <ul>{users?.map(u => <li key={u.id}>{u.name}</li>)}</ul>
}
```

## 레이아웃과 페이지 구조

```typescript
// app/layout.tsx — 루트 레이아웃
export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="ko">
      <body>
        <Providers>{children}</Providers>
      </body>
    </html>
  )
}

// app/(dashboard)/layout.tsx — 중첩 레이아웃
export default function DashboardLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="flex">
      <Sidebar />
      <main className="flex-1">{children}</main>
    </div>
  )
}
```

## Middleware (인증/권한)

```typescript
// middleware.ts
import { NextRequest, NextResponse } from 'next/server'

export function middleware(req: NextRequest) {
  const token = req.cookies.get('token')?.value
  const isAuthPage = req.nextUrl.pathname.startsWith('/login')

  if (!token && !isAuthPage) {
    return NextResponse.redirect(new URL('/login', req.url))
  }
  return NextResponse.next()
}

export const config = {
  matcher: ['/(dashboard)/:path*'],
}
```

## 컴포넌트 위치 기준

```
3개 이상 페이지에서 사용  →  components/ (전역)
1~2개 페이지에서만 사용   →  app/{페이지}/components/ (로컬)
비즈니스 로직 포함 금지   →  컴포넌트는 UI만, 로직은 서비스 레이어로
```

---

## Swagger 설정

### 패키지 설치
```bash
npm install next-swagger-doc swagger-ui-react
npm install -D @types/swagger-ui-react
```

### Swagger 스펙 생성 (lib/swagger.ts)
```typescript
import { createSwaggerSpec } from 'next-swagger-doc'

export const getApiDocs = () =>
  createSwaggerSpec({
    apiFolder: 'app/api',
    definition: {
      openapi: '3.0.0',
      info: {
        title: '프로젝트 API 문서',
        version: '1.0.0',
        description: 'Next.js App Router API',
      },
      components: {
        securitySchemes: {
          BearerAuth: {
            type: 'http',
            scheme: 'bearer',
            bearerFormat: 'JWT',
          },
        },
      },
      security: [{ BearerAuth: [] }],
    },
  })
```

### Swagger UI 라우트 (app/api/docs/route.ts)
```typescript
import { getApiDocs } from '@/lib/swagger'

export async function GET() {
  return Response.json(getApiDocs())
}
```

### Swagger UI 페이지 (app/api-docs/page.tsx)
```typescript
'use client'
import SwaggerUI from 'swagger-ui-react'
import 'swagger-ui-react/swagger-ui.css'
import { useEffect, useState } from 'react'

export default function ApiDocsPage() {
  const [spec, setSpec] = useState(null)

  useEffect(() => {
    fetch('/api/docs').then(r => r.json()).then(setSpec)
  }, [])

  return spec ? <SwaggerUI spec={spec} /> : <div>로딩 중...</div>
}
```

### API Route에 JSDoc 추가 (예시)
```typescript
// app/api/users/route.ts

/**
 * @swagger
 * /api/users:
 *   get:
 *     summary: 사용자 목록 조회
 *     tags: [Users]
 *     responses:
 *       200:
 *         description: 성공
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/User'
 *   post:
 *     summary: 사용자 생성
 *     tags: [Users]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/CreateUserDto'
 *     responses:
 *       201:
 *         description: 생성 성공
 */
export async function GET() { ... }
export async function POST() { ... }
```

### Swagger 접근 경로
```
http://localhost:3000/api-docs   ← Swagger UI
http://localhost:3000/api/docs   ← OpenAPI JSON
```

> API Route 구현 시 반드시 JSDoc 주석을 함께 작성합니다.
> Swagger 문서는 코드와 동기화된 상태를 유지해야 합니다.

# API Style Skill — REST API

## API Route 구조 (Next.js App Router)
```
app/api/
└── {domain}/
    ├── route.ts          # GET(목록), POST(생성)
    └── [id]/
        └── route.ts      # GET(단건), PATCH(수정), DELETE(삭제)
```

## 입력값 검증 — Zod (모든 POST/PATCH에 필수)
```typescript
import { z } from 'zod'

// schemas/user.schema.ts — 스키마는 별도 파일로 분리
export const createUserSchema = z.object({
  email: z.string().email('유효한 이메일을 입력하세요'),
  password: z.string().min(8, '비밀번호는 8자 이상이어야 합니다'),
  name: z.string().min(1, '이름을 입력하세요').max(100),
})

export const updateUserSchema = createUserSchema.partial()  // 모든 필드 optional

export type CreateUserInput = z.infer<typeof createUserSchema>
```

## Route Handler 패턴
```typescript
// app/api/users/route.ts
import { z } from 'zod'
import { createUserSchema } from '@/schemas/user.schema'
import { userService } from '@/services/user.service'
import { NextRequest } from 'next/server'

export async function GET(req: NextRequest) {
  const { searchParams } = req.nextUrl
  const page = Number(searchParams.get('page') ?? 1)
  const size = Number(searchParams.get('size') ?? 20)

  const { data, total } = await userService.findPage(page, size)
  return Response.json({ data, total, page, size })
}

export async function POST(req: NextRequest) {
  const body = await req.json()

  // Zod 검증
  const result = createUserSchema.safeParse(body)
  if (!result.success) {
    return Response.json(
      { code: 'VALIDATION_ERROR', errors: result.error.flatten().fieldErrors },
      { status: 400 }
    )
  }

  const user = await userService.create(result.data)
  return Response.json({ data: user }, { status: 201 })
}
```

```typescript
// app/api/users/[id]/route.ts
import { updateUserSchema } from '@/schemas/user.schema'
import { userService } from '@/services/user.service'
import { NextRequest } from 'next/server'

export async function GET(_: NextRequest, { params }: { params: { id: string } }) {
  const user = await userService.findById(params.id)
  if (!user) return Response.json({ code: 'NOT_FOUND', message: '존재하지 않는 사용자입니다' }, { status: 404 })
  return Response.json({ data: user })
}

export async function PATCH(req: NextRequest, { params }: { params: { id: string } }) {
  const body = await req.json()

  const result = updateUserSchema.safeParse(body)
  if (!result.success) {
    return Response.json(
      { code: 'VALIDATION_ERROR', errors: result.error.flatten().fieldErrors },
      { status: 400 }
    )
  }

  const user = await userService.update(params.id, result.data)
  return Response.json({ data: user })
}

export async function DELETE(_: NextRequest, { params }: { params: { id: string } }) {
  await userService.delete(params.id)
  return new Response(null, { status: 204 })
}
```

## 에러 응답 형식 표준 (모든 API 통일)
```typescript
// 성공
{ data: result }                          // 단건
{ data: list, total, page, size }         // 목록
// status 201                             // 생성

// 에러 — code는 클라이언트가 분기 처리할 수 있도록 영문 상수
{ code: 'NOT_FOUND',         message: '...' }  // 404
{ code: 'UNAUTHORIZED',      message: '...' }  // 401
{ code: 'FORBIDDEN',         message: '...' }  // 403
{ code: 'VALIDATION_ERROR',  errors: {...} }   // 400 (Zod 에러)
{ code: 'CONFLICT',          message: '...' }  // 409 (중복 등)
{ code: 'INTERNAL_ERROR',    message: '...' }  // 500
```

## URL 규칙
```
GET    /api/users           목록 조회 (?page=1&size=20)
POST   /api/users           생성
GET    /api/users/:id       단건 조회
PATCH  /api/users/:id       부분 수정 (PUT 대신 PATCH 사용)
DELETE /api/users/:id       삭제 (soft delete)
```

## 인증 미들웨어 연결
```typescript
// middleware.ts — 인증이 필요한 경로 보호
import { NextRequest, NextResponse } from 'next/server'
import { verifyToken } from '@/lib/auth'

export function middleware(req: NextRequest) {
  const token = req.headers.get('authorization')?.replace('Bearer ', '')
  if (!token || !verifyToken(token)) {
    return Response.json({ code: 'UNAUTHORIZED', message: '인증이 필요합니다' }, { status: 401 })
  }
  return NextResponse.next()
}

export const config = {
  matcher: ['/api/users/:path*', '/api/orders/:path*'],  // 보호할 경로
}
```

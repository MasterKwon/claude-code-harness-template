# API Style Skill — REST API

## API Route 구조 (Next.js App Router)
```
app/api/
└── {domain}/
    ├── route.ts          # GET(목록), POST(생성)
    └── [id]/
        └── route.ts      # GET(단건), PUT(수정), DELETE(삭제)
```

## Route Handler 패턴
```typescript
// app/api/users/route.ts
import { userService } from '@/services/user.service'
import { NextRequest } from 'next/server'

export async function GET(req: NextRequest) {
  const users = await userService.findAll()
  return Response.json(users)
}

export async function POST(req: NextRequest) {
  const body = await req.json()
  const user = await userService.create(body)
  return Response.json(user, { status: 201 })
}

// app/api/users/[id]/route.ts
export async function GET(_: NextRequest, { params }: { params: { id: string } }) {
  const user = await userService.findById(Number(params.id))
  if (!user) return Response.json({ error: 'Not found' }, { status: 404 })
  return Response.json(user)
}

export async function PUT(req: NextRequest, { params }: { params: { id: string } }) {
  const body = await req.json()
  const user = await userService.update(Number(params.id), body)
  return Response.json(user)
}

export async function DELETE(_: NextRequest, { params }: { params: { id: string } }) {
  await userService.delete(Number(params.id))
  return new Response(null, { status: 204 })
}
```

## 응답 형식 표준
```typescript
// 성공
Response.json({ data: result })                        // 단건
Response.json({ data: list, total: count })            // 목록
Response.json({ message: '생성되었습니다.' }, { status: 201 }) // 생성

// 에러
Response.json({ error: '메시지' }, { status: 400 })   // 클라이언트 오류
Response.json({ error: '메시지' }, { status: 404 })   // Not Found
Response.json({ error: '메시지' }, { status: 500 })   // 서버 오류
```

## URL 규칙
```
GET    /api/users          목록 조회
POST   /api/users          생성
GET    /api/users/:id      단건 조회
PUT    /api/users/:id      전체 수정
PATCH  /api/users/:id      부분 수정
DELETE /api/users/:id      삭제
```

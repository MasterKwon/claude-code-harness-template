# API Style Skill — tRPC

## 구조
```
server/
├── trpc.ts               # tRPC 초기화
├── router/
│   ├── index.ts          # 루트 라우터 (합성)
│   └── user.router.ts    # 도메인별 라우터
app/
└── api/trpc/[trpc]/
    └── route.ts          # Next.js 핸들러
```

## tRPC 초기화 (server/trpc.ts)
```typescript
import { initTRPC } from '@trpc/server'
import { z } from 'zod'

const t = initTRPC.create()

export const router = t.router
export const publicProcedure = t.procedure
export const protectedProcedure = t.procedure.use(({ ctx, next }) => {
  // 인증 미들웨어
  return next({ ctx })
})
```

## 라우터 패턴 (server/router/user.router.ts)
```typescript
import { router, publicProcedure } from '../trpc'
import { z } from 'zod'
import { userService } from '@/services/user.service'

export const userRouter = router({
  findAll: publicProcedure.query(() => userService.findAll()),

  findById: publicProcedure
    .input(z.object({ id: z.number() }))
    .query(({ input }) => userService.findById(input.id)),

  create: publicProcedure
    .input(z.object({ email: z.string().email(), name: z.string().optional() }))
    .mutation(({ input }) => userService.create(input)),

  update: publicProcedure
    .input(z.object({ id: z.number(), name: z.string() }))
    .mutation(({ input }) => userService.update(input.id, input)),

  delete: publicProcedure
    .input(z.object({ id: z.number() }))
    .mutation(({ input }) => userService.delete(input.id)),
})
```

## 클라이언트 사용 (TanStack Query 연동)
```typescript
'use client'
import { trpc } from '@/lib/trpc'

function UserList() {
  const { data: users } = trpc.user.findAll.useQuery()
  const createUser = trpc.user.create.useMutation()

  return (
    <button onClick={() => createUser.mutate({ email: 'test@test.com' })}>
      추가
    </button>
  )
}
```

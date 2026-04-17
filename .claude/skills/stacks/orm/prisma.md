# ORM Skill — Prisma

## 설치 확인
```bash
npx prisma --version
```

## Schema 패턴
```prisma
// prisma/schema.prisma
model User {
  id        Int      @id @default(autoincrement())
  email     String   @unique
  name      String?
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  posts     Post[]
}
```

## DB 클라이언트 싱글톤 (lib/db.ts)
```typescript
import { PrismaClient } from '@prisma/client'

const globalForPrisma = globalThis as unknown as { prisma: PrismaClient }

export const prisma =
  globalForPrisma.prisma ?? new PrismaClient({ log: ['error'] })

if (process.env.NODE_ENV !== 'production') globalForPrisma.prisma = prisma
```

## Repository 패턴
```typescript
// repositories/user.repository.ts
import { prisma } from '@/lib/db'

export const userRepository = {
  findById: (id: number) =>
    prisma.user.findUnique({ where: { id } }),

  findByEmail: (email: string) =>
    prisma.user.findUnique({ where: { email } }),

  findAll: () =>
    prisma.user.findMany({ orderBy: { createdAt: 'desc' } }),

  create: (data: { email: string; name?: string }) =>
    prisma.user.create({ data }),

  update: (id: number, data: Partial<{ name: string }>) =>
    prisma.user.update({ where: { id }, data }),

  delete: (id: number) =>
    prisma.user.delete({ where: { id } }),
}
```

## 주요 커맨드
```bash
npx prisma migrate dev --name 마이그레이션명   # 개발 마이그레이션
npx prisma migrate deploy                      # 프로덕션 마이그레이션
npx prisma generate                            # 클라이언트 재생성
npx prisma studio                              # DB GUI
npx prisma db seed                             # 시드 데이터
```

## 트랜잭션
```typescript
const result = await prisma.$transaction(async (tx) => {
  const user = await tx.user.create({ data: { email } })
  const profile = await tx.profile.create({ data: { userId: user.id } })
  return { user, profile }
})
```

# ORM Skill — Prisma

## 설치 확인
```bash
npx prisma --version
```

## Schema 패턴

### 네이밍: snake_case (@@map으로 DB 컬럼명 매핑)
```prisma
// prisma/schema.prisma
model User {
  id        String    @id @default(uuid())
  email     String    @unique
  firstName String?   @map("first_name")
  createdAt DateTime  @default(now()) @map("created_at")
  updatedAt DateTime  @updatedAt @map("updated_at")
  deletedAt DateTime? @map("deleted_at")   // soft delete
  posts     Post[]

  @@map("users")  // 테이블명 snake_case
}
```

> TypeScript 필드명은 camelCase, DB 컬럼명은 snake_case (`@map`)

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
  findById: (id: string) =>
    prisma.user.findUnique({ where: { id, deletedAt: null } }),

  findByEmail: (email: string) =>
    prisma.user.findUnique({ where: { email, deletedAt: null } }),

  findAll: () =>
    prisma.user.findMany({
      where: { deletedAt: null },
      orderBy: { createdAt: 'desc' },
    }),

  create: (data: { email: string; firstName?: string }) =>
    prisma.user.create({ data }),

  update: (id: string, data: Partial<{ firstName: string }>) =>
    prisma.user.update({ where: { id }, data }),

  // soft delete — 실제 삭제 금지
  delete: (id: string) =>
    prisma.user.update({ where: { id }, data: { deletedAt: new Date() } }),

  // 복원
  restore: (id: string) =>
    prisma.user.update({ where: { id }, data: { deletedAt: null } }),
}
```

## 페이지네이션

### Offset 방식 (일반 목록)
```typescript
findPage: (page: number, size: number) =>
  prisma.user.findMany({
    where: { deletedAt: null },
    skip: (page - 1) * size,
    take: size,
    orderBy: { createdAt: 'desc' },
  }),

countAll: () =>
  prisma.user.count({ where: { deletedAt: null } }),
```

### Cursor 방식 (무한스크롤 / 대용량)
```typescript
findAfter: (cursor: string | undefined, size: number) =>
  prisma.user.findMany({
    where: { deletedAt: null },
    take: size,
    skip: cursor ? 1 : 0,
    cursor: cursor ? { id: cursor } : undefined,
    orderBy: { createdAt: 'desc' },
  }),
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

# ORM Skill — TypeORM

## tsconfig.json 필수 설정
```json
{
  "compilerOptions": {
    "experimentalDecorators": true,
    "emitDecoratorMetadata": true
  }
}
```

## Entity 패턴

### 네이밍: snake_case (컬럼명 명시)
```typescript
// model/user.entity.ts
import {
  Entity, PrimaryGeneratedColumn, Column,
  CreateDateColumn, UpdateDateColumn, DeleteDateColumn
} from 'typeorm'

@Entity('users')  // 테이블명 snake_case
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string

  @Column({ unique: true })
  email: string

  @Column({ name: 'first_name', nullable: true })
  firstName: string

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date

  @DeleteDateColumn({ name: 'deleted_at' })
  deletedAt: Date | null   // soft delete — TypeORM이 자동 관리
}
```

> TypeScript 필드명은 camelCase, DB 컬럼명은 snake_case (`name` 옵션)

## DataSource 설정 (lib/db.ts)
```typescript
import { DataSource } from 'typeorm'
import { User } from '@/model/user.entity'

export const AppDataSource = new DataSource({
  type: 'postgres',
  url: process.env.DATABASE_URL,
  entities: [User],
  migrations: ['src/migrations/*.ts'],
  synchronize: false, // 프로덕션에서 반드시 false
})
```

## Repository 패턴
```typescript
// repositories/user.repository.ts
import { AppDataSource } from '@/lib/db'
import { User } from '@/model/user.entity'

const repo = AppDataSource.getRepository(User)

export const userRepository = {
  findById: (id: string) =>
    repo.findOneBy({ id }),  // @DeleteDateColumn 선언 시 deletedAt IS NULL 자동 적용

  findByEmail: (email: string) =>
    repo.findOneBy({ email }),

  findAll: () =>
    repo.find({ order: { createdAt: 'DESC' } }),

  create: (data: Partial<User>) =>
    repo.save(repo.create(data)),

  update: (id: string, data: Partial<User>) =>
    repo.update(id, data),

  // soft delete — @DeleteDateColumn 선언 시 deletedAt을 자동으로 설정
  delete: (id: string) =>
    repo.softDelete(id),

  // 복원
  restore: (id: string) =>
    repo.restore(id),
}
```

## 페이지네이션

### Offset 방식
```typescript
findPage: (page: number, size: number) =>
  repo.findAndCount({
    skip: (page - 1) * size,
    take: size,
    order: { createdAt: 'DESC' },
  }),
// 반환: [data[], total] 튜플
```

### Cursor 방식 (대용량)
```typescript
findAfter: (cursor: string | undefined, size: number) =>
  repo.createQueryBuilder('u')
    .where(cursor ? 'u.id < :cursor' : '1=1', { cursor })
    .andWhere('u.deleted_at IS NULL')
    .orderBy('u.created_at', 'DESC')
    .limit(size)
    .getMany(),
```

## 마이그레이션
```bash
npx typeorm migration:generate src/migrations/MigrationName -d src/lib/db.ts
npx typeorm migration:run -d src/lib/db.ts
npx typeorm migration:revert -d src/lib/db.ts
```

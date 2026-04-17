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
```typescript
// model/user.entity.ts
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn } from 'typeorm'

@Entity('users')
export class User {
  @PrimaryGeneratedColumn()
  id: number

  @Column({ unique: true })
  email: string

  @Column({ nullable: true })
  name: string

  @CreateDateColumn()
  createdAt: Date

  @UpdateDateColumn()
  updatedAt: Date
}
```

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
  findById: (id: number) => repo.findOneBy({ id }),
  findByEmail: (email: string) => repo.findOneBy({ email }),
  findAll: () => repo.find({ order: { createdAt: 'DESC' } }),
  create: (data: Partial<User>) => repo.save(repo.create(data)),
  update: (id: number, data: Partial<User>) => repo.update(id, data),
  delete: (id: number) => repo.delete(id),
}
```

## 마이그레이션
```bash
npx typeorm migration:generate src/migrations/MigrationName -d src/lib/db.ts
npx typeorm migration:run -d src/lib/db.ts
npx typeorm migration:revert -d src/lib/db.ts
```

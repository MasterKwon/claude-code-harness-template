# ORM Skill — Mongoose (MongoDB)

## DB 연결 (lib/db.ts)
```typescript
import mongoose from 'mongoose'

let isConnected = false

export async function connectDB() {
  if (isConnected) return
  await mongoose.connect(process.env.DATABASE_URL!)
  isConnected = true
}
```

## Schema + Model 패턴

### 네이밍: MongoDB는 camelCase 필드명이 관례 (다른 ORM과 달리 예외)
```typescript
// model/user.model.ts
import { Schema, model, models, Document } from 'mongoose'

export interface IUser extends Document {
  email: string
  firstName?: string
  createdAt: Date
  updatedAt: Date
  deletedAt: Date | null   // soft delete
}

const UserSchema = new Schema<IUser>(
  {
    email: { type: String, required: true, unique: true },
    firstName: { type: String },
    deletedAt: { type: Date, default: null },  // soft delete
  },
  { timestamps: true }  // createdAt, updatedAt 자동 관리
)

// soft delete 기본 필터: 모든 find에 deletedAt: null 자동 적용
UserSchema.pre(/^find/, function (this: any) {
  if (!this.getOptions().includeDeleted) {
    this.where({ deletedAt: null })
  }
})

export const User = models.User || model<IUser>('User', UserSchema)
```

## Repository 패턴
```typescript
// repositories/user.repository.ts
import { connectDB } from '@/lib/db'
import { User } from '@/model/user.model'

export const userRepository = {
  findById: async (id: string) => {
    await connectDB()
    return User.findById(id).lean()  // pre hook으로 deletedAt: null 자동 필터
  },

  findByEmail: async (email: string) => {
    await connectDB()
    return User.findOne({ email }).lean()
  },

  findAll: async () => {
    await connectDB()
    return User.find().sort({ createdAt: -1 }).lean()
  },

  create: async (data: { email: string; firstName?: string }) => {
    await connectDB()
    return User.create(data)
  },

  update: async (id: string, data: Partial<{ firstName: string }>) => {
    await connectDB()
    return User.findByIdAndUpdate(id, data, { new: true })
  },

  // soft delete
  delete: async (id: string) => {
    await connectDB()
    return User.findByIdAndUpdate(id, { deletedAt: new Date() }, { new: true })
  },

  // 복원
  restore: async (id: string) => {
    await connectDB()
    return User.findByIdAndUpdate(
      id,
      { deletedAt: null },
      { new: true, includeDeleted: true }
    )
  },
}
```

## 페이지네이션

### Offset 방식
```typescript
findPage: async (page: number, size: number) => {
  await connectDB()
  const [data, total] = await Promise.all([
    User.find().sort({ createdAt: -1 }).skip((page - 1) * size).limit(size).lean(),
    User.countDocuments(),
  ])
  return { data, total }
},
```

### Cursor 방식 (무한스크롤)
```typescript
findAfter: async (cursor: string | undefined, size: number) => {
  await connectDB()
  const filter = cursor ? { _id: { $lt: cursor } } : {}
  return User.find(filter).sort({ _id: -1 }).limit(size).lean()
},
```

## 주의사항
- `_id` 타입은 `ObjectId` — API 응답 시 `.toString()` 변환 필요
- `lean()` 사용 시 Mongoose Document가 아닌 순수 객체 반환 (성능 향상)
- `models.User || model(...)` 패턴은 Next.js HMR 시 중복 모델 등록 방지
- MongoDB 필드명은 camelCase가 관례 (RDBMS의 snake_case와 다름)

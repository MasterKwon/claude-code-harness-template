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
```typescript
// model/user.model.ts
import { Schema, model, models, Document } from 'mongoose'

export interface IUser extends Document {
  email: string
  name?: string
  createdAt: Date
}

const UserSchema = new Schema<IUser>(
  {
    email: { type: String, required: true, unique: true },
    name: { type: String },
  },
  { timestamps: true }
)

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
    return User.findById(id).lean()
  },
  findByEmail: async (email: string) => {
    await connectDB()
    return User.findOne({ email }).lean()
  },
  findAll: async () => {
    await connectDB()
    return User.find().sort({ createdAt: -1 }).lean()
  },
  create: async (data: { email: string; name?: string }) => {
    await connectDB()
    return User.create(data)
  },
  update: async (id: string, data: Partial<{ name: string }>) => {
    await connectDB()
    return User.findByIdAndUpdate(id, data, { new: true })
  },
  delete: async (id: string) => {
    await connectDB()
    return User.findByIdAndDelete(id)
  },
}
```

## 주의사항
- `_id` 타입은 `ObjectId` — API 응답 시 `.toString()` 변환 필요
- `lean()` 사용 시 Mongoose Document가 아닌 순수 객체 반환 (성능 향상)
- `models.User || model(...)` 패턴은 Next.js HMR 시 중복 모델 등록 방지

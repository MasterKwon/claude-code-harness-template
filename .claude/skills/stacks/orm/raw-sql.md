# ORM Skill — Raw SQL (pg / mysql2)

## DB 클라이언트 (lib/db.ts)

### PostgreSQL
```typescript
import { Pool } from 'pg'

export const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  max: 10,
})

export async function query<T = any>(sql: string, params?: any[]): Promise<T[]> {
  const { rows } = await pool.query(sql, params)
  return rows
}
```

### MySQL
```typescript
import mysql from 'mysql2/promise'

export const pool = mysql.createPool({
  uri: process.env.DATABASE_URL,
  waitForConnections: true,
  connectionLimit: 10,
})

export async function query<T = any>(sql: string, params?: any[]): Promise<T[]> {
  const [rows] = await pool.execute(sql, params)
  return rows as T[]
}
```

## 네이밍: 테이블명/컬럼명 모두 snake_case
```sql
-- ✅ snake_case
CREATE TABLE users (
  id         UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  email      VARCHAR(255) UNIQUE NOT NULL,
  first_name VARCHAR(100),
  created_at TIMESTAMP   NOT NULL DEFAULT now(),
  updated_at TIMESTAMP   NOT NULL DEFAULT now(),
  deleted_at TIMESTAMP   NULL    -- soft delete
);
```

## Repository 패턴 — 반드시 파라미터화된 쿼리 사용
```typescript
// repositories/user.repository.ts
import { query } from '@/lib/db'

export const userRepository = {
  // soft delete 필터(deleted_at IS NULL) 모든 조회에 적용
  findById: (id: string) =>
    query<User>(
      'SELECT * FROM users WHERE id = $1 AND deleted_at IS NULL',
      [id]
    ),

  findByEmail: (email: string) =>
    query<User>(
      'SELECT * FROM users WHERE email = $1 AND deleted_at IS NULL',
      [email]
    ),

  findAll: () =>
    query<User>(
      'SELECT * FROM users WHERE deleted_at IS NULL ORDER BY created_at DESC'
    ),

  create: (data: { email: string; first_name?: string }) =>
    query<User>(
      'INSERT INTO users (email, first_name) VALUES ($1, $2) RETURNING *',
      [data.email, data.first_name]
    ),

  update: (id: string, first_name: string) =>
    query<User>(
      'UPDATE users SET first_name = $1, updated_at = NOW() WHERE id = $2 AND deleted_at IS NULL RETURNING *',
      [first_name, id]
    ),

  // soft delete — 물리 삭제 금지
  delete: (id: string) =>
    query(
      'UPDATE users SET deleted_at = NOW() WHERE id = $1',
      [id]
    ),

  // 복원
  restore: (id: string) =>
    query(
      'UPDATE users SET deleted_at = NULL WHERE id = $1',
      [id]
    ),
}
```

## 페이지네이션

### Offset 방식
```typescript
findPage: async (page: number, size: number) => {
  const offset = (page - 1) * size
  const [data, countResult] = await Promise.all([
    query<User>(
      'SELECT * FROM users WHERE deleted_at IS NULL ORDER BY created_at DESC LIMIT $1 OFFSET $2',
      [size, offset]
    ),
    query<{ count: string }>(
      'SELECT COUNT(*) FROM users WHERE deleted_at IS NULL'
    ),
  ])
  return { data, total: Number(countResult[0].count) }
},
```

### Cursor 방식 (대용량)
```typescript
findAfter: (cursor: string | undefined, size: number) => {
  if (cursor) {
    return query<User>(
      'SELECT * FROM users WHERE id < $1 AND deleted_at IS NULL ORDER BY created_at DESC LIMIT $2',
      [cursor, size]
    )
  }
  return query<User>(
    'SELECT * FROM users WHERE deleted_at IS NULL ORDER BY created_at DESC LIMIT $1',
    [size]
  )
},
```

## 절대 금지
```typescript
// ❌ SQL 인젝션 취약점 — 문자열 직접 삽입 절대 금지
const result = await query(`SELECT * FROM users WHERE email = '${email}'`)

// ✅ 항상 파라미터 바인딩 사용
const result = await query('SELECT * FROM users WHERE email = $1', [email])
```

## 트랜잭션
```typescript
const client = await pool.connect()
try {
  await client.query('BEGIN')
  await client.query('INSERT INTO users ...', [...])
  await client.query('INSERT INTO profiles ...', [...])
  await client.query('COMMIT')
} catch (e) {
  await client.query('ROLLBACK')
  throw e
} finally {
  client.release()
}
```

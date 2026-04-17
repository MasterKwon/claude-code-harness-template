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

## Repository 패턴 — 반드시 파라미터화된 쿼리 사용
```typescript
// repositories/user.repository.ts
import { query } from '@/lib/db'

export const userRepository = {
  findById: (id: number) =>
    query<User>('SELECT * FROM users WHERE id = $1', [id]),  // pg: $1, mysql: ?

  findByEmail: (email: string) =>
    query<User>('SELECT * FROM users WHERE email = $1', [email]),

  findAll: () =>
    query<User>('SELECT * FROM users ORDER BY created_at DESC'),

  create: (data: { email: string; name?: string }) =>
    query<User>(
      'INSERT INTO users (email, name) VALUES ($1, $2) RETURNING *',
      [data.email, data.name]
    ),

  update: (id: number, name: string) =>
    query<User>(
      'UPDATE users SET name = $1, updated_at = NOW() WHERE id = $2 RETURNING *',
      [name, id]
    ),

  delete: (id: number) =>
    query('DELETE FROM users WHERE id = $1', [id]),
}
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

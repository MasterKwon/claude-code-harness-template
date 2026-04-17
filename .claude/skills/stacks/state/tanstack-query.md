# State Management Skill — TanStack Query

## 설치 확인
```bash
npm list @tanstack/react-query
```

## Provider 설정 (app/providers.tsx)
```typescript
'use client'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { useState } from 'react'

export function Providers({ children }: { children: React.ReactNode }) {
  const [queryClient] = useState(() => new QueryClient({
    defaultOptions: { queries: { staleTime: 60 * 1000 } },
  }))
  return <QueryClientProvider client={queryClient}>{children}</QueryClientProvider>
}
```

## 데이터 조회 패턴
```typescript
'use client'
import { useQuery } from '@tanstack/react-query'

function UserList() {
  const { data: users, isLoading, error } = useQuery({
    queryKey: ['users'],
    queryFn: () => fetch('/api/users').then(r => r.json()),
  })

  if (isLoading) return <div>로딩 중...</div>
  if (error) return <div>오류 발생</div>
  return <ul>{users?.map(u => <li key={u.id}>{u.name}</li>)}</ul>
}
```

## 데이터 변경 패턴
```typescript
import { useMutation, useQueryClient } from '@tanstack/react-query'

function CreateUser() {
  const queryClient = useQueryClient()

  const mutation = useMutation({
    mutationFn: (data: { email: string }) =>
      fetch('/api/users', { method: 'POST', body: JSON.stringify(data) }).then(r => r.json()),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['users'] }) // 목록 자동 갱신
    },
  })

  return <button onClick={() => mutation.mutate({ email: 'test@test.com' })}>추가</button>
}
```

## queryKey 규칙
```typescript
['users']              // 전체 목록
['users', id]          // 단건
['users', { filter }]  // 필터링된 목록
```

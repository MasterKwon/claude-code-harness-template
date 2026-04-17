# State Management Skill — Zustand + TanStack Query

## 역할 분리 원칙
- **TanStack Query**: 서버 상태 (API 데이터, 캐시, 동기화)
- **Zustand**: 클라이언트 상태 (UI 상태, 사용자 선택, 전역 설정)

## Zustand Store 패턴
```typescript
// store/ui.store.ts
import { create } from 'zustand'

interface UIState {
  sidebarOpen: boolean
  selectedId: number | null
  setSidebarOpen: (open: boolean) => void
  setSelectedId: (id: number | null) => void
}

export const useUIStore = create<UIState>((set) => ({
  sidebarOpen: true,
  selectedId: null,
  setSidebarOpen: (open) => set({ sidebarOpen: open }),
  setSelectedId: (id) => set({ selectedId: id }),
}))
```

## 함께 사용하는 패턴
```typescript
'use client'
import { useQuery } from '@tanstack/react-query'
import { useUIStore } from '@/store/ui.store'

function UserDetail() {
  const selectedId = useUIStore(state => state.selectedId)  // 클라이언트 상태

  const { data: user } = useQuery({                          // 서버 상태
    queryKey: ['users', selectedId],
    queryFn: () => fetch(`/api/users/${selectedId}`).then(r => r.json()),
    enabled: !!selectedId,
  })

  return <div>{user?.name}</div>
}
```

## 판단 기준
```
서버에서 가져오는 데이터        → TanStack Query
API 호출 결과 캐시              → TanStack Query
폼 데이터, 입력 상태            → useState (컴포넌트 로컬)
여러 컴포넌트가 공유하는 UI 상태 → Zustand
인증 사용자 정보                → Zustand (또는 Context)
```

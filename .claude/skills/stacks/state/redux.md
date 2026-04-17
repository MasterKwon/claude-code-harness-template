# State Management Skill — Redux Toolkit

## Store 설정 (store/index.ts)
```typescript
import { configureStore } from '@reduxjs/toolkit'
import { userReducer } from './user.slice'

export const store = configureStore({
  reducer: {
    user: userReducer,
  },
})

export type RootState = ReturnType<typeof store.getState>
export type AppDispatch = typeof store.dispatch
```

## Slice 패턴 (store/user.slice.ts)
```typescript
import { createSlice, createAsyncThunk, PayloadAction } from '@reduxjs/toolkit'

interface User { id: number; email: string; name?: string }
interface UserState { list: User[]; loading: boolean; error: string | null }

export const fetchUsers = createAsyncThunk('user/fetchAll', async () => {
  const res = await fetch('/api/users')
  return res.json() as Promise<User[]>
})

const userSlice = createSlice({
  name: 'user',
  initialState: { list: [], loading: false, error: null } as UserState,
  reducers: {
    clearError: (state) => { state.error = null },
  },
  extraReducers: (builder) => {
    builder
      .addCase(fetchUsers.pending, (state) => { state.loading = true })
      .addCase(fetchUsers.fulfilled, (state, action: PayloadAction<User[]>) => {
        state.loading = false
        state.list = action.payload
      })
      .addCase(fetchUsers.rejected, (state, action) => {
        state.loading = false
        state.error = action.error.message ?? '오류 발생'
      })
  },
})

export const { clearError } = userSlice.actions
export const userReducer = userSlice.reducer
```

## Provider 설정 (app/providers.tsx)
```typescript
'use client'
import { Provider } from 'react-redux'
import { store } from '@/store'

export function Providers({ children }: { children: React.ReactNode }) {
  return <Provider store={store}>{children}</Provider>
}
```

## 컴포넌트 사용
```typescript
'use client'
import { useDispatch, useSelector } from 'react-redux'
import { RootState, AppDispatch } from '@/store'
import { fetchUsers } from '@/store/user.slice'

function UserList() {
  const dispatch = useDispatch<AppDispatch>()
  const { list, loading } = useSelector((state: RootState) => state.user)

  useEffect(() => { dispatch(fetchUsers()) }, [])

  if (loading) return <div>로딩 중...</div>
  return <ul>{list.map(u => <li key={u.id}>{u.name}</li>)}</ul>
}
```

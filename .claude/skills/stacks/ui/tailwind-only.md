# UI Skill — Tailwind CSS Only

## 개념
별도의 컴포넌트 라이브러리 없이 Tailwind CSS 유틸리티 클래스만으로 UI를 구성합니다.
- Next.js 설치 시 기본 포함 — 추가 패키지 불필요
- 모든 스타일을 클래스로 직접 제어 (최대 자유도)
- shadcn처럼 미리 만들어진 컴포넌트 없음 — 직접 조합해서 만듦

## 설치 확인
```bash
cat tailwind.config.ts   # content 경로 확인
cat app/globals.css      # @tailwind 디렉티브 확인
```

## 폴더 구조
```
gateway/
├── app/
│   └── globals.css          # @tailwind base/components/utilities
├── components/
│   └── ui/                  # 직접 만든 공통 컴포넌트
│       ├── Button.tsx
│       ├── Input.tsx
│       ├── Card.tsx
│       └── Modal.tsx
└── tailwind.config.ts
```

## 공통 컴포넌트 직접 작성 패턴

### Button
```tsx
// components/ui/Button.tsx
type ButtonProps = React.ButtonHTMLAttributes<HTMLButtonElement> & {
  variant?: 'primary' | 'outline' | 'ghost' | 'danger'
  size?: 'sm' | 'md' | 'lg'
  loading?: boolean
}

const variantClass = {
  primary: 'bg-blue-600 text-white hover:bg-blue-700',
  outline: 'border border-gray-300 text-gray-700 hover:bg-gray-50',
  ghost:   'text-gray-600 hover:bg-gray-100',
  danger:  'bg-red-600 text-white hover:bg-red-700',
}

const sizeClass = {
  sm: 'px-3 py-1.5 text-sm',
  md: 'px-4 py-2 text-sm',
  lg: 'px-6 py-3 text-base',
}

export function Button({ variant = 'primary', size = 'md', loading, children, className, ...props }: ButtonProps) {
  return (
    <button
      className={`inline-flex items-center justify-center rounded-md font-medium transition-colors
        disabled:opacity-50 disabled:cursor-not-allowed
        ${variantClass[variant]} ${sizeClass[size]} ${className ?? ''}`}
      disabled={loading || props.disabled}
      {...props}
    >
      {loading && <span className="mr-2 h-4 w-4 animate-spin rounded-full border-2 border-current border-t-transparent" />}
      {children}
    </button>
  )
}
```

### Input
```tsx
// components/ui/Input.tsx
type InputProps = React.InputHTMLAttributes<HTMLInputElement> & {
  label?: string
  error?: string
}

export function Input({ label, error, className, ...props }: InputProps) {
  return (
    <div className="flex flex-col gap-1">
      {label && <label className="text-sm font-medium text-gray-700">{label}</label>}
      <input
        className={`rounded-md border px-3 py-2 text-sm outline-none transition
          focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20
          ${error ? 'border-red-400' : 'border-gray-300'}
          ${className ?? ''}`}
        {...props}
      />
      {error && <p className="text-xs text-red-500">{error}</p>}
    </div>
  )
}
```

### Card
```tsx
// components/ui/Card.tsx
export function Card({ children, className }: { children: React.ReactNode; className?: string }) {
  return (
    <div className={`rounded-lg border border-gray-200 bg-white p-6 shadow-sm ${className ?? ''}`}>
      {children}
    </div>
  )
}
```

### Table (목록 화면)
```tsx
<div className="overflow-x-auto rounded-lg border border-gray-200">
  <table className="w-full text-sm">
    <thead className="bg-gray-50 text-left text-xs font-medium uppercase text-gray-500">
      <tr>
        <th className="px-4 py-3">이름</th>
        <th className="px-4 py-3">이메일</th>
        <th className="px-4 py-3 text-right">액션</th>
      </tr>
    </thead>
    <tbody className="divide-y divide-gray-200">
      {users.map((user) => (
        <tr key={user.id} className="hover:bg-gray-50">
          <td className="px-4 py-3">{user.name}</td>
          <td className="px-4 py-3 text-gray-500">{user.email}</td>
          <td className="px-4 py-3 text-right">
            <Button variant="ghost" size="sm">수정</Button>
          </td>
        </tr>
      ))}
    </tbody>
  </table>
</div>
```

### Modal
```tsx
// components/ui/Modal.tsx
export function Modal({ open, onClose, title, children }: {
  open: boolean
  onClose: () => void
  title: string
  children: React.ReactNode
}) {
  if (!open) return null
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center">
      <div className="absolute inset-0 bg-black/40" onClick={onClose} />
      <div className="relative w-full max-w-md rounded-lg bg-white p-6 shadow-xl">
        <h2 className="mb-4 text-lg font-semibold">{title}</h2>
        {children}
      </div>
    </div>
  )
}
```

## 자주 쓰는 레이아웃 패턴
```tsx
// 중앙 정렬 컨테이너
<div className="container mx-auto max-w-5xl px-4 py-8">

// 2열 그리드 (반응형)
<div className="grid grid-cols-1 gap-4 md:grid-cols-2">

// flex 가로 배치
<div className="flex items-center justify-between gap-4">

// 수직 폼 레이아웃
<form className="flex flex-col gap-4">
```

## cn() 유틸리티 — 조건부 클래스 합치기
```bash
npm install clsx tailwind-merge
```
```tsx
// lib/utils.ts
import { clsx, type ClassValue } from 'clsx'
import { twMerge } from 'tailwind-merge'

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

// 사용
<div className={cn('base-class', isActive && 'active-class', variant === 'error' && 'text-red-500')}>
```

## 주의사항
- 공통 컴포넌트를 `components/ui/`에 직접 만들어야 하므로 shadcn 대비 초기 셋업 시간이 더 걸림
- Tailwind 클래스가 길어지면 `cn()` 유틸리티로 분리하는 것이 가독성에 유리
- `tailwind.config.ts`의 `content` 경로에 컴포넌트 파일이 포함되어 있는지 확인 필수
- 다크모드 지원 시 `dark:` 변형 클래스 추가 필요 (`dark:bg-gray-800` 등)

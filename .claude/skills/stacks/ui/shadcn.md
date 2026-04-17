# UI Skill — shadcn/ui + Tailwind CSS

## 개념
shadcn/ui는 컴포넌트를 npm 패키지로 설치하지 않고 **소스코드를 프로젝트에 직접 복사**하는 방식입니다.
- `components/ui/` 폴더에 컴포넌트 코드가 실제로 존재
- 자유롭게 수정 가능 (스타일, 동작 모두)
- Radix UI (접근성) + Tailwind CSS (스타일) 조합

## 설치 확인
```bash
ls components/ui/   # 컴포넌트 파일 목록 확인
cat components.json  # shadcn 설정 확인
```

## 컴포넌트 추가
```bash
# 개별 컴포넌트 추가 (gateway에서 실행)
npx shadcn@latest add button
npx shadcn@latest add input
npx shadcn@latest add card
npx shadcn@latest add form
npx shadcn@latest add table
npx shadcn@latest add dialog
npx shadcn@latest add toast
npx shadcn@latest add dropdown-menu
```

## 폴더 구조
```
gateway/
├── components/
│   ├── ui/                  # shadcn 컴포넌트 (자동 생성, 수정 가능)
│   │   ├── button.tsx
│   │   ├── input.tsx
│   │   ├── card.tsx
│   │   └── ...
│   └── {도메인}/            # 비즈니스 컴포넌트 (직접 작성)
│       └── UserCard.tsx
├── lib/
│   └── utils.ts             # cn() 유틸리티 (shadcn 자동 생성)
└── app/
    └── globals.css          # Tailwind + CSS 변수 (shadcn 자동 생성)
```

## 기본 컴포넌트 사용 패턴

### Button
```tsx
import { Button } from '@/components/ui/button'

// variant: default | destructive | outline | secondary | ghost | link
// size: default | sm | lg | icon
<Button variant="default" size="sm" onClick={handleClick}>
  저장
</Button>

<Button variant="outline" disabled={isLoading}>
  {isLoading ? '처리 중...' : '취소'}
</Button>
```

### Input + Label (폼 필드)
```tsx
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'

<div className="space-y-2">
  <Label htmlFor="email">이메일</Label>
  <Input
    id="email"
    type="email"
    placeholder="user@example.com"
    value={email}
    onChange={(e) => setEmail(e.target.value)}
  />
</div>
```

### Card (컨테이너)
```tsx
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'

<Card>
  <CardHeader>
    <CardTitle>제목</CardTitle>
  </CardHeader>
  <CardContent>
    본문 내용
  </CardContent>
</Card>
```

### Form (react-hook-form 연동)
```tsx
import { useForm } from 'react-hook-form'
import { Form, FormField, FormItem, FormLabel, FormControl, FormMessage } from '@/components/ui/form'
import { Input } from '@/components/ui/input'
import { Button } from '@/components/ui/button'

const form = useForm<{ email: string; password: string }>()

<Form {...form}>
  <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
    <FormField
      control={form.control}
      name="email"
      rules={{ required: '이메일을 입력하세요' }}
      render={({ field }) => (
        <FormItem>
          <FormLabel>이메일</FormLabel>
          <FormControl>
            <Input type="email" placeholder="user@example.com" {...field} />
          </FormControl>
          <FormMessage />  {/* 에러 메시지 자동 표시 */}
        </FormItem>
      )}
    />
    <Button type="submit">로그인</Button>
  </form>
</Form>
```

### Table (목록 화면)
```tsx
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'

<Table>
  <TableHeader>
    <TableRow>
      <TableHead>이름</TableHead>
      <TableHead>이메일</TableHead>
      <TableHead className="text-right">액션</TableHead>
    </TableRow>
  </TableHeader>
  <TableBody>
    {users.map((user) => (
      <TableRow key={user.id}>
        <TableCell>{user.name}</TableCell>
        <TableCell>{user.email}</TableCell>
        <TableCell className="text-right">
          <Button variant="ghost" size="sm">수정</Button>
        </TableCell>
      </TableRow>
    ))}
  </TableBody>
</Table>
```

### Dialog (모달)
```tsx
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from '@/components/ui/dialog'

<Dialog>
  <DialogTrigger asChild>
    <Button>열기</Button>
  </DialogTrigger>
  <DialogContent>
    <DialogHeader>
      <DialogTitle>확인</DialogTitle>
    </DialogHeader>
    <p>정말 삭제하시겠습니까?</p>
  </DialogContent>
</Dialog>
```

## Tailwind 유틸리티 클래스 규칙

```tsx
// 레이아웃
className="flex items-center justify-between"
className="grid grid-cols-3 gap-4"
className="space-y-4"          // 수직 간격
className="space-x-2"          // 수평 간격

// 반응형
className="w-full md:w-1/2 lg:w-1/3"

// 텍스트
className="text-sm text-muted-foreground"   // shadcn CSS 변수 활용
className="text-lg font-semibold"

// 컨테이너
className="container mx-auto px-4 py-8"
className="max-w-md mx-auto"
```

## cn() 유틸리티 — 조건부 클래스
```tsx
import { cn } from '@/lib/utils'

// 조건에 따라 클래스 합치기
<div className={cn(
  "base-class",
  isActive && "active-class",
  variant === 'error' && "text-red-500"
)}>
```

## 주의사항
- `components/ui/` 파일은 직접 수정해도 됨 (라이브러리가 아닌 소스코드)
- `npx shadcn@latest add` 재실행 시 기존 파일 덮어쓰기 경고 발생 — 수정한 내용이 있으면 백업 후 실행
- Form 사용 시 `react-hook-form` 필수: `npm install react-hook-form`

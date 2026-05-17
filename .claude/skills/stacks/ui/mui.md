# UI Skill — MUI (Material UI)

## 개념
MUI는 Google Material Design 기반의 React 컴포넌트 라이브러리입니다.
- npm 패키지로 설치해서 사용 (shadcn과 달리 소스코드가 프로젝트에 없음)
- `sx` prop 또는 `styled()` API로 스타일 커스터마이징
- Emotion CSS-in-JS 기반

## 설치
```bash
npm install @mui/material @emotion/react @emotion/styled
npm install @mui/icons-material   # 아이콘 (선택)
```

## 설치 확인
```bash
cat package.json | grep "@mui"
```

## 폴더 구조
```
gateway/
├── app/
│   ├── layout.tsx          # ThemeProvider 최상위 적용
│   └── globals.css         # 기본 폰트·리셋 (tailwind 없이 MUI만 사용 시)
├── components/
│   ├── theme/
│   │   └── theme.ts        # 커스텀 테마 정의
│   └── {도메인}/
│       └── UserCard.tsx
```

## ThemeProvider 설정 (app/layout.tsx)
```tsx
'use client'
import { ThemeProvider, createTheme } from '@mui/material/styles'
import CssBaseline from '@mui/material/CssBaseline'

const theme = createTheme({
  palette: {
    primary: { main: '#1976d2' },
    secondary: { main: '#dc004e' },
  },
})

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="ko">
      <body>
        <ThemeProvider theme={theme}>
          <CssBaseline />
          {children}
        </ThemeProvider>
      </body>
    </html>
  )
}
```

## 기본 컴포넌트 사용 패턴

### Button
```tsx
import Button from '@mui/material/Button'

// variant: contained | outlined | text
// color: primary | secondary | error | warning | success
<Button variant="contained" color="primary" onClick={handleClick}>
  저장
</Button>

<Button variant="outlined" disabled={isLoading}>
  {isLoading ? '처리 중...' : '취소'}
</Button>
```

### TextField (입력 필드)
```tsx
import TextField from '@mui/material/TextField'

<TextField
  label="이메일"
  type="email"
  value={email}
  onChange={(e) => setEmail(e.target.value)}
  fullWidth
  error={!!errors.email}
  helperText={errors.email?.message}
/>
```

### Card (컨테이너)
```tsx
import Card from '@mui/material/Card'
import CardContent from '@mui/material/CardContent'
import CardHeader from '@mui/material/CardHeader'

<Card>
  <CardHeader title="제목" subheader="부제목" />
  <CardContent>
    본문 내용
  </CardContent>
</Card>
```

### Table (목록 화면)
```tsx
import Table from '@mui/material/Table'
import TableBody from '@mui/material/TableBody'
import TableCell from '@mui/material/TableCell'
import TableContainer from '@mui/material/TableContainer'
import TableHead from '@mui/material/TableHead'
import TableRow from '@mui/material/TableRow'
import Paper from '@mui/material/Paper'

<TableContainer component={Paper}>
  <Table>
    <TableHead>
      <TableRow>
        <TableCell>이름</TableCell>
        <TableCell>이메일</TableCell>
        <TableCell align="right">액션</TableCell>
      </TableRow>
    </TableHead>
    <TableBody>
      {users.map((user) => (
        <TableRow key={user.id}>
          <TableCell>{user.name}</TableCell>
          <TableCell>{user.email}</TableCell>
          <TableCell align="right">
            <Button size="small">수정</Button>
          </TableCell>
        </TableRow>
      ))}
    </TableBody>
  </Table>
</TableContainer>
```

### Dialog (모달)
```tsx
import Dialog from '@mui/material/Dialog'
import DialogTitle from '@mui/material/DialogTitle'
import DialogContent from '@mui/material/DialogContent'
import DialogActions from '@mui/material/DialogActions'

<Dialog open={open} onClose={() => setOpen(false)}>
  <DialogTitle>확인</DialogTitle>
  <DialogContent>
    정말 삭제하시겠습니까?
  </DialogContent>
  <DialogActions>
    <Button onClick={() => setOpen(false)}>취소</Button>
    <Button onClick={handleConfirm} color="error" variant="contained">삭제</Button>
  </DialogActions>
</Dialog>
```

## sx prop — 인라인 스타일
```tsx
// sx는 theme 토큰을 직접 참조 가능
<Box sx={{ display: 'flex', gap: 2, p: 2, bgcolor: 'background.paper' }}>
  <Typography sx={{ fontSize: '1rem', color: 'text.secondary' }}>
    텍스트
  </Typography>
</Box>

// 반응형
<Box sx={{ width: { xs: '100%', md: '50%' } }}>
```

## 주의사항
- Next.js App Router에서 MUI 컴포넌트는 기본적으로 클라이언트 컴포넌트 — 서버 컴포넌트에서 직접 사용 불가
- `'use client'` 선언이 필요한 컴포넌트를 별도 분리하는 것이 권장 패턴
- Tailwind와 혼용 시 스타일 충돌 주의 — MUI는 Emotion 기반이므로 `preflight` 비활성화 권장

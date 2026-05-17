# UI Skill — Ant Design

## 개념
Ant Design은 Alibaba가 만든 엔터프라이즈급 React 컴포넌트 라이브러리입니다.
- npm 패키지로 설치해서 사용
- 폼, 테이블, 모달 등 복잡한 UI 컴포넌트가 기본 내장
- CSS-in-JS 기반 (antd v5 이상)

## 설치
```bash
npm install antd
npm install @ant-design/icons   # 아이콘 (선택)
```

## 설치 확인
```bash
cat package.json | grep "antd"
```

## 폴더 구조
```
gateway/
├── app/
│   ├── layout.tsx          # AntdRegistry + ConfigProvider 최상위 적용
│   └── globals.css         # 기본 리셋
├── components/
│   ├── providers/
│   │   └── AntdRegistry.tsx  # Next.js App Router SSR 호환 설정
│   └── {도메인}/
│       └── UserCard.tsx
```

## Next.js App Router 설정

antd v5는 App Router에서 SSR 스타일 주입을 위한 별도 설정이 필요합니다.

```tsx
// components/providers/AntdRegistry.tsx
'use client'
import { createCache, extractStyle, StyleProvider } from '@ant-design/cssinjs'
import { useServerInsertedHTML } from 'next/navigation'
import { useState } from 'react'

export default function AntdRegistry({ children }: { children: React.ReactNode }) {
  const [cache] = useState(() => createCache())
  useServerInsertedHTML(() => (
    <style id="antd" dangerouslySetInnerHTML={{ __html: extractStyle(cache, true) }} />
  ))
  return <StyleProvider cache={cache}>{children}</StyleProvider>
}
```

```tsx
// app/layout.tsx
import { ConfigProvider } from 'antd'
import koKR from 'antd/locale/ko_KR'
import AntdRegistry from '@/components/providers/AntdRegistry'

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="ko">
      <body>
        <AntdRegistry>
          <ConfigProvider locale={koKR} theme={{ token: { colorPrimary: '#1677ff' } }}>
            {children}
          </ConfigProvider>
        </AntdRegistry>
      </body>
    </html>
  )
}
```

## 기본 컴포넌트 사용 패턴

### Button
```tsx
import { Button } from 'antd'

// type: primary | default | dashed | text | link
// danger: 삭제 등 위험 액션
<Button type="primary" onClick={handleClick}>저장</Button>
<Button loading={isLoading}>처리 중</Button>
<Button type="primary" danger>삭제</Button>
```

### Input (입력 필드)
```tsx
import { Input, Form } from 'antd'

// Form과 함께 사용 (유효성 검사 내장)
<Form form={form} layout="vertical" onFinish={onSubmit}>
  <Form.Item
    label="이메일"
    name="email"
    rules={[{ required: true, message: '이메일을 입력하세요' }, { type: 'email' }]}
  >
    <Input placeholder="user@example.com" />
  </Form.Item>
  <Button type="primary" htmlType="submit">제출</Button>
</Form>
```

### Card (컨테이너)
```tsx
import { Card } from 'antd'

<Card title="제목" extra={<Button type="link">더보기</Button>}>
  본문 내용
</Card>
```

### Table (목록 화면)
```tsx
import { Table, Button } from 'antd'
import type { ColumnsType } from 'antd/es/table'

const columns: ColumnsType<User> = [
  { title: '이름', dataIndex: 'name', key: 'name' },
  { title: '이메일', dataIndex: 'email', key: 'email' },
  {
    title: '액션',
    key: 'action',
    align: 'right',
    render: (_, record) => <Button size="small">수정</Button>,
  },
]

<Table
  columns={columns}
  dataSource={users}
  rowKey="id"
  pagination={{ pageSize: 20 }}
/>
```

### Modal (모달)
```tsx
import { Modal, Button } from 'antd'

<Modal
  title="확인"
  open={open}
  onOk={handleConfirm}
  onCancel={() => setOpen(false)}
  okText="삭제"
  cancelText="취소"
  okButtonProps={{ danger: true }}
>
  정말 삭제하시겠습니까?
</Modal>
```

## useForm 훅 (antd 내장)
```tsx
import { Form } from 'antd'

const [form] = Form.useForm()

// 값 가져오기
const values = form.getFieldsValue()

// 값 설정
form.setFieldsValue({ email: 'user@example.com' })

// 초기화
form.resetFields()

// 유효성 검사
await form.validateFields()
```

## 주의사항
- Next.js App Router에서 `AntdRegistry` 없이 사용하면 첫 렌더링에 스타일 깨짐 발생
- antd 컴포넌트는 `'use client'`가 필요한 경우가 많음 — 서버 컴포넌트 안에서 직접 사용 불가
- Tailwind와 혼용 시 CSS 우선순위 충돌 주의 — antd의 CSS-in-JS가 Tailwind 클래스를 덮어쓸 수 있음
- `locale={koKR}` 설정 안 하면 날짜 선택기 등이 영문으로 표시됨

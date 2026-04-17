# Next.js App Router 스킬

## 폴더 구조
app/
├── layout.tsx        # 루트 레이아웃
├── page.tsx          # 홈 페이지
├── api/              # API Routes
│   └── [서비스]/
│       └── route.ts
└── [기능]/
    ├── page.tsx
    └── components/

## 핵심 패턴

### 서버 컴포넌트 (기본)
async function Page() {
  const data = await fetch('http://서비스:포트/api/...')
  return <div>{data}</div>
}

### 클라이언트 컴포넌트 (상태/이벤트 필요시)
'use client'
import { useState } from 'react'

### API Route (백엔드 API와 동일 개념)
export async function GET(request: Request) {
  return Response.json({ data: '...' })
}
export async function POST(request: Request) {
  const body = await request.json()
  return Response.json({ result: '...' })
}
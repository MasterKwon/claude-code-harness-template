> 권장 모델: balanced

당신은 **프로젝트 설정 마법사** 역할입니다. 기술 스택을 선택받고 프로젝트를 초기화한 뒤 필요한 패키지를 자동으로 설치합니다.

## 실행 전 확인

```bash
node -v   # 18 이상 필요
npm -v
```

---

## Step 1 — 선택 인터뷰 (grill-me 스타일)

아래 10개 항목을 **인터뷰 형식**으로 한 번에 하나씩 묻습니다. ★는 권장 답안입니다.

### Step 1.0 — 진행 모드 선택 (첫 질문)

먼저 사용자에게 한 줄 묻습니다:

```
설정을 어떻게 진행할까요?
  A. 빠른 시작 — 모든 항목 권장 기본값(★)으로 진행 ★
  B. 인터뷰 — 항목별로 하나씩 선택
  C. 부분 인터뷰 — 일부 항목만 골라 변경, 나머지는 기본값
```

- **A 선택 시** → 아래 10개 항목 전부 권장 답안으로 확정 → Step 1.99 (요약 확인) 로 점프
- **B 선택 시** → Step 1.1 부터 항목 인터뷰 진행
- **C 선택 시** → "어떤 항목을 변경하고 싶습니까? (번호 예: 2, 4, 10)" 추가 질문 후, 지정된 항목만 인터뷰. 나머지는 기본값.

### Step 1.1 ~ 1.10 — 항목별 인터뷰

각 항목은 다음 형식으로 묻습니다:

```
[N/10] {항목명}
  A. {옵션 1} ★ — {짧은 이유}
  B. {옵션 2} — {짧은 이유}
  ...
  권장: A. {이유 한 줄}. 동의하십니까? (다른 옵션 원하면 글자 입력)
```

**의존 분기 자동 처리**:
- [1]에서 **B. 모노리스** 선택 → [7] 서비스 간 통신 항목 자동 건너뛰기 (해당 없음)
- [2]에서 **C. MongoDB** 선택 → [3] ORM 은 자동으로 **C. Mongoose** 확정 (다른 선택 무의미)
- [2]에서 **D. SQLite** 선택 → [3] ORM 권장 답안을 **A. Prisma** 로 (TypeORM/Raw SQL 도 가능하지만 마이그레이션 자동을 위해)

#### 항목 목록

| # | 항목명 | 옵션 (★ = 기본값) |
|---|--------|-----------------|
| 1 | 프로젝트 구조 | A. MSA ★ · B. 모노리스 |
| 2 | 데이터베이스 | A. PostgreSQL ★ · B. MySQL · C. MongoDB · D. SQLite |
| 3 | ORM / 데이터 접근 | A. Prisma ★ · B. TypeORM · C. Mongoose · D. Raw SQL |
| 4 | 인증/인가 | A. JWT ★ · B. NextAuth.js · C. 없음 |
| 5 | API 스타일 | A. REST ★ · B. tRPC · C. GraphQL |
| 6 | 상태 관리 | A. TanStack Query ★ · B. Zustand + TanStack · C. Redux Toolkit · D. Context API |
| 7 | 서비스 간 통신 (MSA 시만) | A. REST만 ★ · B. REST + Redis · C. REST + RabbitMQ |
| 8 | 파일 업로드 | A. AWS S3 · B. 로컬 · C. 없음 ★ |
| 9 | 배포 방식 | A. Docker + compose ★ · B. Vercel + 별도 서버 · C. PM2 |
| 10 | UI 컴포넌트 | A. shadcn/ui + Tailwind ★ · B. MUI · C. Ant Design · D. Tailwind only |

### Step 1.99 — 전체 선택 요약 및 확인

A/B/C 어떤 모드든 인터뷰 후에는 **전체 선택을 한 번에 요약하고 사용자 확인**을 받습니다:

```
선택 요약:
  [1] 구조: MSA
  [2] DB: PostgreSQL
  [3] ORM: Prisma
  [4] 인증: JWT
  ...

이 조합으로 진행할까요? (수정하려면 항목 번호 알려주세요)
```

사용자 확정 후 Step 2부터 실행합니다.

> **저장**: 선택 결과는 별도 파일로 저장하지 않습니다. 최종 결과는 `CLAUDE.md` 의 `## Tech Stack` 과 `## Active Skills` 섹션에 기록됩니다 (Step 5).

---

## Step 2 — 프로젝트 초기화

### [1-A] MSA 구조

```bash
# gateway — Next.js (프론트 + API Gateway)
npx create-next-app@latest gateway --typescript --tailwind --eslint --app --no-src-dir --import-alias "@/*"
```

추가 서비스 수와 이름을 사용자에게 확인 후 생성합니다. (기본: user-service)

```bash
mkdir -p services/{서비스명}
cd services/{서비스명} && npm init -y && npm install typescript ts-node @types/node --save-dev && cd ../..
```

MSA 서비스 목록과 포트를 확정합니다:
- gateway: 3000
- 각 서비스: 3001부터 순서대로 할당

### [1-B] 모노리스 구조

```bash
npx create-next-app@latest . --typescript --tailwind --eslint --app --no-src-dir --import-alias "@/*"
```

---

## Step 3 — 패키지 설치

선택 조합에 맞는 명령만 실행합니다.
MSA는 서비스별로 설치 위치가 다르므로 아래 기준을 따릅니다:
- DB/ORM/인증 → 각 서비스 디렉터리에서 설치
- 상태관리/API 스타일(tRPC/GraphQL) → gateway에서 설치
- 공통 라이브러리 → 해당하는 모든 서비스에 설치

### DB + ORM

| 선택 | 명령 |
|------|------|
| PostgreSQL + Prisma [2-A, 3-A] | `npm install prisma @prisma/client` → `npx prisma init --datasource-provider postgresql` |
| PostgreSQL + TypeORM [2-A, 3-B] | `npm install typeorm reflect-metadata pg` + `npm install -D @types/pg` |
| MySQL + Prisma [2-B, 3-A] | `npm install prisma @prisma/client` → `npx prisma init --datasource-provider mysql` |
| MySQL + TypeORM [2-B, 3-B] | `npm install typeorm reflect-metadata mysql2` |
| MongoDB + Mongoose [2-C, 3-C] | `npm install mongoose` |
| SQLite + Prisma [2-D, 3-A] | `npm install prisma @prisma/client` → `npx prisma init --datasource-provider sqlite` |
| Raw SQL — PostgreSQL [3-D] | `npm install pg` + `npm install -D @types/pg` |
| Raw SQL — MySQL [3-D] | `npm install mysql2` |

TypeORM 선택 시 `tsconfig.json`에 추가:
```json
"experimentalDecorators": true,
"emitDecoratorMetadata": true
```

### 인증

| 선택 | 명령 |
|------|------|
| JWT [4-A] | `npm install jsonwebtoken bcryptjs` + `npm install -D @types/jsonwebtoken @types/bcryptjs` |
| NextAuth [4-B] | `npm install next-auth` (gateway에서만) |

### 공통 패키지 (항상 설치)

```bash
# gateway에서 실행

# Swagger — API 문서 자동 생성
npm install next-swagger-doc swagger-ui-react
npm install -D @types/swagger-ui-react

# Zod — 입력값 유효성 검증 (TypeScript 스키마 기반)
npm install zod
```

### API 스타일

| 선택 | 명령 (gateway에서) |
|------|------|
| tRPC [5-B] | `npm install @trpc/server @trpc/client @trpc/next @tanstack/react-query` |
| GraphQL [5-C] | `npm install @apollo/server @apollo/client graphql` |

### 상태 관리

| 선택 | 명령 (gateway에서) |
|------|------|
| TanStack Query [6-A] | `npm install @tanstack/react-query` |
| Zustand + TanStack Query [6-B] | `npm install zustand @tanstack/react-query` |
| Redux Toolkit [6-C] | `npm install @reduxjs/toolkit react-redux` |

### 서비스 간 통신 (MSA)

| 선택 | 명령 (각 서비스에서) |
|------|------|
| Redis [7-B] | `npm install ioredis` + `npm install -D @types/ioredis` |
| RabbitMQ [7-C] | `npm install amqplib` + `npm install -D @types/amqplib` |

### 파일 업로드

| 선택 | 명령 |
|------|------|
| AWS S3 [8-A] | `npm install @aws-sdk/client-s3 multer` + `npm install -D @types/multer` |
| 로컬 [8-B] | `npm install multer` + `npm install -D @types/multer` |

### UI 컴포넌트 라이브러리 (gateway에서 설치)

| 선택 | 명령 |
|------|------|
| shadcn/ui [10-A] | `npx shadcn@latest init` (대화형 설정) → `npx shadcn@latest add button input label card` |
| MUI [10-B] | `npm install @mui/material @emotion/react @emotion/styled @mui/icons-material` |
| Ant Design [10-C] | `npm install antd @ant-design/icons` |
| Tailwind only [10-D] | 추가 설치 없음 (Next.js 초기화 시 이미 포함) |

> shadcn/ui 선택 시 `npx shadcn@latest init` 실행 중 아래 옵션 선택:
> - Style: Default
> - Base color: Slate
> - CSS variables: Yes

### 배포

| 선택 | 명령 / 파일 |
|------|------|
| PM2 [9-C] | `npm install -D pm2` → `ecosystem.config.js` 생성 |

---

## Step 4 — 설정 파일 생성

### .env.example

선택 항목에 해당하는 변수만 포함하여 각 서비스 루트에 생성합니다.

```bash
# 공통
NODE_ENV=development
PORT=300X

# DB [2,3 선택에 따라]
DATABASE_URL=

# JWT [4-A]
JWT_SECRET=your-secret-key-here
JWT_EXPIRES_IN=7d

# NextAuth [4-B]
NEXTAUTH_SECRET=your-nextauth-secret
NEXTAUTH_URL=http://localhost:3000

# Redis [7-B]
REDIS_URL=redis://localhost:6379

# RabbitMQ [7-C]
RABBITMQ_URL=amqp://localhost:5672

# AWS S3 [8-A]
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_REGION=ap-northeast-2
AWS_S3_BUCKET=

# MSA 서비스 URL [1-A] — gateway에만
USER_SERVICE_URL=http://localhost:3001
# 추가 서비스는 동일 패턴으로 추가
```

### Docker 파일 [9-A]

**루트 `docker-compose.yml`** 생성 (MSA 기준):

```yaml
version: '3.8'
services:
  gateway:
    build: ./gateway
    ports:
      - "3000:3000"
    env_file: ./gateway/.env
    depends_on:
      - user-service

  user-service:
    build: ./services/user-service
    ports:
      - "3001:3001"
    env_file: ./services/user-service/.env

  # Redis [7-B]
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

  # RabbitMQ [7-C]
  rabbitmq:
    image: rabbitmq:3-management-alpine
    ports:
      - "5672:5672"
      - "15672:15672"

  # PostgreSQL [2-A]
  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_PASSWORD: password
      POSTGRES_DB: mydb
    ports:
      - "5432:5432"

  # MySQL [2-B]
  mysql:
    image: mysql:8-alpine
    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_DATABASE: mydb
    ports:
      - "3306:3306"

  # MongoDB [2-C]
  mongodb:
    image: mongo:7
    ports:
      - "27017:27017"
```

선택하지 않은 서비스(Redis, RabbitMQ, DB 등)는 파일에서 제거합니다.

각 서비스 디렉터리에 **Dockerfile** 생성:

```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build
EXPOSE 300X
CMD ["npm", "start"]
```

### PM2 설정 [9-C]

루트에 `ecosystem.config.js` 생성:

```javascript
module.exports = {
  apps: [
    { name: 'gateway', cwd: './gateway', script: 'npm', args: 'start', env: { PORT: 3000 } },
    { name: 'user-service', cwd: './services/user-service', script: 'npm', args: 'start', env: { PORT: 3001 } },
    // 추가 서비스
  ]
}
```

---

## Step 5 — CLAUDE.md 업데이트

프로젝트의 `CLAUDE.md`에 아래 내용을 순서대로 업데이트합니다.

### Environment 플레이스홀더 채우기

아래 명령으로 현재 환경 정보를 확인한 후 `CLAUDE.md`의 플레이스홀더를 실제 값으로 교체합니다:

```bash
pwd          # 현재 작업 디렉터리 확인
uname -s     # OS 확인 (Linux/Darwin/Windows_NT)
```

| 플레이스홀더 | 교체 값 |
|-------------|---------|
| `{{PLATFORM}}` | Windows 11 / macOS / Ubuntu 등 실제 OS |
| `{{WORKING_DIRECTORY}}` | `pwd` 결과값 (프로젝트 루트 절대경로) |

예시:
```markdown
## Environment
- Platform: Windows 11
- Shell: bash (Unix syntax)
- Working directory: C:\WorkSpace\MyProject
```

### Tech Stack 섹션
```markdown
## Tech Stack
- Frontend: Next.js (App Router), TypeScript, Tailwind CSS
- UI Library: [shadcn/ui / MUI / Ant Design / Tailwind only]
- Architecture: [MSA / 모노리스]
- Database: [PostgreSQL / MySQL / MongoDB / SQLite]
- ORM: [Prisma / TypeORM / Mongoose / Raw SQL]
- Auth: [JWT / NextAuth / 없음]
- API Style: [REST / tRPC / GraphQL]
- State Management: [TanStack Query / Zustand+TanStack / Redux / Context]
- Service Communication: [REST / Redis / RabbitMQ]  ← MSA만
- File Storage: [S3 / Local / 없음]
- Deploy: [Docker / Vercel / PM2]
- Package Manager: npm

## Services  ← MSA만
- gateway: port 3000
- {서비스명}: port 3001
- (추가 서비스)
```

### Active Skills 섹션 — 선택한 스택에 해당하는 파일 경로로 업데이트

선택 조합에 따라 아래 매핑을 참조하여 실제 파일 경로로 채웁니다:

```markdown
## Active Skills
- framework: .claude/skills/stacks/framework/nextjs.md              ← 고정 (단일 프레임워크)
- arch:      .claude/skills/stacks/arch/[msa | monolith].md
- orm:       .claude/skills/stacks/orm/[prisma | typeorm | mongoose | raw-sql].md
- api-style: .claude/skills/stacks/api-style/[rest | trpc | graphql].md
- state:     .claude/skills/stacks/state/[tanstack-query | zustand | redux].md
- ui:        .claude/skills/stacks/ui/[shadcn | mui | antd | tailwind-only].md
```

예시 (MSA + Prisma + REST + TanStack Query + shadcn/ui 선택 시):
```markdown
## Active Skills
- framework: .claude/skills/stacks/framework/nextjs.md
- arch:      .claude/skills/stacks/arch/msa.md
- orm:       .claude/skills/stacks/orm/prisma.md
- api-style: .claude/skills/stacks/api-style/rest.md
- state:     .claude/skills/stacks/state/tanstack-query.md
- ui:        .claude/skills/stacks/ui/shadcn.md
```

---

## Step 6 — 완료 보고

설치 완료 후 사용자에게 보고합니다:

1. **생성된 구조** — 폴더 트리 출력
2. **설치된 패키지** — 서비스별 주요 패키지 목록
3. **다음 필수 작업**
   - `.env.example`을 `.env`로 복사 후 실제 값 입력
   - Prisma 선택 시: `schema.prisma` 작성 후 `npx prisma migrate dev`
   - Docker 선택 시: `docker-compose up -d`로 인프라 기동
4. **다음 단계**: Phase 1 — `/analyze-requirements` 실행

---
프로젝트 루트 디렉터리에서 실행합니다. Node.js 18 이상 필요.

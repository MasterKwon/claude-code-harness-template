# Architecture Skill — MSA (Microservices)

## 폴더 구조

```
프로젝트 루트/
├── gateway/                  # API Gateway + 프론트엔드 (port 3000)
│   ├── app/                  # Next.js App Router
│   │   ├── (pages)/          # 화면 페이지
│   │   ├── api/              # API Route (외부 → 서비스 프록시)
│   │   └── components/       # UI 컴포넌트
│   ├── lib/                  # 클라이언트 유틸리티 (fetch wrapper 등)
│   └── types/                # 게이트웨이 전용 타입
└── services/
    └── {service-name}/       # 독립 서비스 (port 3001+)
        ├── src/
        │   ├── controller/   # 요청 수신, 응답 반환만
        │   ├── service/      # 비즈니스 로직 (핵심)
        │   ├── repository/   # DB 접근만 (쿼리 집합)
        │   ├── model/        # 데이터 모델 / 스키마
        │   └── types/        # 서비스 전용 타입
        └── package.json
```

## 레이어 분리 원칙

### Controller (진입점)
- 요청 파싱, 응답 직렬화만 담당
- 비즈니스 로직 절대 포함 금지
- Service를 호출하고 결과를 반환하는 것이 전부

```typescript
// ✅ 올바른 예
export async function POST(req: Request) {
  const body = await req.json()
  const result = await userService.createUser(body)
  return Response.json(result, { status: 201 })
}

// ❌ 잘못된 예 — 비즈니스 로직이 Controller에 있음
export async function POST(req: Request) {
  const body = await req.json()
  const hashed = await bcrypt.hash(body.password, 10)  // ← Service로
  const user = await db.user.create({ data: { ...body, password: hashed } })
  return Response.json(user)
}
```

### Service (비즈니스 로직)
- 모든 비즈니스 규칙이 여기에 위치
- DB를 직접 호출하지 않음 — Repository를 통해서만
- 다른 서비스 호출 시 HTTP 클라이언트를 사용

```typescript
// ✅ 올바른 예
class UserService {
  async createUser(data: CreateUserDto) {
    const exists = await this.userRepository.findByEmail(data.email)
    if (exists) throw new Error('이미 존재하는 이메일')
    const hashed = await bcrypt.hash(data.password, 10)
    return this.userRepository.create({ ...data, password: hashed })
  }
}
```

### Repository (데이터 접근)
- DB 쿼리만 담당 — 비즈니스 로직 없음
- 반환값은 항상 도메인 모델 또는 null

```typescript
// ✅ 올바른 예
class UserRepository {
  async findByEmail(email: string) {
    return prisma.user.findUnique({ where: { email } })
  }
  async create(data: CreateUserInput) {
    return prisma.user.create({ data })
  }
}
```

## 게이트웨이 vs 서비스 역할 분리

| 역할 | Gateway | Service |
|------|---------|---------|
| 화면 렌더링 | ✅ | ❌ |
| 인증 토큰 검증 | ✅ (미들웨어) | ❌ |
| 비즈니스 로직 | ❌ | ✅ |
| DB 직접 접근 | ❌ | ✅ |
| 외부 API 호출 | 프록시만 | ✅ |

## 공통 영역 기준

```
공통 코드를 어디에 둘지 판단 기준:

여러 서비스에서 동일하게 사용하는 타입/인터페이스
  → 각 서비스의 types/ 에 복사 (서비스 독립성 유지)
  → 공유 패키지(packages/)는 규모가 커진 후 도입

게이트웨이에서만 쓰는 유틸
  → gateway/lib/

특정 서비스에서만 쓰는 유틸
  → services/{name}/src/utils/
```

## 서비스 간 통신

```typescript
// gateway -> service
const USER_SERVICE_URL = process.env.USER_SERVICE_URL // 하드코딩 금지

const response = await fetch(`${USER_SERVICE_URL}/api/users`, {
  headers: { 'x-internal-token': process.env.INTERNAL_TOKEN }
})
```

- 서비스 간 URL은 반드시 환경변수로 관리
- 내부 서비스 엔드포인트는 외부에 노출하지 않음
- 서비스 직접 호출은 게이트웨이를 통해서만

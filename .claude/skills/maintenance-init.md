# 기존 시스템 역공학 초기화 스킬

당신은 **시스템 분석가 겸 아키텍트**입니다.
이 스킬은 우리 하네스 없이 만들어진 기존 시스템에 `pipeline-maintenance`를 적용하기 위해
**코드베이스를 역공학하여 설계 문서를 재구성**합니다.

프로젝트 시작 시 **단 한 번** 실행합니다. 이후 유지보수는 `/pipeline-maintenance`가 담당합니다.

---

## 사전 조건 확인

`docs/02.design/reviewed/` 디렉터리에 `db.md`, `api.md`, `screen.md` 중 하나라도 존재하면
이미 초기화된 상태입니다. 사용자에게 확인 후 덮어쓸지 결정합니다.

---

## Step 0 — 기술 스택 자동 감지

코드베이스에서 아래 파일을 탐색하여 기술 스택을 파악합니다:

```
package.json / requirements.txt / go.mod / pom.xml / Gemfile  ← 언어/프레임워크
prisma/schema.prisma / *.sql / typeorm.config.ts              ← ORM/DB
src/app/api / routes/ / controllers/                          ← API 구조
src/app / pages/ / views/ / templates/                        ← 화면 구조
```

감지 결과를 사용자에게 보고합니다:
```
[기술 스택 감지]
언어/런타임: (Node.js 25 / Python 3.11 / ...)
프레임워크: (Next.js / Express / Django / ...)
ORM/DB: (Prisma+SQLite / TypeORM+PostgreSQL / ...)
API 스타일: (REST / GraphQL / tRPC / ...)
UI: (React / Vue / 서버사이드 렌더링 / ...)
```

---

## Step 1 — DB 스키마 역공학 → `docs/02.design/reviewed/db.md`

우선순위 순서로 DB 구조를 파악합니다:

1. **ORM 스키마 파일** (Prisma schema, TypeORM entity, Django models 등) — 가장 정확
2. **마이그레이션 파일** (SQL UP/DOWN, Alembic 등) — 히스토리 포함
3. **실제 DB 덤프** (`dev.db`, `*.sql` 덤프) — 현재 상태

파악한 내용으로 아래 형식으로 작성합니다:
- 테이블/모델 목록 (컬럼명, 타입, 제약조건)
- 관계(ERD 개념) — FK 및 1:N, N:M 관계
- 인덱스 목록
- 문서 상단에 `> ⚠️ 역공학 재구성 문서입니다. 실제 코드 기준이므로 검토 후 확정하세요.` 명시

---

## Step 2 — API 명세 역공학 → `docs/02.design/reviewed/api.md`

우선순위 순서로 API 구조를 파악합니다:

1. **라우터/컨트롤러 파일** — 경로, HTTP 메서드, 핸들러
2. **OpenAPI/Swagger 파일** (있으면) — 가장 정확
3. **미들웨어** — 인증/인가 구조 파악

파악한 내용으로 아래 형식으로 작성합니다:
- 엔드포인트 목록 (메서드, 경로, 설명)
- 요청/응답 스키마 (주요 필드 기준, 완전한 JSON 스키마 불필요)
- 인증 방식 (JWT, Session, OAuth 등)
- 에러 코드 패턴
- 문서 상단에 `> ⚠️ 역공학 재구성 문서입니다.` 명시

---

## Step 3 — 화면 구조 역공학 → `docs/02.design/reviewed/screen.md`

우선순위 순서로 화면 구조를 파악합니다:

1. **페이지/뷰 파일** (`app/`, `pages/`, `views/`) — 라우팅 구조
2. **컴포넌트 파일** — 주요 UI 블록
3. **라우터 설정** — 페이지 흐름

파악한 내용으로 아래 형식으로 작성합니다:
- 페이지 목록 (경로, 접근 권한, 주요 기능)
- 핵심 사용자 흐름 (주요 시나리오 3~5개)
- 주요 컴포넌트 구조
- 문서 상단에 `> ⚠️ 역공학 재구성 문서입니다.` 명시

---

## Step 4 — AS-IS 분석 → `docs/01.analyze/reviewed/asis.md`

코드베이스 전반을 분석하여 현황을 기록합니다:

- **현재 기술 스택** (Step 0 결과 활용)
- **주요 기능 목록** (코드에서 역추적)
- **알려진 이슈/제약사항** (TODO/FIXME 주석, 하드코딩된 값, 레거시 패턴 등)
- **데이터 흐름 요약** (화면 → API → DB 연결 구조)

---

## Step 5 — 요구사항 추정 → `docs/01.analyze/reviewed/requirements.md`

코드에서 역추적한 기능을 요구사항 형식으로 정리합니다:

> 이 문서는 "코드가 현재 하는 일"을 요구사항처럼 표현한 것입니다.
> 실제 비즈니스 요구사항과 다를 수 있으므로 고객 확인이 필요합니다.

- 기능 목록 (코드에서 확인된 것만)
- 각 기능의 현재 동작 방식
- 불확실한 항목은 `[확인 필요]` 태그 명시

---

## Step 6 — 초기화 완료 보고

```
[maintenance-init 완료]

재구성된 문서:
  ✓ docs/01.analyze/reviewed/asis.md
  ✓ docs/01.analyze/reviewed/requirements.md
  ✓ docs/02.design/reviewed/db.md
  ✓ docs/02.design/reviewed/api.md
  ✓ docs/02.design/reviewed/screen.md

⚠️  모든 문서는 코드 역공학 기반입니다.
    실제 비즈니스 요구사항과 다를 수 있으니 검토 후 수정하세요.
    [확인 필요] 태그가 붙은 항목을 우선 확인하세요.

다음 단계: /pipeline-maintenance 로 유지보수 업무를 시작하세요.
```

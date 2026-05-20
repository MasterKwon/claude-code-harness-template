> 권장 모델: balanced

당신은 **DB 설계자** 역할입니다. 요구사항을 바탕으로 데이터 구조와 스키마를 설계합니다.

## 사전 동작 — 이전 리뷰 통과 사본 무효화 (필수)

이 스킬은 `db.md` 를 새로 생성/갱신하므로, **실행 시작 시 다음 파일이 존재하면 즉시 삭제**합니다 (의존 파일 연쇄):
- `docs/02.design/reviewed/db.md`
- `docs/02.design/reviewed/api.md` (`api` 는 `db` 의존)
- `docs/02.design/reviewed/tc/uat-checklist.md` (`tc` 는 `db` 의존)

이전 `review-design` 통과 사본은 더 이상 유효하지 않습니다.

## 사전 동작 — grill-decisions 반영 (선택)

`docs/02.design/grill-decisions.md` 가 존재하면 먼저 읽고, 누적된 인터뷰 결정 사항을 본 작업에 반영합니다.
설계 중 `/grill-me` 호출로 추가된 의사결정을 누락 없이 반영하기 위함입니다.

## 역할 원칙
- `docs/01.analyze/reviewed/requirements.md` 의 DB 섹션을 **필수**로 기반 삼고, `docs/01.analyze/reviewed/gap.md` 는 **있을 때만** 변경 범위 참조용으로 추가 활용 (신규 프로젝트는 gap.md 가 없으므로 requirements.md 단독)
- 특정 DBMS에 종속되지 않은 논리 설계 우선, 이후 물리 설계
- 정규화와 성능 트레이드오프를 명시

## 참조 스킬
`CLAUDE.md`의 `## Active Skills` 섹션을 읽고 해당 파일을 참조합니다.

```
orm: CLAUDE.md에 명시된 경로 읽기  (스키마 작성 방식, 타입, soft delete 컬럼)
```

Active Skills가 없거나 비어 있으면 기본값 사용:
- orm: `.claude/skills/stacks/orm/prisma.md`

---

## 네이밍 컨벤션

### 테이블명 / 컬럼명 — snake_case 사용
```
✅ user_profiles, order_items, created_at, deleted_at
❌ userProfiles, orderItems, createdAt, deletedAt
```

### 규칙 요약
| 대상 | 규칙 | 예시 |
|------|------|------|
| 테이블명 | snake_case 복수형 | `users`, `order_items` |
| 컬럼명 | snake_case | `first_name`, `created_at` |
| PK | `id` | UUID 또는 BIGINT |
| FK | `{참조테이블단수}_id` | `user_id`, `order_id` |
| 인덱스명 | `idx_{테이블}_{컬럼}` | `idx_users_email` |
| 유니크 제약 | `uq_{테이블}_{컬럼}` | `uq_users_email` |

---

## 공통 컬럼 (모든 테이블 필수 포함)

```sql
id         UUID / BIGSERIAL   PK
created_at TIMESTAMP          NOT NULL DEFAULT now()
updated_at TIMESTAMP          NOT NULL DEFAULT now()
deleted_at TIMESTAMP          NULL      -- soft delete용, NULL이면 유효한 레코드
```

- `deleted_at IS NULL` 조건을 모든 SELECT 쿼리의 기본 필터로 사용
- 실제 삭제(hard delete)는 원칙적으로 금지. 예외는 설계 결정 사항에 명시

---

## Soft Delete 정책

```
삭제 요청 → deleted_at = NOW() 로 업데이트 (레코드 유지)
조회 시   → WHERE deleted_at IS NULL 필터 필수
복구 가능 → deleted_at = NULL 로 복원
```

### ORM별 구현은 해당 orm 스킬 파일 참조

---

## 기존 설계 확인 (증분 설계)
작업 전 반드시 현재 설계 상태를 파악합니다:
- `docs/02.design/db.md`가 존재하면 → 읽고 요구사항 대비 누락된 테이블·컬럼만 추가
- 기존 테이블 설계가 요구사항과 일치하면 → 건너뜀
- 기존 설계를 변경해야 하는 경우 → 변경 내용과 영향받는 구현 파일을 **구현 영향도** 섹션에 기록
기존 설계 전체 삭제·재작성 금지

## Step 0 — REQ ↔ ASIS 충돌 사전 감지

`docs/01.analyze/reviewed/asis.md`가 존재하면 설계 시작 전 아래를 확인합니다.

1. `requirements.md`와 `asis.md`를 교차 읽기
2. 동일 대상(테이블/컬럼/정책)에 대해 상충되는 내용 발견 시 **즉시 중단**하고 사용자에게 보고:

```
[REQ ↔ ASIS 충돌 감지]
- 대상: (충돌 항목명)
- requirements.md: (내용)
- asis.md: (내용)
→ 어느 쪽을 기준으로 설계할지 결정해 주세요.
```

3. 사용자 결정을 받은 후 설계 진행

`asis.md`가 없으면 이 단계를 Skip하고 바로 설계를 시작합니다.

---

## 프로세스
1. 요구사항에서 핵심 엔티티 추출
2. 엔티티 간 관계 정의 (1:1, 1:N, N:M)
3. 각 테이블 컬럼 및 타입 정의 (공통 컬럼 포함)
4. PK / FK / Index 설계
5. 프로젝트 기술 스택에 맞는 DDL 또는 ORM 스키마 작성 (orm 스킬 참조)

---

## 출력
`docs/02.design/db.md` 파일을 생성합니다:

```
# DB 설계

## 엔티티 관계
users ||--o{ orders : "주문"
orders ||--|{ order_items : "포함"
...

## 테이블 정의

### users
| 컬럼 | 타입 | 제약 | 설명 |
|------|------|------|------|
| id | UUID | PK | |
| email | VARCHAR(255) | UNIQUE, NOT NULL | |
| first_name | VARCHAR(100) | NOT NULL | |
| created_at | TIMESTAMP | NOT NULL DEFAULT now() | |
| updated_at | TIMESTAMP | NOT NULL DEFAULT now() | |
| deleted_at | TIMESTAMP | NULL | soft delete |

### orders
...

## 인덱스 전략
- idx_users_email : 로그인 조회용
- idx_orders_user_id : 사용자별 주문 조회용

## 설계 결정 사항
- (정규화 수준, 트레이드오프, soft delete 예외 테이블 등 근거 명시)

## 구현 영향도
기존 구현 중 이번 설계 변경으로 영향받는 파일 목록:
| 파일 | 변경 이유 |
|------|----------|
| (없으면 "없음") | |
```

---
`docs/01.analyze/reviewed/requirements.md` 를 기반으로 DB 설계를 시작합니다. `docs/01.analyze/reviewed/gap.md` 가 존재하면 변경 범위 우선순위 결정에 함께 참조합니다 (신규 프로젝트는 requirements.md 만으로 진행).

---

## 리뷰 보완(Refinement) 모드 (옵션)
만약 사용자가 `docs/02.design/design-review-report.md` 파일을 제공하거나 리뷰 보완을 지시한 경우:
1. **전체 재작성 금지**: 기존 `db.md` 문서를 처음부터 끝까지 다시 쓰지 마세요.
2. **문제 식별**: 리뷰 보고서의 "문제 목록" 및 "분석 보완 사항" 중 DB 설계와 관련된 항목만 타겟팅합니다.
3. **부분 수정(Patch)**: 기존 문서에서 지적된 엔티티, 컬럼, 관계 등만 정밀하게 수정하여 문서를 보완합니다.

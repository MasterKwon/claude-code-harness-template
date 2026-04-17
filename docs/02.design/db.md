# DB 설계

> 이 파일은 `/design-db` 실행 시 자동 생성됩니다.
> `reviewed/db.md` 로 복사 후 검토·승인하세요.

---

## 엔티티 관계

```
users ||--o{ login_histories : "로그인 이력"
users ||--o{ orders : "주문"
orders ||--|{ order_items : "주문 항목"
order_items }o--|| products : "상품"
```

---

## 테이블 정의

### users

| 컬럼 | 타입 | 제약 | 설명 |
|------|------|------|------|
| id | UUID | PK, DEFAULT gen_random_uuid() | |
| email | VARCHAR(255) | UNIQUE, NOT NULL | 로그인 이메일 |
| password_hash | VARCHAR(255) | NOT NULL | bcrypt 해시 |
| name | VARCHAR(100) | NOT NULL | 표시 이름 |
| created_at | TIMESTAMP | NOT NULL, DEFAULT now() | |
| updated_at | TIMESTAMP | NOT NULL, DEFAULT now() | |
| deleted_at | TIMESTAMP | NULL | soft delete |

### login_histories

| 컬럼 | 타입 | 제약 | 설명 |
|------|------|------|------|
| id | UUID | PK | |
| user_id | UUID | FK → users.id, NOT NULL | |
| ip_address | VARCHAR(45) | | IPv4/IPv6 |
| logged_in_at | TIMESTAMP | NOT NULL, DEFAULT now() | |

### orders

| 컬럼 | 타입 | 제약 | 설명 |
|------|------|------|------|
| id | UUID | PK | |
| user_id | UUID | FK → users.id, NOT NULL | |
| status | VARCHAR(20) | NOT NULL, DEFAULT 'pending' | pending/paid/cancelled |
| total_amount | DECIMAL(12,2) | NOT NULL | |
| created_at | TIMESTAMP | NOT NULL, DEFAULT now() | |
| updated_at | TIMESTAMP | NOT NULL, DEFAULT now() | |
| deleted_at | TIMESTAMP | NULL | soft delete |

---

## 인덱스 전략

| 인덱스명 | 테이블.컬럼 | 목적 |
|---------|------------|------|
| idx_users_email | users.email | 로그인 조회 |
| idx_login_histories_user_id | login_histories.user_id | 사용자별 이력 조회 |
| idx_orders_user_id | orders.user_id | 사용자별 주문 조회 |
| idx_orders_status | orders.status | 상태별 주문 조회 |

---

## 설계 결정 사항

- **PK**: UUID 사용 — 분산 환경(MSA)에서 서비스 간 충돌 방지
- **Soft Delete**: 모든 비즈니스 테이블에 `deleted_at` 적용, `login_histories`는 이력 특성상 hard delete도 허용
- **정규화**: 3NF 유지. `order_items`의 단가는 주문 시점 가격 스냅샷으로 별도 저장

# Harness Engineering — 변경 이력

---

## v2.0.0 — 2026-05-17

### 추가
- **파이프라인 3개 체계 확립**
  - `pipeline-full`: 신규 프로젝트 전체 SDLC
  - `pipeline-change`: 기존 프로젝트 기능 추가·변경
  - `pipeline-maintenance`: 운영 유지보수 (고객 변경 요청 처리)
- **신규 커맨드 (9개)**
  - `customer-request`: 고객 변경 요청 분류 및 처리
  - `deploy-dev`: Dev 서버 배포
  - `design-tc`: UAT 체크리스트 설계
  - `impact-check`: 변경 영향도 검사
  - `maintenance-init`: 유지보수 모드 초기화
  - `pipeline-maintenance`: 유지보수 파이프라인
  - `review-analyze`: 분석 산출물 리뷰
  - `review-design`: 설계 산출물 리뷰
  - `refine-impact-check`: 영향도 검사 보완
- **설계 리뷰 단계** 추가 (Phase 2.5 / 4.5)
- **UAT 체크리스트 설계 단계** 추가 (Phase 2.7)
- **구현 영향도 검사 단계** 추가 (Phase 3.5 / 5.5)
- **롤백 맵** 전면 작성 (각 파이프라인 내)
- **요구사항 변경 시나리오** 작성
- **docs/harness/** 디렉토리 신규 생성
  - `checklist.md`: 작업 체크리스트
  - `onboarding.md`: 온보딩 가이드 + 범용 레이어 문서
  - `CLAUDE.md.template`: 신규 프로젝트용 빈 템플릿
  - `presentation.md`: 발표 자료
  - `CHANGELOG.md`: 변경 이력 (이 파일)

### 변경
- 배포 흐름 재정립: `AI QA(Local) → Dev 배포 → UAT(Dev 환경) → 운영 배포`
- `pipeline-full` Phase 번호 재정렬 (7개 Phase로 확장)
- `pipeline-change` Phase 번호 재정렬 (9개 Phase로 확장)
- 각 파이프라인에 `deploy-dev` 단계 명시적 포함

### 보완 (V1~V13 취약점 수정)
- 분석 품질 게이트 강화
- 설계 산출물 리뷰 누락 보완
- 구현 후 레이어 간 정합성 검증 누락 보완
- 유지보수 파이프라인 부재 보완
- 고객 변경 요청 처리 체계 부재 보완

---

## v1.0.0 — 2025 (이전 버전)

- 기본 파이프라인 2개 체계: pipeline-full / pipeline-change
- 커맨드 40개 수준
- 01.WebDesktop 프로젝트에 최초 적용 및 검증

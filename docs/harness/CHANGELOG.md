# Harness Engineering — 변경 이력

---

## v2.3.0 — 2026-05-18

### 추가
- **교육자료 3부작 장표** (`docs/harness/`)
  - `presentation-intro.html`: 1부 — 체험형 실습 30분 (파이프라인 데모 중심)
  - `presentation-intro2.html`: 2부 — 나만의 스킬 만들기 워크샵 30분
  - `presentation-intro3.html`: 3부 — 심화 (파이프라인 전체·품질 게이트·롤백 맵·커맨드 체계)
- **스킬 구조 자동 점검 훅** (`.claude/hooks/skill-structure-check.sh`)
  - `.claude/skills/*.md` 파일 Edit/Write 시 `PostToolUse`로 자동 실행
  - 권장 모델 · 역할 정의 · 프로세스 섹션 3항목 bash 기반 점검
  - `stacks/` 하위 파일 제외, 작업 차단 없이 경고만 출력

### 변경
- `onboarding.md` 현행화
  - 커맨드 수 48 → 52개로 정정
  - 누락 커맨드 추가: `grill-me`, `design-prompt-gen`, `test-ui-chrome`, `skill-formatter`
  - `refine-impact-check` 배포·운영 → 리뷰 섹션으로 이동
  - `harness/` 디렉터리 구조에 3부작 발표자료 반영
  - 유틸 카테고리 신설 (`skill-formatter`)
- `README.md` 발표자료 섹션 표 형식으로 정비 (3부작 링크 추가)

### 삭제
- `docs/harness/checklist.md` — 내부 개발 작업 로그, 외부 공유 불필요

---

## v2.2.0 — 2026-05-18

### 추가
- **Bridge 패턴 정착 — AI 산출물을 사람 작업과 잇는 3개 신규 커맨드**
  - `grill-me`: 집중 인터뷰 (원형: [mattpocock/skills](https://github.com/mattpocock/skills), 한국어/백엔드 관점으로 커스터마이징)
    - 산출물: `docs/00.input/grill-result.md`
    - 위치: `pipeline-full` Phase 0.5 (선택), `pipeline-maintenance` Phase 1.5 (선택)
  - `design-prompt-gen`: Claude Design 입력용 화면별 프롬프트 생성
    - 산출물: `docs/02.design/design-prompts.md` (화면별 섹션)
    - 위치: `pipeline-full` Phase 1.7 (선택), `pipeline-maintenance` Phase 5.0 (Screen 변경 시)
  - `test-ui-chrome`: UAT 체크리스트 → Chrome 사이드패널 지시문 + xlsx 체크리스트 변환
    - 산출물: `docs/05.test/ui-test-chrome.md` + `.xlsx` (AI), `_result.xlsx` (QA 수동 추가)
    - 위치: `test-all` Step 5, `pipeline-maintenance` Phase 8 (Screen 변경 시)

### 변경
- `pipeline-full.md` 상단 다이어그램에 grill-me / design-prompt-gen / test-ui-chrome 반영
- `test-all.md` Step 5 추가 (Chrome 지시문 생성 Bridge)

### 보완 (V14~V16 취약점)
- **V14** 요구사항 모호성 사전 제거 부재 → `grill-me` 추가
- **V15** UI 설계 시 시각적 목업 부재 → `design-prompt-gen` 추가
- **V16** 화면 수동 검증 표준화 부재 → `test-ui-chrome` 추가 (AI 자동 테스트와 사람 검증의 이중 확인 구조)

### 설계 결정
- **회차 폴더 도입 거부**: 기존 하네스의 "단일 파일 + git history" 패턴 유지. 회차 추적은 git 책임.
- **Bridge 단계 명시**: AI 자동(Auto) / 사람용 산출물(Bridge) / 사람 수행(Human) 세 단계 구분을 파이프라인 문서에 명문화.

---

## v2.1.0 — 2026-05-17

### 변경
- **파이프라인 2개 체계로 통합**
  - `pipeline-change` 삭제 — `pipeline-maintenance`에 흡수
  - `pipeline-maintenance`: 오류수정 / 기능개선 / 내부 개선 모두 처리
  - 변경 이유(WHY) 정의를 Phase 1로 명시화 (AS-IS 분석 전 선행)
  - 내부 주도 / 외부 요청 구분 제거 — 변경 유형으로 대체

---

## v2.0.0 — 2026-05-17

### 추가
- **파이프라인 3개 체계 확립**
  - `pipeline-full`: 신규 프로젝트 전체 SDLC
  - `pipeline-change`: 기존 프로젝트 기능 추가·변경 *(v2.1.0에서 maintenance로 통합)*
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

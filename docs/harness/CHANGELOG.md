# Harness Engineering — 변경 이력

---

## v2.4.3 — 2026-05-19

### 수정 — 분석 단계 `reviewed/` 의미 통일 + 자동 무효화 안전망

교육 실습 중 발견: `reviewed/` 에 자동 품질 게이트만 통과한 파일이 들어가, 리뷰 미통과 상태에서 다음 단계가 읽는 안전망 누락.

**원칙 재정의**: `reviewed/` = **`review-analyze` PASS 한 파일만** (자동 품질 게이트는 별도 단계). 폴더에 파일이 있다 = 리뷰 통과 100% 보장.

- **`analyze-*` 스킬 사전 동작(자동 무효화) 추가** — 실행 시작 시 `reviewed/` 의 해당 파일과 의존 파일을 즉시 삭제 (이전 PASS 무효화)
  - `analyze-requirements`: `reviewed/requirements.md`, `reviewed/gap.md` 삭제
  - `analyze-asis`: `reviewed/asis.md`, `reviewed/gap.md` 삭제
  - `analyze-gap`: `reviewed/gap.md` 삭제
- **입력 경로 변경 (원본 위치로)**
  - `analyze-gap` 입력: `reviewed/{req, asis}.md` → `docs/01.analyze/{req, asis}.md`
  - `review-analyze` 입력: `reviewed/*.md` → `docs/01.analyze/*.md`
- **`review-analyze` PASS 시 자동 동작 추가** — 세 파일을 `reviewed/` 로 일괄 복사 (안전망 핵심)
- **파이프라인에서 reviewed/ 복사 트리거 제거**
  - `analyze-all.md` Step 4 신설 — review-analyze 필수 호출
  - `pipeline-full.md` Phase 1 — review-analyze 필수 Step 명시
  - `pipeline-maintenance.md` Phase 2/3/4 — reviewed/ 복사 제거 + Phase 4.5 (review-analyze) 신설

### 안전망 효과

- 다음 단계(design-*) 는 `reviewed/` 만 읽으면 자동 안전 보장
- `analyze-*` 재실행 시 자동 무효화로 stale 위험 없음
- `reviewed/` 비어 있으면 다음 단계 진입 불가 → 사용자가 깜빡할 수 없는 구조

### 알려진 미보완 (다음 단계 보완 예정)

- 설계 단계: `design-*` → `reviewed/` 복사 단계 (review-design PASS 후)
- 테스트 단계: review-* 가 없는 단계의 `reviewed/` 처리 — v2.4.2 에서 추가한 자동 복사 단계 재검토 필요

---

## v2.4.2 — 2026-05-19

### 수정 — 파이프라인 경로 일관성 보완

교육 실습 중 발견된 스킬·커맨드 간 산출물 경로 불일치 4건 보완.

- **테스트 보고서 reviewed/ 복사 단계 명시** (High)
  - `pipeline-full.md` Phase 5, `pipeline-maintenance.md` Phase 8: 테스트 완료 후 `docs/05.test/report-*.md` → `docs/05.test/reviewed/report-*.md` 복사 단계 추가
  - 이전엔 복사 단계 미명시 상태로 `cross-check-test`와 `deploy-prd`가 `reviewed/` 경로를 가정하고 있어 실행 불가 가능성 존재
- **`review-analyze.md` 입력 경로 확장** (High, 사용자 실습 중 발견)
  - 기존: `docs/00.input/grill-result.md` 단일 인용
  - 변경: 신규 개발(`grill-result.md`)·운영 변경(`grill-task-*.md`)·사용자 원본 자료 모두 처리 가능하도록 명시
- **`analyze-requirements.md` grill 산출물 자동 활용 명시** (Medium)
  - Step 0 입력 전처리 안내에 grill-result/grill-task 자동 반영 한 줄 추가
- **`pipeline-maintenance.md` Phase 5.7 신설 — UAT 체크리스트 갱신** (Medium)
  - Screen 신규/변경 항목이 있으면 `design-tc` 호출, 없으면 기존 `uat-checklist.md` 재사용
  - 이전엔 `design-tc` 호출 위치가 maintenance에 누락되어 deploy-dev 단계의 QA 전달 항목이 불명확

---

## v2.4.1 — 2026-05-18

### 추가
- **교육자료 2부에 슬라이드 2장 추가** (`docs/harness/presentation-intro2.html`, 11 → 13 슬라이드)
  - **"스킬이 꼭 필요한가?"** — AI 만으로도 잘하는데 굳이 스킬을 만드는 이유 (재현성·표준화·자산화·검증된 패턴·컨텍스트 절약). "스킬은 어떻게 태어나는가" 직전에 위치
  - **"만들기 전에 검색 — 이미 누가 만들었을 수 있다"** — 공개 스킬 검색·설치 안내. 어디서 찾나(`anthropics/skills` 공식 + `ComposioHQ/awesome-claude-skills`, `VoltAgent/awesome-agent-skills` 1000+, 마켓플레이스), 어떻게 설치하나(`/plugin` 시스템 vs 수동 `~/.claude/skills/`), 보안 주의. "팀 스킬 라이브러리" 직후에 위치

### 변경
- 카운터 `1 / 11` → `1 / 13`

---

## v2.4.0 — 2026-05-18

### 추가
- **CONTEXT 누적 구조 도입** — 운영 시스템 도메인 노트(`docs/context/`) + 동적 Phase 흐름 (Knowledge Accretion)
  - `/grill-task` 신설 — 작업 단위 인터뷰. CONTEXT 우선 참조 후 모르는 것만 인터뷰, 권장 Phase 흐름 contract 제안
    - 산출물: `docs/00.input/grill-task-{YYYYMMDD}-{slug}.md`
    - CONTEXT 충실도 판정(풍부/보통/희박)에 따라 Phase 흐름 자동 가감
  - `/maintenance-init` Step 3.5 추가 — 도메인 1차 분류(메뉴 + 코드 모듈 후보 둘 다 제시) + `docs/context/INDEX.md` + 도메인별 빈 스켈레톤 자동 생성
  - 도메인 노트 스키마 6섹션: 개요 · 코드 위치 · 외부 의존성 · 함정/주의사항 · 결정 이력 · 변경 패턴
- **`/pipeline-maintenance` 동적 흐름화**
  - Phase 1.5: 진입점을 `/grill-me`에서 `/grill-task`로 교체 (모든 변경 작업의 기본 진입점)
  - Phase 1.6 신설 — grill-task 권장 흐름을 사용자가 확정 (이번 작업의 진행 contract)
  - Phase 6.5 자동 강등 — impact-check High 영향도 발견 시 contract 에 ⏭ 표시됐던 Phase 자동 복원
  - Phase 11 반자동 갱신 — Claude가 갱신 후보 추출 → 사용자 체크박스 선별 → 도메인 노트 append + INDEX 최근 갱신일 자동 업데이트
- **안전망 Phase 7건** (절대 생략 불가) 명시 — 6.5 / 7 / 8 변경+회귀High / 8.5 / 9 / 10 / 11
- **`/pipeline-full` 운영 전환 단계** — Phase 7 운영 배포 후 `/maintenance-init` 진입 경로 안내 추가
- **`CLAUDE.md`** — 자연어 트리거(`grill-task`) + Knowledge Accretion 원칙(5번째 핵심 원칙) 추가
- **교육자료 4부** (`docs/harness/presentation-intro4.html`) — 운영 단계 · Knowledge Accretion (9 슬라이드, 약 10분)
  - 신입 vs 1년 차 학습 곡선 비유
  - 사용 예시: `work-management` 도메인의 "재택근무 유형 추가"(첫 작업, CONTEXT 희박) vs "교대근무 유형 추가"(한 달 후, CONTEXT 풍부) 대조

### 변경
- 1~3부 마무리 슬라이드 배지에 4부 링크 추가
- 4부 슬라이드 2: 부 번호 의존 제거 — "3부에서 본" → "지금의" 로 표현 변경 (단독 시청자도 이해 가능하도록)
- `README.md` 발표자료 표에 4부 항목 추가 + 디렉토리 구조에 반영

### 설계 결정
- **CONTEXT 위치**: `docs/context/` (별도 최상위) — 0X.* 폴더는 1회성 작업 산출물, context는 누적 자산이라 격이 다름
- **다중 파일 + INDEX**: 작업 도메인만 선택 로드 가능 → 토큰 절약. 충돌 위험 적음
- **동적 권장 (Claude 제안 → 사용자 confirm)**: 사전 정의된 "트랙×Phase 매트릭스" 폐기 — 사람의 실제 학습 곡선과 일치
- **갱신 시점은 배포 후**: 롤백 시 노트 오염 방지

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

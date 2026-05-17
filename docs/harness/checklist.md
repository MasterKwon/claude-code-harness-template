# Harness Engineering — 작업 체크리스트

## Phase 1~3 (완료)

- [x] V1~V13 취약점 전부 보완
- [x] 신규 커맨드 추가: customer-request, deploy-dev, design-tc, impact-check, maintenance-init, pipeline-maintenance, review-analyze, review-design
- [x] 배포 흐름 재정립: AI QA(Local) → Dev 배포 → UAT(Dev 환경) → 운영 배포
- [x] 파이프라인 2개 체계 확립: pipeline-full / pipeline-maintenance (change 통합)
- [x] 설계 리뷰 단계 추가 (Phase 2.5, 4.5)
- [x] UAT 체크리스트 설계 단계 추가 (Phase 2.7)
- [x] 구현 영향도 검사 단계 추가 (Phase 3.5, 5.5)
- [x] 롤백 맵 전면 작성 (각 파이프라인)
- [x] 요구사항 변경 시나리오 작성

---

## Phase 4 — 범용 레이어 공식화

- [x] 범용 레이어 파일 목록 확정
- [x] stacks/ 교체 가이드 작성 → `docs/harness/onboarding.md` 작성
- [x] CLAUDE.md 템플릿 작성 (신규 프로젝트용 빈 템플릿) → `docs/harness/CLAUDE.md.template`

---

## Phase 5 — 프레젠테이션 문서

- [x] `docs/harness/presentation.md` 전면 작성 (파이프라인 3개, 커맨드 49개 반영)
- [x] CHANGELOG.md 작성

---

## 범용 레이어 파일 목록 (Phase 4 확정)

### 공통 레이어 — 모든 프로젝트에서 그대로 사용

```
.claude/
├── commands/          # 슬래시 커맨드 진입점 (49개) ← 수정 불필요
├── skills/            # 단계별 실행 로직
│   ├── analyze-*.md   # 분석 스킬
│   ├── build-*.md     # 구현 스킬
│   ├── design-*.md    # 설계 스킬
│   ├── test-*.md      # 테스트 스킬
│   ├── review-*.md    # 리뷰 스킬
│   ├── customer-request.md
│   ├── deliverable-analyze.md
│   ├── deliverable-design.md
│   ├── deploy-dev.md
│   ├── impact-check.md
│   ├── maintenance-init.md
│   ├── project-setup.md
│   └── ship.md
├── agents/            # 서브에이전트 정의
│   ├── code-reviewer.yml
│   ├── security-auditor.yml
│   └── test-writer.yml
└── hooks/
    └── post-edit.sh   # TypeScript 타입 체크 자동화
```

### 프로젝트별 커스터마이징 대상

```
CLAUDE.md                          # 프로젝트 컨텍스트 — 반드시 수정
.claude/settings.json              # 훅·권한 설정 — 필요 시 수정
.claude/skills/stacks/             # 기술스택 파일 — 선택한 스택만 활성화
    arch/    [msa | monolith]
    orm/     [prisma | typeorm | mongoose | raw-sql]
    api-style/ [rest | trpc | graphql]
    state/   [tanstack-query | zustand | redux]
    framework/ [nextjs]
    ui/      [shadcn | mui | antd | tailwind-only]
```

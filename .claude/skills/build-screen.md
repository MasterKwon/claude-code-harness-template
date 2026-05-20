> 권장 모델: balanced

당신은 **프론트엔드 개발자** 역할입니다. 화면 설계서를 기반으로 UI를 구현합니다.

## 사전 동작 — 이전 리뷰 통과 사본 무효화 (필수)

이 스킬은 화면 코드를 새로 생성/갱신하므로, **실행 시작 시 다음 파일이 존재하면 즉시 삭제**합니다:
- `docs/03.build/impact-check.md` (구현 변경 → 영향도 재분석 필요)
- `docs/04.review/reviewed/report.md` (코드 변경 → 리뷰 재실행 필요)

이전 `review-all` 통과 사본은 더 이상 유효하지 않습니다.

## 사전 동작 — grill-decisions 반영 (선택)

`docs/03.build/grill-decisions.md` 가 존재하면 먼저 읽고, 누적된 인터뷰 결정 사항을 본 작업에 반영합니다.
구현 중 `/grill-me` 호출로 추가된 의사결정을 누락 없이 반영하기 위함입니다.

## 역할 원칙
- `docs/02.design/reviewed/screen.md` 기반으로 작업
- 설계서에 없는 기능은 임의로 추가하지 않음
- 프로젝트 CLAUDE.md의 기술 스택 및 컨벤션을 따름

## 참조 스킬
`CLAUDE.md`의 `## Active Skills` 섹션을 읽고 해당 파일들을 순서대로 참조합니다.

```
framework: CLAUDE.md에 명시된 경로 읽기  (서버/클라이언트 컴포넌트 패턴, middleware, layout, Swagger UI 페이지)
arch:       CLAUDE.md에 명시된 경로 읽기  (컴포넌트 레이어 규칙, 비즈니스 로직 금지 영역)
state:      CLAUDE.md에 명시된 경로 읽기  (서버/클라이언트 상태 관리 패턴)
ui:         CLAUDE.md에 명시된 경로 읽기  (컴포넌트 사용법, 클래스 규칙, 폼 패턴)
```

Active Skills가 없거나 비어 있으면 기본값 사용:
- framework: `.claude/skills/stacks/framework/nextjs.md`
- arch: `.claude/skills/stacks/arch/msa.md`
- state: `.claude/skills/stacks/state/tanstack-query.md`
- ui: `.claude/skills/stacks/ui/shadcn.md`

## 기존 구현 확인 (증분 빌드)
작업 전 반드시 현재 구현 상태를 파악합니다:
- 컴포넌트·페이지 파일이 존재하면 → 읽고 설계서 대비 누락된 UI·기능만 추가
- 기존 컴포넌트가 설계서와 일치하면 → 건너뜀
- 기존 컴포넌트가 설계서와 다르면 → 해당 부분만 수정 (파일 전체 재작성 금지)

## 프로세스
1. `docs/02.design/reviewed/screen.md` 읽기
2. 프로젝트 구조 파악 (기존 컴포넌트, 라우팅 방식)
3. 공통 컴포넌트 먼저 구현
4. 페이지 단위로 구현 (흐름 순서대로)
5. `docs/02.design/reviewed/api.md`의 API 호출 연결

## Next.js 기준 작업 순서
1. `app/` 디렉토리에 페이지 파일 생성
2. `components/` 에 재사용 컴포넌트 생성
3. API 호출은 Server Component 또는 Client Component 적절히 구분
4. Tailwind CSS로 스타일링

## 구현 시 확인사항
- [ ] 설계서의 모든 페이지 구현 여부
- [ ] 페이지 간 이동(Link/router) 연결
- [ ] API 호출 연결 (`docs/02.design/reviewed/api.md` 참조)
- [ ] 로딩/에러 상태 처리

---
`docs/02.design/reviewed/screen.md`를 읽고 구현을 시작합니다. 구현할 페이지 범위를 지정해 주세요 (전체 또는 특정 페이지).

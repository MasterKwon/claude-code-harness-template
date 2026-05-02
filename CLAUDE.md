# Claude Code — Project Context

## Project
Next.js + MSA 구조 학습 프로젝트. 바이브코딩으로 React/Next.js를 처음 경험하는 백엔드 20년차 개발자의 실험 공간.

## Environment
- Platform: macOS (darwin)
- Shell: zsh (Unix syntax)
- Working directory: /Users/masterkwon/workspace/00.Dev/Claude_Projects/00.claude_templet

## Tech Stack
- Frontend: Next.js (App Router), TypeScript, Tailwind CSS
- Architecture: MSA (Microservices)
- Package Manager: npm

## Active Skills
- framework: .claude/skills/stacks/framework/nextjs.md
- arch:      .claude/skills/stacks/arch/msa.md
- orm:       .claude/skills/stacks/orm/prisma.md
- api-style: .claude/skills/stacks/api-style/rest.md
- state:     .claude/skills/stacks/state/tanstack-query.md
- ui:        .claude/skills/stacks/ui/shadcn.md

## Guidelines
- 모든 응답은 한국어로
- 코드 설명은 백엔드 개발자 관점에서 (프론트 개념은 백엔드에 빗대어 설명)
- 단순하고 명확한 코드 우선 — 불필요한 추상화 금지
- 새 파일 생성보다 기존 파일 수정 우선
- 응답 마지막에 요약 추가 금지

## 핵심 엔지니어링 원칙 (by Karpathy & Hashimoto)

> 본 가이드는 모든 세션의 최상위 지침이다. 작업 중 위 원칙에 위배되는 상황이 발생하면 즉시 보고하고 수정을 제안하라.

### Surgical Changes (수술적 변경)
요청받은 범위 외의 주변 코드를 불필요하게 리팩토링하거나 건드리지 마라. 변경은 정교하고 최소한이어야 한다.

### Harness Engineering (하네스 엔지니어링)
실수가 발생하면 사과하는 대신, 다시는 같은 실수가 반복되지 않도록 CLAUDE.md나 지침 파일을 즉시 업데이트하여 환경을 개선하라.

### Simplicity First
불필요한 추상화나 과한 설계를 지양하고, 현재 문제를 해결하는 가장 단순하고 명확한 코드를 작성하라.

### Think Before Coding
코드를 작성하기 전, 반드시 가설과 실행 계획을 먼저 수립하고 확인받아라.

## 도구 및 컨텍스트 관리 (Token Diet)

- **Serena MCP 우선 활용**: 코드 검색 시 grep 대신 Serena MCP를 사용하여 의미 기반 검색을 수행함으로써 탐색 토큰을 절약하라.
- **Hookiefy 기반 실수 차단**: 반복되는 패턴이나 프로젝트 제약 사항은 Hookiefy 스킬로 등록하여 작업 전 항상 체크하라.
- **컨텍스트 최적화**:
  - 대화가 길어지면 `/compact`를 통해 문맥을 요약하라.
  - 작업 단위가 종료되면 `/clear`로 세션을 초기화하라.
  - 단순 반복 작업(테스트, 로그 분석)은 `/agents`를 통해 Haiku 모델에게 위임하라.

## 작업 워크플로우

- **Plan Mode**: 복잡한 구현 전 Shift+Tab 또는 "Plan" 접두어를 사용하여 계획을 브리핑할 것.
- **Surgical Edit**: 답변이 만족스럽지 않을 경우 새로운 질문을 던지는 대신, 이전 프롬프트를 수정(Edit)하여 재생성할 것.
- **Self-Correction**: 작업 완료 후 스스로 Claude MD Improver를 참고하여 현재 규칙이 효율적인지 자가 진단할 것.

## 작업 전후 체크 원칙

모든 작업 요청에 대해 실행 전 반드시 아래 두 가지를 사용자에게 먼저 알린다.

### 사전 체크 (작업 시작 전)
- 이 작업이 영향을 주는 파일/단계는 무엇인가
- 먼저 확인하거나 결정해야 할 사항이 있는가
- 누락되거나 빠뜨릴 수 있는 연관 작업이 있는가

### 사후 영향도 (작업 완료 후 파급 범위)
- 이 변경으로 인해 수정이 필요한 다른 파일은 무엇인가
- README.md / CLAUDE.md 업데이트가 필요한가
- git 커밋/푸시가 필요한가
- 다음 단계에서 주의해야 할 사항이 있는가

> 사용자가 "바로 해줘" 또는 "만들어줘"라고 해도 이 체크를 생략하지 않는다.

## Architecture
- 서비스는 독립적으로 분리 (각자 독립 실행 가능)
- 서비스 간 통신은 REST API 또는 Message Queue
- 각 서비스는 자체 포트로 실행

## Context Management
- 0~60%: 정상 작업
- 60~70%: 컨텍스트 모니터링 시작
- 70~80%: `/compact` 실행 권장
- 80%+: `/clear` 필수 (이 임계값에서 반드시 사용자에게 알릴 것)

## Security
- 코드 또는 로그에 시크릿(API 키, 비밀번호) 절대 포함 금지
- 모든 사용자 입력값 검증
- DB 쿼리는 파라미터화된 쿼리만 사용 (Raw string 금지)
- `.env` 파일은 절대 커밋하지 않음
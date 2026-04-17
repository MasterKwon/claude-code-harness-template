# Claude Code — Project Context

## Project
Next.js + MSA 구조 학습 프로젝트. 바이브코딩으로 React/Next.js를 처음 경험하는 백엔드 20년차 개발자의 실험 공간.

## Environment
- Platform: {{PLATFORM}}
- Shell: bash (Unix syntax)
- Working directory: {{WORKING_DIRECTORY}}

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

## Guidelines
- 모든 응답은 한국어로
- 코드 설명은 백엔드 개발자 관점에서 (프론트 개념은 백엔드에 빗대어 설명)
- 단순하고 명확한 코드 우선 — 불필요한 추상화 금지
- 새 파일 생성보다 기존 파일 수정 우선
- 응답 마지막에 요약 추가 금지

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
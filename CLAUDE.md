# Claude Code — Project Context

## Project
Next.js + MSA 구조 학습 프로젝트. 바이브코딩으로 React/Next.js를 처음 경험하는 백엔드 20년차 개발자의 실험 공간.

## Environment
- Platform: Windows 11
- Shell: bash (Unix syntax)
- Working directory: C:\WorkSpace\00.Dev\Claude_Projects\01.FirstProjects

## Tech Stack
- Frontend: Next.js (App Router), TypeScript, Tailwind CSS
- Architecture: MSA (Microservices)
- Package Manager: npm

## Guidelines
- 모든 응답은 한국어로
- 코드 설명은 백엔드 개발자 관점에서 (프론트 개념은 백엔드에 빗대어 설명)
- 단순하고 명확한 코드 우선 — 불필요한 추상화 금지
- 새 파일 생성보다 기존 파일 수정 우선
- 응답 마지막에 요약 추가 금지

## Architecture
- 서비스는 독립적으로 분리 (각자 독립 실행 가능)
- 서비스 간 통신은 REST API 또는 Message Queue
- 각 서비스는 자체 포트로 실행
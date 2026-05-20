# Pipeline Full — 한눈 가이드

> `pipeline-full` (신규 개발) 전체 흐름. Step 단위로 호출 명령·입출력·필수 여부·안전망까지 한 표로 정리.
> 교육·실습 시 옆에 두고 진행하면 한 단계도 빠뜨리지 않습니다.

---

## 범례

- **필수 여부**: 🟢 안전망 (절대 생략 불가) · 🔵 필수 · ⚪ 선택/조건부
- **모델**: `fast` = haiku · `balanced` = sonnet · `best` = opus
- **안전망 / 무효화** 컬럼: 재실행 시 `reviewed/` 의 어떤 파일이 자동 삭제되는가 + 다음 단계 진입 조건

---

## 단계 전환 안전망 흐름도

각 큰 단계(분석/설계/구현/테스트) 사이마다 **리뷰 스킬이 안전망**으로 들어갑니다. PASS 한 시점의 사본만 `reviewed/` 로 들어가고, 다음 단계는 `reviewed/` 만 읽으면 안전이 자동 보장됩니다.

```
[Phase 0~0.5]  준비
                  ↓
[Phase 1.1~1.7] 분석 (requirements / asis / gap)
                  ↓
              🟢 review-analyze  ← PASS 시 reviewed/ 복사
                  ↓
[Phase 2.1~2.5] 설계 (process / screen / db / api / integration)
                  ↓
              🟢 review-design  ← PASS 시 reviewed/ 복사 + cross-check + deliverable 자동 연쇄
                  ↓
[Phase 2.7]    UAT 체크리스트 (design-tc)
                  ↓
[Phase 3.1~3.3] 구현 (build-db / build-api / build-screen)
                  ↓
              🟢 impact-check  ← 변경 영향도 검사
                  ↓
              🟢 review-all  ← PASS 시 docs/04.review/reviewed/report.md 복사
                  ↓
[Phase 5.1~5.4] AI 테스트 (db / api / screen / e2e)
                  ↓
[Phase 5.5]    Chrome UI 지시문 (선택)
                  ↓
              🟢 cross-check-test  ← 4개 보고서 reviewed/ 일괄 복사
                  ↓
[Phase 5.7]    🟢 Dev 배포
                  ↓
[Phase 6]      🟢 UAT (사람)
                  ↓
[Phase 7]      🟢 운영 배포
```

> 안전망이 깨지면 다음 단계가 진입을 거부합니다 (reviewed/ 가 비어 있어 입력이 없음).
> 원본 산출물 변경 시 reviewed/ 의 의존 파일이 자동 삭제되므로 리뷰를 다시 받아야 합니다.

---

## 전체 흐름

| # | Phase | 단계 | 호출 명령 | 입력 | 출력 | 필수 | 모델 | 안전망 / 무효화 |
|---|------|------|----------|------|------|------|------|---------|
| 0 | 0 | 프로젝트 초기화 | `/project-setup` | 사용자 선택 (9가지 스택) | `CLAUDE.md` · `package.json` · 환경설정 | 🔵 필수 (1회) | balanced | — |
| 1 | 0.5 | 집중 인터뷰 | `/grill-me` | 사용자 머릿속 요구사항 | `docs/00.input/grill-result.md` | ⚪ 선택 (권장) | best | — |
| 2 | 1.1 | 요구사항 분석 | `/analyze-requirements` | `docs/00.input/` 입력 자료 (grill 결과 포함) | `docs/01.analyze/requirements.md` (원본) | 🔵 필수 | balanced | 재실행 시 `reviewed/{req, gap}.md` 자동 삭제 |
| 3 | 1.2 | AS-IS 분석 | `/analyze-asis` | 기존 코드베이스 (CLAUDE.md, src/) | `docs/01.analyze/asis.md` (원본) | ⚪ 조건부 | fast | **신규 개발 시 사실상 N/A** (기존 시스템 없음). 운영 시스템 도입·마이그레이션 시에만 의미. 재실행 시 `reviewed/{asis, gap}.md` 자동 삭제 |
| 4 | 1.3 | GAP 분석 | `/analyze-gap` | `docs/01.analyze/{requirements, asis}.md` (원본) | `docs/01.analyze/gap.md` (원본) | ⚪ 조건부 | best | **신규 개발 시 사실상 N/A** (AS-IS 없음 → GAP = requirements 전체). 재실행 시 `reviewed/gap.md` 자동 삭제 |
| 5 | 1.4 | 분석 종합 리뷰 | `/review-analyze` | `docs/01.analyze/{req, asis, gap}.md` (원본) + `docs/00.input/` | `docs/01.analyze/analyze-review-report.md` + PASS 시 `reviewed/` 일괄 복사 | 🟢 안전망 | best | **다음 단계 진입 조건**: `reviewed/` 3개 파일 존재 |
| 6 | 1.7 | Claude Design 프롬프트 | `/design-prompt-gen` | `docs/01.analyze/reviewed/requirements.md` | `docs/02.design/design-prompts.md` | ⚪ 선택 (Screen 있을 때 권장) | balanced | — |
| 7 | 2.1 | 프로세스 설계 | `/design-process` | `docs/01.analyze/reviewed/requirements.md` | `docs/02.design/process.md` (원본) | 🔵 필수 | balanced | 재실행 시 `reviewed/process.md` 자동 삭제 |
| 8 | 2.2 | 화면 설계 | `/design-screen` | `docs/01.analyze/reviewed/{req, gap}.md` | `docs/02.design/screen.md` (원본) | 🔵 필수 | balanced | 재실행 시 `reviewed/{screen, api, tc/uat-checklist}.md` 자동 삭제 (의존 연쇄) |
| 9 | 2.3 | DB 설계 | `/design-db` | `docs/01.analyze/reviewed/{req, gap}.md` | `docs/02.design/db.md` (원본) | 🔵 필수 | balanced | 재실행 시 `reviewed/{db, api, tc/uat-checklist}.md` 자동 삭제 |
| 10 | 2.4 | API 설계 | `/design-api` | `docs/02.design/{screen, db}.md` (원본) | `docs/02.design/api.md` (원본) | 🔵 필수 | balanced | 재실행 시 `reviewed/{api, tc/uat-checklist}.md` 자동 삭제 |
| 11 | 2.5 | 외부 연계 설계 | `/design-integration` | `docs/01.analyze/reviewed/{req, asis}.md` | `docs/02.design/integration.md` (원본) | ⚪ 선택 (연계 있을 때) | balanced | 재실행 시 `reviewed/integration.md` 자동 삭제 |
| 12 | 2.6 | 설계 종합 리뷰 | `/review-design` | `docs/02.design/*.md` (원본) + `docs/01.analyze/reviewed/{req, asis}.md` | `docs/02.design/design-review-report.md` + PASS 시 `reviewed/` 일괄 복사 + cross-check.md + deliverable.md 자동 연쇄 | 🟢 안전망 | best | **다음 단계 진입 조건**: `reviewed/` 에 5개 design 파일 존재 |
| 13 | 2.7 | UAT 체크리스트 | `/design-tc` | `docs/02.design/reviewed/{screen, api, db}.md` | `docs/02.design/tc/uat-checklist.md` | 🔵 필수 | balanced | 재실행 시 `reviewed/tc/uat-checklist.md` 자동 삭제 |
| 14 | 3.1 | DB 구현 | `/build-db` | `docs/02.design/reviewed/db.md` | 소스코드 (마이그레이션, 스키마) | 🔵 필수 | balanced | 재실행 시 `docs/03.build/impact-check.md` + `docs/04.review/reviewed/report.md` 자동 삭제 |
| 15 | 3.2 | API 구현 | `/build-api` | `docs/02.design/reviewed/{api, db}.md` | 소스코드 (라우터, 서비스) | 🔵 필수 | balanced | 동일 (위) |
| 16 | 3.3 | 화면 구현 | `/build-screen` | `docs/02.design/reviewed/{screen, api}.md` | 소스코드 (페이지, 컴포넌트) | 🔵 필수 | balanced | 동일 (위) |
| 17 | 3.5 | 변경 영향도 검사 | `/impact-check` | `docs/01.analyze/reviewed/gap.md` + `git diff` | `docs/03.build/impact-check.md` | 🟢 안전망 | best | 재실행 시 `docs/04.review/reviewed/report.md` 자동 삭제 |
| 18 | 4 | 코드 리뷰 | `/review-all` | `docs/02.design/reviewed/{api, db, screen}.md` + 소스코드 + `impact-check.md` | `docs/04.review/report.md` + PASS 시 `reviewed/report.md` 복사 | 🟢 안전망 | best | **다음 단계 진입 조건**: `docs/04.review/reviewed/report.md` 존재 |
| 19 | 5.1 | DB 테스트 | `/test-db` | `docs/02.design/reviewed/db.md` + 스키마 코드 | `docs/05.test/report-db.md` (원본) | 🔵 필수 | fast | 재실행 시 `reviewed/report-db.md` + `cross-check.md` 자동 삭제 |
| 20 | 5.2 | API 테스트 | `/test-api` | `docs/02.design/reviewed/api.md` + API 코드 | `docs/05.test/report-api.md` (원본) | 🔵 필수 | fast | 동일 (위) |
| 21 | 5.3 | 화면 테스트 | `/test-screen` | `docs/02.design/reviewed/screen.md` + 화면 코드 | `docs/05.test/report-screen.md` (원본) | 🔵 필수 | fast | 동일 (위) |
| 22 | 5.4 | E2E 테스트 | `/test-e2e` | `docs/01.analyze/reviewed/requirements.md` + 전체 코드 | `docs/05.test/report-e2e.md` + PASS 시 `manual-testcases.md` 자동 생성 | 🔵 필수 | balanced | 동일 (위) |
| 23 | 5.5 | Chrome UI 지시문 | `/test-ui-chrome` | `docs/02.design/tc/uat-checklist.md` | `docs/05.test/ui-test-chrome.md` + `.xlsx` (QA용 수동 검증 자료) | ⚪ 선택 (Screen 있을 때) | balanced | — |
| 24 | 5.6 | 테스트 교차검증 | `/cross-check-test` | `docs/05.test/report-{db, api, screen, e2e}.md` (원본) + `docs/01.analyze/reviewed/requirements.md` | `docs/05.test/cross-check.md` + 4개 보고서를 `reviewed/` 로 일괄 복사 | 🟢 안전망 | fast | **다음 단계 진입 조건**: `docs/05.test/reviewed/report-*.md` 4개 존재 |
| 25 | 5.7 | Dev 배포 | `/deploy-dev` | `docs/05.test/reviewed/` (전체) + `docs/02.design/tc/uat-checklist.md` | `docs/06.deploy/deploy-dev.md` + Dev 환경 배포 | 🟢 안전망 | fast | UAT 진입 조건 |
| 26 | 6 | UAT (사람) | (수동) | `docs/02.design/tc/uat-checklist.md` (QA 담당자가 직접 수행) | `docs/06.deploy/uat-result.md` (P/F 기록) | 🟢 안전망 | — | 운영 배포 진입 조건: 전체 PASS |
| 27 | 7 | 운영 배포 | `/deploy-prd` | `docs/06.deploy/uat-result.md` (PASS) + `docs/05.test/reviewed/` | `docs/06.deploy/deploy-prd.md` + 운영 환경 배포 | 🟢 안전망 | balanced | 최종 |

---

## 단계 그룹별 요약

| 그룹 | Phase 범위 | 핵심 산출물 | 안전망 단계 |
|---|---|---|---|
| 준비 | 0, 0.5 | CLAUDE.md, grill-result.md | — |
| **분석** | 1.1 ~ 1.7 | requirements / asis / gap + design-prompts | review-analyze |
| **설계** | 2.1 ~ 2.7 | process / screen / db / api / integration / uat-checklist | review-design |
| **구현** | 3.1 ~ 3.5 | 소스코드 + impact-check.md | impact-check |
| **리뷰** | 4 | review-all report.md | review-all |
| **테스트** | 5.1 ~ 5.7 | report-{db, api, screen, e2e}.md + cross-check.md + ui-test-chrome | cross-check-test, deploy-dev |
| **검증·배포** | 6, 7 | uat-result.md + deploy-prd.md | UAT, deploy-prd |

---

## `reviewed/` 의 의미 (모든 단계 통일)

각 단계의 "리뷰" 가 PASS 한 시점의 사본만 `reviewed/` 폴더에 들어갑니다. 다음 단계는 `reviewed/` 만 읽으면 자동 안전 보장.

| 단계 | "리뷰" 역할 | reviewed/ 경로 |
|---|---|---|
| 분석 | `review-analyze` | `docs/01.analyze/reviewed/` |
| 설계 | `review-design` | `docs/02.design/reviewed/` |
| 구현 | `review-all` | `docs/04.review/reviewed/` |
| 테스트 | `cross-check-test` | `docs/05.test/reviewed/` |

**원본 산출물 변경 시 → reviewed/ 의 해당 파일과 의존 파일이 자동 무효화 (스킬 사전 동작)**. 따라서 다음 단계 진입을 위해 리뷰를 다시 받아야 합니다.

---

## 비교 — `pipeline-maintenance` (운영 변경)

같은 단계지만 GAP 범위만 처리하는 흐름이 따로 있습니다. 별도 가이드(추후 작성 예정) 참조 또는 `.claude/commands/pipeline-maintenance.md` 본문 참조.

- 분석: 변경 정의 → asis → requirements → gap → review-analyze
- 설계: GAP 있는 레이어만 design + review-design (Phase 5.7 에서 design-tc 조건부)
- 구현: GAP 있는 레이어만 build + impact-check (자동 강등 안전망) + review-all
- 테스트: 변경 기능 + 회귀 (impact-check High 기준) + cross-check-test
- 배포: deploy-dev → UAT → deploy-prd → CONTEXT 갱신 (Phase 11)

---

> 마지막 갱신: 2026-05-20 (CHANGELOG v2.4.8 참조)

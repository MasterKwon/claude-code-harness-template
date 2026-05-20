#!/bin/bash
# .claude/skills/{name}.md Read 직전 진입 조건 검사 (PreToolUse 훅)
# 진입 조건 미충족 시 exit 2 로 차단 + stderr 로 명확한 안내
#
# 안전망 4(5)개:
#   design-*    → docs/01.analyze/reviewed/{req|gap}.md 필요
#   design-tc   → + docs/02.design/reviewed/ 필요 (review-design PASS 후)
#   build-*     → docs/02.design/reviewed/ 필요
#   test-*      → docs/04.review/reviewed/report.md 필요
#   deploy-dev  → docs/05.test/reviewed/report-*.md 4개 필요
#   deploy-prd  → + docs/06.deploy/uat-result.md 필요
#
# 신규 개발 첫 사이클(analyze-*, review-analyze, grill-*, project-setup 등)은 통과

FILE=$1

# 빠른 분기 — 스킬 파일이 아니면 즉시 통과 (성능 보호)
[[ "$FILE" != *.claude/skills/*.md ]] && exit 0
[[ "$FILE" == *.claude/skills/stacks/* ]] && exit 0

SKILL=$(basename "$FILE" .md)

block() {
  echo "" >&2
  echo "🚫 [파이프라인 안전망] $SKILL 실행 차단" >&2
  echo "" >&2
  echo "$1" >&2
  echo "" >&2
  echo "(우회 필요 시: 사용자가 명시적으로 진입 조건을 무시하고 진행하라고 지시할 때만 가능)" >&2
  exit 2
}

# review-design PASS 된 design 산출물이 reviewed/ 에 하나라도 있는지
# (5개 중 어떤 것이라도 — 신규는 모두, 운영은 GAP 있는 레이어만)
has_design_artifact() {
  for f in process.md screen.md db.md api.md integration.md; do
    [ -f "docs/02.design/reviewed/$f" ] && return 0
  done
  return 1
}

case "$SKILL" in
  # ─── 설계 진입 ───
  design-process|design-screen|design-db|design-api|design-integration|design-prompt-gen)
    if [ ! -f "docs/01.analyze/reviewed/requirements.md" ] && [ ! -f "docs/01.analyze/reviewed/gap.md" ]; then
      block "진입 조건: docs/01.analyze/reviewed/requirements.md 또는 gap.md 가 존재해야 합니다.
       현재 둘 다 없음 → /review-analyze 를 먼저 실행하여 PASS 받으세요."
    fi
    ;;

  design-tc)
    if ! has_design_artifact; then
      block "진입 조건: docs/02.design/reviewed/ 에 review-design PASS 된 산출물(process|screen|db|api|integration .md)이 있어야 합니다.
       → /review-design 을 먼저 실행하여 PASS 받으세요."
    fi
    ;;

  # ─── 구현 진입 ───
  build-db)
    if [ ! -f "docs/02.design/reviewed/db.md" ]; then
      block "진입 조건: docs/02.design/reviewed/db.md 가 있어야 합니다.
       → /review-design 을 먼저 실행하여 PASS 받으세요."
    fi
    ;;
  build-api)
    if [ ! -f "docs/02.design/reviewed/api.md" ]; then
      block "진입 조건: docs/02.design/reviewed/api.md 가 있어야 합니다.
       → /review-design 을 먼저 실행하여 PASS 받으세요."
    fi
    ;;
  build-screen)
    if [ ! -f "docs/02.design/reviewed/screen.md" ]; then
      block "진입 조건: docs/02.design/reviewed/screen.md 가 있어야 합니다.
       → /review-design 을 먼저 실행하여 PASS 받으세요."
    fi
    ;;

  # ─── 테스트 진입 ───
  test-db|test-api|test-screen|test-e2e)
    if [ ! -f "docs/04.review/reviewed/report.md" ]; then
      block "진입 조건: docs/04.review/reviewed/report.md 가 존재해야 합니다.
       (review-all PASS 한 코드 리뷰 보고서)
       → /review-all 을 먼저 실행하여 PASS 받으세요."
    fi
    ;;

  # ─── Dev 배포 진입 ───
  deploy-dev)
    missing=""
    for f in report-db report-api report-screen report-e2e; do
      [ ! -f "docs/05.test/reviewed/$f.md" ] && missing="$missing $f.md"
    done
    if [ -n "$missing" ]; then
      block "진입 조건: docs/05.test/reviewed/ 에 4개 테스트 보고서가 모두 있어야 합니다.
       누락:$missing
       → /cross-check-test 를 먼저 실행하여 4개 보고서를 reviewed/ 로 복사하세요."
    fi
    ;;

  # ─── 운영 배포 진입 ───
  deploy-prd)
    missing=""
    for f in report-db report-api report-screen report-e2e; do
      [ ! -f "docs/05.test/reviewed/$f.md" ] && missing="$missing test/$f.md"
    done
    [ ! -f "docs/06.deploy/uat-result.md" ] && missing="$missing deploy/uat-result.md"
    if [ -n "$missing" ]; then
      block "진입 조건 미충족 (누락:$missing)
       UAT 완료 + cross-check-test 통과 후에 운영 배포 가능합니다."
    fi
    ;;

  # 그 외 (analyze-*, review-*, grill-*, project-setup, maintenance-init,
  # customer-request, impact-check, cross-check-*, deliverable-*, design-all,
  # build-all, test-all, refine-*, test-ui-chrome, skill-formatter, grill-task,
  # deploy-dev 외 배포)는 진입 조건 검사 없음
  *)
    ;;
esac

exit 0

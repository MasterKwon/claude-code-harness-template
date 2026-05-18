#!/bin/bash
# .claude/skills/*.md 파일 수정 시 구조 자동 점검 (stacks/ 제외)

FILE=$1

# skills/*.md 파일만 대상 (stacks/ 하위 제외)
if [[ "$FILE" != *".claude/skills/"*.md ]] || [[ "$FILE" == *"/stacks/"* ]]; then
  exit 0
fi

SKILL=$(basename "$FILE" .md)
ERRORS=()

# 1. 권장 모델 (첫 번째 줄)
FIRST_LINE=$(head -1 "$FILE")
if [[ "$FIRST_LINE" != \>\ 권장\ 모델:* ]]; then
  ERRORS+=("권장 모델 누락 — 첫 줄에 '> 권장 모델: fast|balanced|best' 필요")
else
  MODEL=$(echo "$FIRST_LINE" | sed 's/> 권장 모델: *//')
  if [[ "$MODEL" != "fast" && "$MODEL" != "balanced" && "$MODEL" != "best" ]]; then
    ERRORS+=("권장 모델 값 오류 — '$MODEL' (fast | balanced | best 중 하나여야 함)")
  fi
fi

# 2. 역할 정의
if ! grep -q '당신은 \*\*' "$FILE"; then
  ERRORS+=("역할 정의 누락 — '당신은 **{역할명}** 역할입니다.' 패턴 필요")
fi

# 3. 프로세스 섹션
if ! grep -qE '^## (프로세스|Step|실행 순서)' "$FILE"; then
  ERRORS+=("프로세스 섹션 누락 — '## 프로세스' 또는 '## Step N' 섹션 필요")
fi

# 결과 출력
if [ ${#ERRORS[@]} -eq 0 ]; then
  echo "[skill-check] ✅ $SKILL — 구조 정상"
else
  echo "[skill-check] ⚠️  $SKILL — 구조 미흡"
  for ERR in "${ERRORS[@]}"; do
    echo "  • $ERR"
  done
fi

exit 0

#!/bin/bash
# Claude가 파일 수정 후 자동 실행

MODIFIED_FILE=$1

# TypeScript 파일이 수정된 경우에만 체크
if [[ "$MODIFIED_FILE" == *.ts || "$MODIFIED_FILE" == *.tsx ]]; then
  echo "🔍 TypeScript 타입 체크 중..."
  
  # 해당 파일이 속한 서비스 폴더 찾기
  SERVICE_DIR=$(echo "$MODIFIED_FILE" | grep -oP '^[^/]+')
  
  if [ -f "$SERVICE_DIR/package.json" ]; then
    cd "$SERVICE_DIR"
    npx tsc --noEmit 2>&1
    
    if [ $? -ne 0 ]; then
      echo "❌ 타입 에러 발견 — Claude에게 수정 요청"
      exit 1
    else
      echo "✅ 타입 체크 통과"
    fi
  fi
fi

exit 0
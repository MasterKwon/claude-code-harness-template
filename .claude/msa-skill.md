# MSA 구조 스킬

## 프로젝트 폴더 구조
01.FirstProjects/
├── CLAUDE.md
├── .cursor/rules/
├── .claude/skills/
├── gateway/          # API Gateway (port 3000)
│   ├── package.json
│   └── app/
└── services/
    ├── user-service/     # port 3001
    │   ├── package.json
    │   └── app/
    └── product-service/  # port 3002
        ├── package.json
        └── app/

## 서비스 간 통신 패턴
# gateway -> service 호출 예시
const response = await fetch(`http://localhost:3001/api/users`)

## 환경변수 패턴
# gateway/.env
USER_SERVICE_URL=http://localhost:3001
PRODUCT_SERVICE_URL=http://localhost:3002
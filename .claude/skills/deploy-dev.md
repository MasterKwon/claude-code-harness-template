> 권장 모델: fast

# Dev 환경 배포 스킬

당신은 **DevOps 엔지니어** 역할입니다.
AI QA(Local) 통과 후, UAT 수행 전에 **개발/스테이징 서버에 배포**합니다.

> 이 배포는 UAT를 위한 배포입니다. 운영 배포(`/deploy-prd`)와 다릅니다.

---

## 사전 조건

- `docs/05.test/` 의 AI 테스트 보고서 존재 확인 (report-db, report-api, report-screen)
- FAIL 항목이 없어야 진행 가능

---

## 배포 전 체크리스트

### Git 상태
- [ ] 모든 변경사항이 커밋되어 있는가 (`git status`)
- [ ] develop 브랜치 기준으로 진행하는가

### Dev 환경 설정
- [ ] Dev 서버의 `.env` 가 스테이징 값으로 설정되어 있는가
- [ ] DB 마이그레이션이 Dev 서버에 적용되었는가
- [ ] 서비스 기동 순서가 정해져 있는가 (DB → API → 화면)

### 헬스체크
- [ ] 배포 후 주요 엔드포인트 응답 확인
- [ ] 로그인 화면 접근 가능 여부 확인

---

## 배포 실행

프로젝트의 배포 방식(PM2, Docker, CI/CD 등)에 따라 실행합니다.
배포 방식이 명확하지 않으면 사용자에게 확인합니다.

```bash
# PM2 기반 예시
git pull origin develop
npm install --production
npx prisma migrate deploy   # DB 마이그레이션 있을 경우
pm2 restart ecosystem.config.js

# 헬스체크
curl http://{DEV_SERVER}/health
```

---

## 완료 보고

`docs/06.deploy/deploy-dev.md` 에 저장합니다:

```
[Dev 배포 완료]
배포 환경: Dev / Staging
배포 브랜치: develop
배포 일시: YYYY-MM-DD HH:MM
헬스체크: 정상 / 비정상

→ UAT 체크리스트(docs/02.design/tc/uat-checklist.md)를 QA 담당자에게 전달하세요.
→ UAT 결과는 docs/06.deploy/uat-result.md 에 기록합니다.
→ UAT 완료 후 /deploy-prd 로 운영 배포를 진행합니다.
```

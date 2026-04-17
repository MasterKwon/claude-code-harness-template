# reviewed/ 폴더

이 폴더는 검토·승인이 완료된 설계 문서를 보관합니다.

## 워크플로우

```
/design-db 실행
    → docs/02.design/db.md 생성 (초안)
    → 내용 확인 후 이 폴더로 복사
    → docs/02.design/reviewed/db.md (승인본)
    → /build-db, /design-api 가 이 파일을 읽음
```

## 파일 목록
| 파일 | 생성 스킬 | 다음 단계에서 읽는 스킬 |
|------|----------|----------------------|
| db.md | /design-db | /design-api, /build-db |
| screen.md | /design-screen | /design-api, /build-screen |
| api.md | /design-api | /build-api, /build-screen |

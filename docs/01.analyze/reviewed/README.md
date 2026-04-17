# reviewed/ 폴더

이 폴더는 검토·승인이 완료된 문서를 보관합니다.

## 워크플로우

```
/analyze-requirements 실행
    → docs/01.analyze/requirements.md 생성 (초안)
    → 내용 확인 후 이 폴더로 복사
    → docs/01.analyze/reviewed/requirements.md (승인본)
    → 다음 단계 스킬이 이 파일을 읽음
```

## 파일 목록
| 파일 | 생성 스킬 | 다음 단계에서 읽는 스킬 |
|------|----------|----------------------|
| requirements.md | /analyze-requirements | /analyze-gap, /design-screen, /design-db |
| asis.md | /analyze-asis | /analyze-gap |
| gap.md | /analyze-gap | /design-screen, /design-db, /design-api |

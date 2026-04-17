# 입력 자료 폴더

요구사항 분석에 사용할 원본 자료를 이 폴더에 넣으세요.

## 지원 형식
| 형식 | 처리 방식 |
|------|----------|
| `.xlsx`, `.pptx`, `.csv`, `.txt`, `.md` | `extract.py`로 `.md` 변환 후 읽음 |
| `.pdf`, `.png`, `.jpg` | Claude가 직접 읽음 (변환 불필요) |

## 사용 방법
1. 이 폴더에 파일 추가
2. `/analyze-requirements` 실행
3. Claude가 자동으로 파일을 읽고 `docs/01.analyze/requirements.md` 생성

## 한글 파일 지원
CP949 / EUC-KR 인코딩 자동 처리 (`extract.py` 사용 시)

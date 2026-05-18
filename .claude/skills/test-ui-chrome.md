> 권장 모델: balanced

# Claude in Chrome UI 테스트 변환 스킬

당신은 **QA 자동화 브릿지** 역할입니다.
이미 작성된 UAT 체크리스트를 **Claude in Chrome 사이드패널에 그대로 붙여넣을 수 있는 자연어 지시문**과 **QA 담당자가 P/F를 기입할 엑셀 체크리스트**로 변환합니다.

이 스킬은 새로운 테스트를 만들지 않습니다. **기존 UAT 체크리스트의 형식만 변환**합니다.

---

## 사전 조건

`docs/02.design/tc/uat-checklist.md` 가 존재해야 합니다.
없으면 `/design-tc` 를 먼저 실행하도록 안내하세요.

---

## 프로세스

### Step 1 — UAT 체크리스트 읽기

`docs/02.design/tc/uat-checklist.md` 를 읽고 다음을 파악합니다:
- 화면 시나리오 TC 목록 (U-001 ~)
- 데이터 검증 TC 목록 (D-001 ~)
- 각 TC의 테스트 데이터, 기대 결과

### Step 2 — Claude in Chrome 지시문 생성

TC 한 건당 자연어 지시문 한 단락을 생성합니다.
Chrome 사이드패널의 Claude가 **실제 브라우저를 조작**할 수 있도록 명령어를 명확히 작성합니다.

지시문 작성 규칙:
- 한국어 자연어, 명령형 어조 ("로그인 화면으로 이동해서 ...")
- URL, 입력값, 클릭 대상을 구체적으로 명시
- 기대 결과를 "확인해줘" 형태로 검증 요청
- TC 번호를 헤더에 명시하여 사람이 엑셀과 대조 가능

### Step 3 — 엑셀 체크리스트 생성

`openpyxl` 로 xlsx 파일을 생성합니다.
시트는 단일 시트로 구성하되, "화면 시나리오"와 "데이터 검증"을 행 그룹으로 구분합니다.

엑셀 컬럼:
| TC# | 구분 | 시나리오 | 테스트 데이터 | 예상 결과 | 실제 결과 | P/F | 비고 |

- `실제 결과`, `P/F`, `비고` 컬럼은 비워둡니다 (QA가 기입).
- 헤더 행은 굵게, 컬럼 폭 자동 조정.

### Step 4 — 산출물 작성

| 파일 | 용도 | 작성 주체 |
|------|------|----------|
| `docs/05.test/ui-test-chrome.md` | Chrome 사이드패널 붙여넣기용 자연어 지시문 | AI (덮어쓰기) |
| `docs/05.test/ui-test-chrome.xlsx` | 빈 체크리스트 템플릿 | AI (덮어쓰기) |
| `docs/05.test/ui-test-chrome_result.xlsx` | QA가 P/F·실제값 기입한 결과본 | QA 담당자 (수동 추가) |

> AI는 `_result.xlsx` 를 만들지 않습니다. QA가 `ui-test-chrome.xlsx` 를 복사하여 작업합니다.
> 회차 추적은 git history 로 수행합니다 (별도 회차 폴더 없음).

---

## 출력 형식 — `ui-test-chrome.md`

```markdown
# Claude in Chrome UI 테스트 지시문

> 사용 방법: 각 TC 단락을 복사하여 Claude in Chrome 사이드패널에 붙여넣고 실행합니다.
> 실행 결과는 `ui-test-chrome_result.xlsx` 에 P/F 로 기록합니다.

---

## U-001 — 정상 로그인

로그인 페이지(`/login`)로 이동해줘. 이메일 입력란에 `test@test.com`, 비밀번호 입력란에 `Test1234!` 를 입력하고 로그인 버튼을 눌러줘.
로그인 성공 후 대시보드(`/dashboard`)로 이동했는지 확인하고, URL 과 페이지 제목을 알려줘.

기대 결과: `/dashboard` 로 이동, 페이지 상단에 사용자 이메일 표시.

---

## U-002 — 잘못된 비밀번호

로그인 페이지로 이동해서 이메일 `test@test.com`, 비밀번호 `wrong` 으로 로그인을 시도해줘.
화면에 에러 메시지가 노출되는지 확인하고, 메시지 내용을 그대로 알려줘.

기대 결과: "비밀번호가 일치하지 않습니다" 등 명확한 에러 메시지 노출.

---

## D-001 — 회원가입 데이터 저장 확인

회원가입 페이지(`/signup`)로 이동해서 이메일 `qa-test-001@test.com`, 비밀번호 `Qa1234!@`, 이름 `테스트사용자` 로 가입해줘.
가입 완료 후 관리자 페이지(`/admin/users`)로 이동해서 방금 가입한 사용자가 목록에 표시되는지 확인해줘.

기대 결과: 목록에 `qa-test-001@test.com` 존재.

---
```

## 출력 형식 — `ui-test-chrome.xlsx`

| TC# | 구분 | 시나리오 | 테스트 데이터 | 예상 결과 | 실제 결과 | P/F | 비고 |
|-----|------|---------|------------|---------|---------|-----|------|
| U-001 | 로그인 | 정상 로그인 | test@test.com / Test1234! | /dashboard 이동 | | | |
| U-002 | 로그인 | 잘못된 비밀번호 | wrong | 에러 메시지 노출 | | | |
| D-001 | 회원가입 | 데이터 저장 확인 | qa-test-001@test.com | 목록에 표시 | | | |

---

## Step 3 실행 스크립트 예시

스킬 실행 시 아래 Python 코드를 임시 파일로 작성 후 실행합니다.

```python
from openpyxl import Workbook
from openpyxl.styles import Font, Alignment

wb = Workbook()
ws = wb.active
ws.title = "UI 테스트"

headers = ["TC#", "구분", "시나리오", "테스트 데이터", "예상 결과", "실제 결과", "P/F", "비고"]
ws.append(headers)
for cell in ws[1]:
    cell.font = Font(bold=True)
    cell.alignment = Alignment(horizontal="center")

# TC 데이터 행 (uat-checklist.md 에서 파싱한 결과)
rows = [
    ("U-001", "로그인", "정상 로그인", "test@test.com / Test1234!", "/dashboard 이동", "", "", ""),
    # ...
]
for row in rows:
    ws.append(row)

# 컬럼 폭 자동 조정
for col in ws.columns:
    max_len = max(len(str(c.value)) if c.value else 0 for c in col)
    ws.column_dimensions[col[0].column_letter].width = max_len + 2

wb.save("docs/05.test/ui-test-chrome.xlsx")
```

필요 라이브러리 (최초 1회):
```bash
pip install openpyxl
```

---

## 출력 완료 후 보고

생성된 두 파일 경로와, 사람이 수행할 다음 행동을 안내합니다:

```
✅ 생성 완료
- docs/05.test/ui-test-chrome.md       (Chrome 사이드패널 지시문)
- docs/05.test/ui-test-chrome.xlsx     (체크리스트 템플릿)

다음 행동:
1. ui-test-chrome.xlsx 를 복사하여 ui-test-chrome_result.xlsx 로 저장
2. Chrome 사이드패널에서 ui-test-chrome.md 의 TC 단락을 차례로 실행
3. 각 TC 결과를 _result.xlsx 에 P/F 로 기입
4. 완료 후 git commit 으로 회차 보존
```

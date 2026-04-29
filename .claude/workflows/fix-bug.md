# Workflow: 버그 수정
> 트리거: 버그, bug, 수정, fix

---

## 실행 순서

### Step 1. 버그 재현 확인
- 어떤 Action이 트리거되는 시점인지 확인
- State 어떤 값이 잘못되었는지 확인
- Effect 실패인지 / Reducer 로직 오류인지 구분

### Step 2. 브랜치 생성
```bash
git checkout develop
git pull origin develop
git checkout -b fix/{버그-요약-kebab-case}
```
예: `fix/empty-title-crash`, `fix/delete-not-working`

### Step 3. 원인 파악 체크
- [ ] State 초기값 문제인가?
- [ ] Action 흐름이 잘못되었나?
- [ ] Effect (비동기) 타이밍 문제인가?
- [ ] Dependency 구현 오류인가?
- [ ] View 바인딩 누락인가?

### Step 4. 수정 후 검증
- 수정 전 동작과 수정 후 동작 비교 설명
- 동일 경로에서 side effect 없는지 확인

### Step 5. 커밋 & PR
```bash
git commit -m "fix: {버그 내용 한 줄 요약}"
```
이후 PR 생성 워크플로우 실행 (`create-pr.md`)

---

## ■ REQUIRED
- 버그 원인 레이어(State/Action/Effect/View) 명시
- `fix:` prefix 커밋 필수

# Workflow: 리팩토링
> 트리거: 리팩토링, refactor, 정리, 개선

---

## 실행 순서

### Step 1. 리팩토링 범위 확인
- 단일 Feature 내부인가?
- 여러 Feature에 걸친 공통 로직인가?
- Dependency 레이어인가?

### Step 2. 브랜치 생성
```bash
git checkout develop
git pull origin develop
git checkout -b refactor/{대상-kebab-case}
```

### Step 3. 리팩토링 체크리스트
- [ ] 기능 동작이 변경되지 않는가?
- [ ] TCA 레이어 규칙이 더 명확해졌는가?
- [ ] 중복 코드가 제거되었는가?
- [ ] 네이밍이 `development.md` 규칙에 맞는가?
- [ ] 하드코딩이 토큰으로 대체되었는가?

### Step 4. 커밋 & PR
```bash
git commit -m "refactor: {리팩토링 내용 한 줄 요약}"
```

---

## ■ REQUIRED
- 리팩토링 전후 동작이 동일해야 함
- `refactor:` prefix 커밋 필수

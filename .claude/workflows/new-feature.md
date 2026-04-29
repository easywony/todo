# Workflow: 새 기능 추가
> 트리거: 새 기능, feature, 기능 추가, 화면 추가

---

## 실행 순서

### Step 1. Prerequisites 읽기
- `.claude/references/architecture.md` 읽기
- `.claude/references/development.md` 읽기

### Step 2. 브랜치 생성
```bash
git checkout develop
git pull origin develop
git checkout -b feature/{기능명-kebab-case}
```
예: `feature/add-todo`, `feature/todo-filter`, `feature/due-date`

### Step 3. Feature 폴더 구조 생성
```
Features/{FeatureName}/
├── {FeatureName}Feature.swift
└── {FeatureName}View.swift
```

### Step 4. Feature 구현 순서
1. `{FeatureName}Feature.swift` 작성
   - State 정의 (필요한 데이터만)
   - Action 정의 (UI 이벤트 + Effect 결과)
   - Reducer 구현 (로직)
   - Effect 연결 (Dependency 호출)

2. `{FeatureName}View.swift` 작성
   - `@Bindable var store: StoreOf<{FeatureName}Feature>`
   - State → UI 바인딩
   - 버튼/제스처 → `store.send(.action)`

3. 신규 Dependency 필요 시 `Dependencies/` 에 추가
   - `liveValue` + `testValue` 반드시 함께 구현

### Step 5. feature-checklist.md 검증
`.claude/checklists/feature-checklist.md` 의 모든 REQUIRED 항목 통과 확인

### Step 6. 완료 후
작업이 완료되면 PR 생성 워크플로우 실행 (`create-pr.md`)

---

## ■ REQUIRED
- Feature는 반드시 Feature폴더 내 2파일 구조로 생성
- View에서 직접 데이터 처리 금지 → 반드시 Reducer로

## ◇ CONDITIONAL
- 신규 데이터 모델 필요 시 → `Models/` 에 추가
- 외부 저장소 필요 시 → `Dependencies/` 에 Repository 추가

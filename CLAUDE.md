# TodoApp — Claude Assistant v1.0
> Personal iOS Todo App | Swift + SwiftUI + TCA

---

## 🎯 Mandatory Triggers
트리거 키워드를 감지하면 해당 워크플로우를 즉시 실행한다.

| 키워드 | 액션 |
|--------|------|
| PR, 피알, 풀리퀘, 작업완료, 올려줘, merge | READ .claude/workflows/create-pr.md |
| 새 기능, feature, 기능 추가, 화면 추가 | READ .claude/workflows/new-feature.md |
| 리팩토링, refactor, 정리, 개선 | READ .claude/workflows/refactor.md |
| 버그, bug, 수정, fix | READ .claude/workflows/fix-bug.md |

---

## ⚙️ Workflows Pipeline

### ① Prerequisites (모든 작업 전 반드시 읽기)
- `.claude/references/architecture.md` — TCA 구조, 레이어 규칙
- `.claude/references/development.md` — 코딩 컨벤션, 네이밍 규칙

### ② Execute Workflow (트리거 매칭 후 단계별 실행)
- `.claude/workflows/create-pr.md`
- `.claude/workflows/new-feature.md`
- `.claude/workflows/refactor.md`
- `.claude/workflows/fix-bug.md`

### ③ Validate (완료 전 체크리스트 검증)
- ■ REQUIRED — 필수, 스킵 불가
- □ OPTIONAL — 선택 사항
- ◇ CONDITIONAL — 조건부 (해당할 때만)

---

## 🏗️ Architecture Overview

```
TodoApp/
├── App/
│   └── TodoAppApp.swift
├── Features/                  # TCA Feature 단위 폴더
│   ├── TodoList/
│   │   ├── TodoListFeature.swift      # Reducer
│   │   └── TodoListView.swift         # View
│   ├── TodoDetail/
│   │   ├── TodoDetailFeature.swift
│   │   └── TodoDetailView.swift
│   └── AddTodo/
│       ├── AddTodoFeature.swift
│       └── AddTodoView.swift
├── Models/                    # 공유 데이터 모델
│   └── Todo.swift
├── Dependencies/              # TCA Dependency (Repository 등)
│   └── TodoRepository.swift
└── Resources/                 # Assets, Colors, Fonts
```

- **Pattern**: TCA (The Composable Architecture)
- **UI**: SwiftUI
- **Minimum iOS**: 17.0
- **Package Manager**: Swift Package Manager

---

## 🔴 핵심 원칙 (항상 준수)

1. **하드코딩 금지** — 색상·폰트·간격은 반드시 디자인 토큰(Assets.xcassets) 사용
2. **TCA 규칙** — View는 Store만 바라본다. 비즈니스 로직은 반드시 Reducer 안에
3. **Dependency 주입** — 외부 의존성은 반드시 `@Dependency`로 주입, 직접 호출 금지
4. **Effect 격리** — 사이드이펙트(네트워크, DB)는 Effect로만 처리
5. **커밋 컨벤션** — `feat:` `fix:` `refactor:` `chore:` `docs:` prefix 필수

---

## 📦 Dependencies (SPM)

- `swift-composable-architecture` — Point-Free TCA
- (추후 필요 시 추가)

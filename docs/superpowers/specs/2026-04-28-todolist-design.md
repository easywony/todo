# TodoList 화면 설계

**날짜**: 2026-04-28
**브랜치**: feature/todo-list
**접근법**: NavigationStack + List (A안)

---

## 1. 개요

할 일 목록을 표시하는 앱의 루트 화면. 완료 토글, 스와이프 삭제, 상세 이동을 지원하며 iOS 네이티브 Inset Grouped List 스타일을 사용한다.

---

## 2. 데이터 모델

**`Models/Todo.swift`**

```swift
struct Todo: Identifiable, Equatable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var dueDate: Date?
    var priority: Priority

    enum Priority: String, CaseIterable, Equatable {
        case high, medium, low
    }
}
```

- `dueDate`는 선택적(`?`) — 마감일 없는 항목 허용
- `Priority.CaseIterable` — 추후 필터/정렬 확장 대비

---

## 3. TCA Feature

### State

```swift
@ObservableState
struct State: Equatable {
    var todos: IdentifiedArrayOf<Todo> = []
    var isLoading = false
}
```

### Action

| Action | 트리거 | 설명 |
|--------|--------|------|
| `onAppear` | View 진입 | Repository에서 목록 로드 |
| `todosLoaded(Result)` | Effect 완료 | 목록 State 반영 |
| `toggleCompleted(id:)` | 완료 원형 탭 | 낙관적 업데이트 후 저장 |
| `deleteTodo(id:)` | 스와이프 삭제 | State 제거 후 저장 |
| `addTodoButtonTapped` | + 버튼 탭 | 추후 AddTodo 화면 연결 |
| `todoRowTapped(id:)` | 행 탭 | 추후 TodoDetail 화면 연결 |

### Reducer 핵심 흐름

- `onAppear` → `todoRepository.fetchAll()` → `todosLoaded`
- `toggleCompleted` / `deleteTodo` → State 즉시 변경(낙관적) → `todoRepository.save()`
- `addTodoButtonTapped` / `todoRowTapped` → 현재 stub, `@Presents` 확장 예정

---

## 4. Dependency

**`Dependencies/TodoRepository.swift`**

```swift
struct TodoRepository {
    var fetchAll: @Sendable () async throws -> [Todo]
    var save:     @Sendable ([Todo]) async throws -> Void
}
```

- `liveValue`: UserDefaults + JSONEncoder/Decoder
- `testValue`: 빈 배열 반환 stub

---

## 5. View 구조

**`Features/TodoList/TodoListView.swift`**

- `NavigationStack` + `List(.insetGrouped)`
- `TodoRowView`: 행 단위 분리 구조체
- `.swipeActions(edge: .trailing, allowsFullSwipe: true)` → 휴지통 아이콘
- `.toolbar` `topBarTrailing` → `+` 버튼

**행(Row) 레이아웃**

```
[완료 원형] [제목]             [›]
           [우선순위 점+텍스트] [마감일]
```

- **완료 원형**: 독립된 `Button` — 탭 시 `store.send(.toggleCompleted(id:))` 디스패치. 행 전체 탭(`todoRowTapped`)과 분리
- 완료 상태: 초록 체크 원 + 취소선 + opacity 감소
- 우선순위 색상: 높음 `#ff3b30` / 중간 `#ff9500` / 낮음 `#34c759`

---

## 6. 파일 구조

```
todo/
├── Models/
│   └── Todo.swift
├── Dependencies/
│   └── TodoRepository.swift
├── Features/
│   └── TodoList/
│       ├── TodoListFeature.swift
│       └── TodoListView.swift
└── Resources/
    └── DesignTokens.swift   (우선순위 색상 토큰)
```

---

## 7. 미구현 / 추후 확장

- `addTodoButtonTapped` → AddTodo Sheet (`@Presents`)
- `todoRowTapped` → TodoDetail NavigationDestination
- SwiftData 마이그레이션 (현재 UserDefaults)
- 필터/정렬 (Priority.CaseIterable 활용)

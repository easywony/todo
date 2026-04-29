# Architecture Reference
> TodoApp TCA 구조 설계 문서

---

## TCA 레이어 규칙

### Feature 구성 (1 Feature = 1 폴더)
각 화면/기능은 `Features/{FeatureName}/` 폴더 하나에 다음 두 파일로 구성한다.

```
Features/TodoList/
├── TodoListFeature.swift   # Reducer, State, Action, Effect
└── TodoListView.swift      # View (Store만 바라봄)
```

### Reducer 작성 규칙
```swift
@Reducer
struct TodoListFeature {
    @ObservableState
    struct State: Equatable {
        var todos: IdentifiedArrayOf<Todo> = []
        var isLoading = false
    }

    enum Action {
        case onAppear
        case todosLoaded(Result<[Todo], Error>)
        case deleteTodo(id: Todo.ID)
        // UI 이벤트는 동사형으로
    }

    @Dependency(\.todoRepository) var todoRepository

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    // 사이드이펙트는 반드시 Effect 내부에서
                    let todos = try await todoRepository.fetchAll()
                    await send(.todosLoaded(.success(todos)))
                }
            // ...
            }
        }
    }
}
```

### View 작성 규칙
```swift
struct TodoListView: View {
    // Store만 주입받는다. ViewModel, EnvironmentObject 금지
    @Bindable var store: StoreOf<TodoListFeature>

    var body: some View {
        // store.todos 로 State 접근
        // store.send(.action) 으로 Action 디스패치
    }
}
```

---

## Dependency 작성 규칙

```swift
// Dependencies/TodoRepository.swift
struct TodoRepository {
    var fetchAll: @Sendable () async throws -> [Todo]
    var add: @Sendable (Todo) async throws -> Void
    var delete: @Sendable (Todo.ID) async throws -> Void
}

extension TodoRepository: DependencyKey {
    static let liveValue = TodoRepository(
        fetchAll: { /* SwiftData or UserDefaults 실제 구현 */ },
        add: { _ in },
        delete: { _ in }
    )

    static let testValue = TodoRepository(
        fetchAll: { [] },
        add: { _ in },
        delete: { _ in }
    )
}

extension DependencyValues {
    var todoRepository: TodoRepository {
        get { self[TodoRepository.self] }
        set { self[TodoRepository.self] = newValue }
    }
}
```

---

## 화면 네비게이션 규칙

- 네비게이션은 TCA의 `@Presents` + `.sheet` / `.navigationDestination` 사용
- 절대 직접 `NavigationLink(destination:)` 에 View를 하드코딩하지 않는다

```swift
// State에 child feature 선언
@Presents var addTodo: AddTodoFeature.State?

// View에서
.sheet(item: $store.scope(state: \.addTodo, action: \.addTodo)) { store in
    AddTodoView(store: store)
}
```

---

## 데이터 영속성

- **저장소**: SwiftData (iOS 17+)
- Repository 패턴으로 추상화, Feature는 저장 방식을 몰라야 한다

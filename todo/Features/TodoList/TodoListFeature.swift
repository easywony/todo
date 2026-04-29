import ComposableArchitecture

@Reducer
struct TodoListFeature {
    @ObservableState
    struct State: Equatable {
        var todos: IdentifiedArrayOf<Todo> = []
        var isLoading = false
    }

    enum Action {
        case onAppear
        case todosLoaded([Todo])
        case todoLoadFailed
        case toggleCompleted(id: Todo.ID)
        case deleteTodo(id: Todo.ID)
        case addTodoButtonTapped
        case todoRowTapped(id: Todo.ID)
    }

    @Dependency(\.todoRepository) var todoRepository

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    do {
                        let todos = try await todoRepository.fetchAll()
                        await send(.todosLoaded(todos))
                    } catch {
                        await send(.todoLoadFailed)
                    }
                }

            case .todosLoaded(let todos):
                state.isLoading = false
                state.todos = IdentifiedArray(uniqueElements: todos)
                return .none

            case .todoLoadFailed:
                state.isLoading = false
                return .none

            case .toggleCompleted(let id):
                state.todos[id: id]?.isCompleted.toggle()
                return .run { [todos = state.todos] _ in
                    try await todoRepository.save(Array(todos))
                }

            case .deleteTodo(let id):
                state.todos.remove(id: id)
                return .run { [todos = state.todos] _ in
                    try await todoRepository.save(Array(todos))
                }

            case .addTodoButtonTapped, .todoRowTapped:
                return .none
            }
        }
    }
}

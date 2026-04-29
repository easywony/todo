import ComposableArchitecture

@Reducer
struct TodoListFeature {
    enum SortOrder: String, Equatable, CaseIterable {
        case manual   = "추가순"
        case dueDate  = "마감일순"
        case priority = "우선순위순"
    }

    @ObservableState
    struct State: Equatable {
        var todos: IdentifiedArrayOf<Todo> = []
        var isLoading = false
        var isAddTodoPresented = false
        var filterPriority: Todo.Priority? = nil
        var sortOrder: SortOrder = .manual

        var displayedTodos: [Todo] {
            var result = Array(todos)
            if let filter = filterPriority {
                result = result.filter { $0.priority == filter }
            }
            switch sortOrder {
            case .manual:
                break
            case .dueDate:
                result.sort {
                    switch ($0.dueDate, $1.dueDate) {
                    case (let a?, let b?): return a < b
                    case (.some, .none):   return true
                    case (.none, .some):   return false
                    case (.none, .none):   return false
                    }
                }
            case .priority:
                let order: [Todo.Priority] = [.high, .medium, .low]
                result.sort {
                    (order.firstIndex(of: $0.priority) ?? 0) <
                    (order.firstIndex(of: $1.priority) ?? 0)
                }
            }
            return result
        }
    }

    enum Action {
        case onAppear
        case todosLoaded([Todo])
        case todoLoadFailed
        case toggleCompleted(id: Todo.ID)
        case deleteTodo(id: Todo.ID)
        case addTodoButtonTapped
        case addTodoDismissed
        case filterChanged(Todo.Priority?)
        case sortOrderChanged(SortOrder)
    }

    @Dependency(\.todoRepository) var todoRepository

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
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

        case .addTodoButtonTapped:
            state.isAddTodoPresented = true
            return .none

        case .addTodoDismissed:
            state.isAddTodoPresented = false
            state.isLoading = true
            return .run { send in
                do {
                    let todos = try await todoRepository.fetchAll()
                    await send(.todosLoaded(todos))
                } catch {
                    await send(.todoLoadFailed)
                }
            }

        case .filterChanged(let priority):
            state.filterPriority = priority
            return .none

        case .sortOrderChanged(let order):
            state.sortOrder = order
            return .none
        }
    }
}

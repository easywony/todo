import ComposableArchitecture
import Foundation

@Reducer
struct AddTodoFeature {
    @ObservableState
    struct State: Equatable {
        var title = ""
        var priority: Todo.Priority = .medium
        var dueDate = Date()
        var isDueDateEnabled = false

        var isSaveDisabled: Bool {
            title.trimmingCharacters(in: .whitespaces).isEmpty
        }
    }

    enum Action {
        case titleChanged(String)
        case priorityChanged(Todo.Priority)
        case dueDateToggled
        case dueDateChanged(Date)
        case saveTapped
        case cancelTapped
    }

    @Dependency(\.todoRepository) var todoRepository
    @Dependency(\.dismiss) var dismiss

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .titleChanged(let title):
            state.title = title
            return .none

        case .priorityChanged(let priority):
            state.priority = priority
            return .none

        case .dueDateToggled:
            state.isDueDateEnabled.toggle()
            return .none

        case .dueDateChanged(let date):
            state.dueDate = date
            return .none

        case .saveTapped:
            let todo = Todo(
                title: state.title.trimmingCharacters(in: .whitespaces),
                dueDate: state.isDueDateEnabled ? state.dueDate : nil,
                priority: state.priority
            )
            return .run { [todo] _ in
                try await todoRepository.add(todo)
                await dismiss()
            }

        case .cancelTapped:
            return .run { _ in await dismiss() }
        }
    }
}

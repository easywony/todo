import ComposableArchitecture
import Foundation

@Reducer
struct TodoDetailFeature {
    @ObservableState
    struct State: Equatable {
        let todoID: Todo.ID
        var title: String
        var priority: Todo.Priority
        var dueDate: Date
        var isDueDateEnabled: Bool
        var isCompleted: Bool
        var isDone = false
        var isDeleted = false

        init(todo: Todo) {
            self.todoID = todo.id
            self.title = todo.title
            self.priority = todo.priority
            self.dueDate = todo.dueDate ?? Date()
            self.isDueDateEnabled = todo.dueDate != nil
            self.isCompleted = todo.isCompleted
        }
    }

    enum Action {
        case titleChanged(String)
        case priorityChanged(Todo.Priority)
        case dueDateToggled
        case dueDateChanged(Date)
        case completedToggled
        case saveTapped
        case saveCompleted
        case deleteTapped
        case deleteCompleted
    }

    @Dependency(\.todoRepository) var todoRepository

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

        case .completedToggled:
            state.isCompleted.toggle()
            return .none

        case .saveTapped:
            let updated = Todo(
                id: state.todoID,
                title: state.title.trimmingCharacters(in: .whitespaces),
                isCompleted: state.isCompleted,
                dueDate: state.isDueDateEnabled ? state.dueDate : nil,
                priority: state.priority
            )
            return .run { [updated] send in
                try await todoRepository.update(updated)
                await send(.saveCompleted)
            }

        case .saveCompleted:
            state.isDone = true
            return .none

        case .deleteTapped:
            return .run { [id = state.todoID] send in
                try await todoRepository.delete(id)
                await send(.deleteCompleted)
            }

        case .deleteCompleted:
            state.isDeleted = true
            return .none
        }
    }
}

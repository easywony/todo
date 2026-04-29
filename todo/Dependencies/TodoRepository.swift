import ComposableArchitecture
import Foundation

struct TodoRepository {
    var fetchAll: @Sendable () async throws -> [Todo]
    var save: @Sendable ([Todo]) async throws -> Void
    var add: @Sendable (Todo) async throws -> Void
    var update: @Sendable (Todo) async throws -> Void
    var delete: @Sendable (Todo.ID) async throws -> Void
}

extension TodoRepository: DependencyKey {
    static let liveValue = TodoRepository(
        fetchAll: {
            guard
                let data = UserDefaults.standard.data(forKey: "todos"),
                let todos = try? JSONDecoder().decode([Todo].self, from: data)
            else { return [] }
            return todos
        },
        save: { todos in
            let data = try JSONEncoder().encode(todos)
            UserDefaults.standard.set(data, forKey: "todos")
        },
        add: { todo in
            let existing = (try? JSONDecoder().decode(
                [Todo].self,
                from: UserDefaults.standard.data(forKey: "todos") ?? Data()
            )) ?? []
            let data = try JSONEncoder().encode(existing + [todo])
            UserDefaults.standard.set(data, forKey: "todos")
        },
        update: { todo in
            var todos = (try? JSONDecoder().decode(
                [Todo].self,
                from: UserDefaults.standard.data(forKey: "todos") ?? Data()
            )) ?? []
            if let idx = todos.firstIndex(where: { $0.id == todo.id }) {
                todos[idx] = todo
            }
            let data = try JSONEncoder().encode(todos)
            UserDefaults.standard.set(data, forKey: "todos")
        },
        delete: { id in
            var todos = (try? JSONDecoder().decode(
                [Todo].self,
                from: UserDefaults.standard.data(forKey: "todos") ?? Data()
            )) ?? []
            todos.removeAll { $0.id == id }
            let data = try JSONEncoder().encode(todos)
            UserDefaults.standard.set(data, forKey: "todos")
        }
    )

    static let testValue = TodoRepository(
        fetchAll: { [] },
        save: { _ in },
        add: { _ in },
        update: { _ in },
        delete: { _ in }
    )
}

extension DependencyValues {
    var todoRepository: TodoRepository {
        get { self[TodoRepository.self] }
        set { self[TodoRepository.self] = newValue }
    }
}

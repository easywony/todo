import ComposableArchitecture
import Foundation

struct TodoRepository {
    var fetchAll: @Sendable () async throws -> [Todo]
    var save: @Sendable ([Todo]) async throws -> Void
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
        }
    )

    static let testValue = TodoRepository(
        fetchAll: { [] },
        save: { _ in }
    )
}

extension DependencyValues {
    var todoRepository: TodoRepository {
        get { self[TodoRepository.self] }
        set { self[TodoRepository.self] = newValue }
    }
}

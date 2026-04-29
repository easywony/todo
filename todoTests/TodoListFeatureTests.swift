import ComposableArchitecture
import XCTest
@testable import todo

@MainActor
final class TodoListFeatureTests: XCTestCase {

    func test_onAppear_loadsTodos() async {
        let todo = Todo(id: UUID(), title: "테스트 할 일", priority: .high)
        let store = TestStore(initialState: TodoListFeature.State()) {
            TodoListFeature()
        } withDependencies: {
            $0.todoRepository.fetchAll = { [todo] }
        }

        await store.send(.onAppear) {
            $0.isLoading = true
        }
        await store.receive(\.todosLoaded) {
            $0.isLoading = false
            $0.todos = IdentifiedArray(uniqueElements: [todo])
        }
    }

    func test_toggleCompleted_flipsIsCompleted() async {
        let todo = Todo(id: UUID(), title: "토글 테스트", priority: .medium)
        let store = TestStore(
            initialState: TodoListFeature.State(
                todos: IdentifiedArray(uniqueElements: [todo])
            )
        ) {
            TodoListFeature()
        } withDependencies: {
            $0.todoRepository.save = { _ in }
        }

        await store.send(.toggleCompleted(id: todo.id)) {
            $0.todos[id: todo.id]?.isCompleted = true
        }
    }

    func test_deleteTodo_removesFromState() async {
        let todo = Todo(id: UUID(), title: "삭제 대상", priority: .low)
        let store = TestStore(
            initialState: TodoListFeature.State(
                todos: IdentifiedArray(uniqueElements: [todo])
            )
        ) {
            TodoListFeature()
        } withDependencies: {
            $0.todoRepository.save = { _ in }
        }

        await store.send(.deleteTodo(id: todo.id)) {
            $0.todos.remove(id: todo.id)
        }
    }
}

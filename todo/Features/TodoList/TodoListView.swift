import ComposableArchitecture
import SwiftUI

struct TodoListView: View {
    @Bindable var store: StoreOf<TodoListFeature>

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.todos) { todo in
                    TodoRowView(todo: todo) {
                        store.send(.toggleCompleted(id: todo.id))
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        store.send(.todoRowTapped(id: todo.id))
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            store.send(.deleteTodo(id: todo.id))
                        } label: {
                            Label("삭제", systemImage: "trash")
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("할 일")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        store.send(.addTodoButtonTapped)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear { store.send(.onAppear) }
            .sheet(
                isPresented: Binding(
                    get: { store.isAddTodoPresented },
                    set: { isPresented in
                        if !isPresented { store.send(.addTodoDismissed) }
                    }
                )
            ) {
                AddTodoView(
                    store: Store(initialState: AddTodoFeature.State()) {
                        AddTodoFeature()
                    }
                )
            }
        }
    }
}

struct TodoRowView: View {
    let todo: Todo
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(todo.isCompleted ? Color.priorityLow : Color(.systemGray3))
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 3) {
                Text(todo.title)
                    .font(.body)
                    .strikethrough(todo.isCompleted)
                    .foregroundStyle(todo.isCompleted ? .secondary : .primary)

                HStack(spacing: 6) {
                    HStack(spacing: 3) {
                        Circle()
                            .fill(todo.priority.color)
                            .frame(width: 8, height: 8)
                        Text(todo.priority.label)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(todo.priority.color)
                    }

                    if let date = todo.dueDate {
                        Text(date.formatted(.dateTime.month().day()))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .opacity(todo.isCompleted ? 0.45 : 1.0)
    }
}

#Preview {
    TodoListView(
        store: Store(initialState: TodoListFeature.State(
            todos: IdentifiedArray(uniqueElements: [
                Todo(title: "디자인 시스템 토큰 정리", dueDate: Date(), priority: .high),
                Todo(title: "TodoList Feature 구현", priority: .medium),
                Todo(title: "README 업데이트", priority: .low),
                Todo(title: "초기 프로젝트 설정", isCompleted: true, priority: .medium),
            ])
        )) {
            TodoListFeature()
        }
    )
}

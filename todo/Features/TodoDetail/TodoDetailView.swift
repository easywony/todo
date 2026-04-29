import ComposableArchitecture
import SwiftUI

struct TodoDetailView: View {
    let store: StoreOf<TodoDetailFeature>
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Form {
            Section {
                Toggle("완료", isOn: Binding(
                    get: { store.isCompleted },
                    set: { _ in store.send(.completedToggled) }
                ))
            }

            Section("할 일") {
                TextField("제목", text: Binding(
                    get: { store.title },
                    set: { store.send(.titleChanged($0)) }
                ))
            }

            Section("우선순위") {
                Picker("우선순위", selection: Binding(
                    get: { store.priority },
                    set: { store.send(.priorityChanged($0)) }
                )) {
                    ForEach(Todo.Priority.allCases, id: \.self) { priority in
                        Label(priority.label, systemImage: "circle.fill")
                            .foregroundStyle(priority.color)
                            .tag(priority)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section("마감일") {
                Toggle("마감일 설정", isOn: Binding(
                    get: { store.isDueDateEnabled },
                    set: { _ in store.send(.dueDateToggled) }
                ))
                if store.isDueDateEnabled {
                    DatePicker(
                        "날짜 선택",
                        selection: Binding(
                            get: { store.dueDate },
                            set: { store.send(.dueDateChanged($0)) }
                        ),
                        displayedComponents: .date
                    )
                }
            }

            Section {
                Button("삭제", role: .destructive) {
                    store.send(.deleteTapped)
                }
            }
        }
        .navigationTitle("상세")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("저장") { store.send(.saveTapped) }
                    .fontWeight(.semibold)
            }
        }
        .onChange(of: store.isDone) { _, isDone in
            if isDone { dismiss() }
        }
        .onChange(of: store.isDeleted) { _, isDeleted in
            if isDeleted { dismiss() }
        }
    }
}

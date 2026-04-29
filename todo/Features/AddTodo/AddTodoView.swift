import ComposableArchitecture
import SwiftUI

struct AddTodoView: View {
    let store: StoreOf<AddTodoFeature>

    var body: some View {
        NavigationStack {
            Form {
                Section("할 일") {
                    TextField("제목을 입력하세요", text: Binding(
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
            }
            .navigationTitle("할 일 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("취소") { store.send(.cancelTapped) }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("저장") { store.send(.saveTapped) }
                        .disabled(store.isSaveDisabled)
                        .fontWeight(.semibold)
                }
            }
        }
    }
}

#Preview {
    AddTodoView(
        store: Store(initialState: AddTodoFeature.State()) {
            AddTodoFeature()
        }
    )
}

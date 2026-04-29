import ComposableArchitecture
import SwiftUI

@main
struct todoApp: App {
    var body: some Scene {
        WindowGroup {
            TodoListView(
                store: Store(initialState: TodoListFeature.State()) {
                    TodoListFeature()
                }
            )
        }
    }
}

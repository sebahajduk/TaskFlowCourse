import ComposableArchitecture
import SwiftUI

struct TabBarView: View {
  let store: StoreOf<TabBarReducer>

  var body: some View {
    TabView {
      Tab("To do", systemImage: "checkmark") {
        TaskListView(store: store.scope(state: \.taskList, action: \.taskList))
      }

      Tab("Finished", systemImage: "checkmark.circle.fill") {
        FinishedTasksView(store: store.scope(state: \.finishedTasks, action: \.finishedTasks))
      }
    }
  }
}

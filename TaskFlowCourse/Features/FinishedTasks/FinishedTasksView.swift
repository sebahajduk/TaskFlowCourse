import ComposableArchitecture
import SwiftUI

struct FinishedTasksView: View {
  let store: StoreOf<FinishedTasksReducer>

  var body: some View {
    NavigationView {
      VStack {
        List {
          ForEach(store.finishedTasks) { task in
            VStack(alignment: .leading) {
              Text(task.name)
                .frame(maxWidth: .infinity, alignment: .leading)

              task.finishDate.flatMap {
                Text($0, format: .dateTime)
              }
            }
          }
        }
        .listStyle(.plain)
      }
      .navigationTitle("Finished in session")
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

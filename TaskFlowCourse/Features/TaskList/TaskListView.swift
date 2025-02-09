import ComposableArchitecture
import SwiftUI

struct TaskListView: View {
  @Bindable var store: StoreOf<TaskListReducer>

  var body: some View {
    VStack {
      List {
        ForEach(store.taskList) { task in
          HStack {
            Image(
              systemName: task.finishDate == nil
              ? "circle"
              : "circle.fill"
            )
            .onTapGesture { store.send(.taskTapped(task)) }

            VStack(alignment: .leading) {
              Text(task.name)
                .frame(maxWidth: .infinity, alignment: .leading)
              Text(task.dateCreated, format: .dateTime)
            }
          }
        }
        .onDelete { store.send(.deleteTask($0)) }
      }
      .listStyle(.plain)

      TextField(
        "Task name",
        text: $store.taskName
      )
        .padding()
        .background(Color.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 5.0))

      Button("Add task") {
        store.send(.addButtonTapped)
      }
      .padding(10.0)
      .background(Color.purple)
      .foregroundStyle(Color.white)
      .font(.footnote.bold())
    }
    .onAppear { store.send(.onAppear) }
    .padding()
  }
}

#Preview {
  TaskListView(
    store: Store(
      initialState: TaskListReducer.State(),
      reducer: {
        TaskListReducer()
      }
    )
  )
}

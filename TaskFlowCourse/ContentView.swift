import ComposableArchitecture
import SwiftUI

@Reducer
struct TaskListReducer {
  @ObservableState
  struct State: Equatable {
    var taskName: String
    var taskList: [Task]

    init(taskName: String = "", taskList: [Task] = []) {
      self.taskName = taskName
      self.taskList = taskList
    }
  }

  enum Action: Equatable, BindableAction {
    case addButtonTapped
    case binding(BindingAction<State>)
  }

  var body: some ReducerOf<Self> {
    BindingReducer()

    Reduce { state, action in
      switch action {
      case .addButtonTapped:
        let task = Task(name: state.taskName, dateCreated: Date())
        state.taskList.append(task)
        state.taskName = ""
        return .none

      case .binding:
        return .none
      }
    }
    ._printChanges()
  }
}

struct Task: Identifiable, Equatable {
  let id: UUID = .init()
  let name: String
  let dateCreated: Date
}

struct ContentView: View {
  @Bindable var store: StoreOf<TaskListReducer>

  var body: some View {
    VStack {
      List {
        ForEach(store.taskList) { task in
          VStack(alignment: .leading) {
            Text(task.name)
              .frame(maxWidth: .infinity, alignment: .leading)
            Text(task.dateCreated, format: .dateTime)
          }
        }
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
    .padding()
  }
}

#Preview {
  ContentView(
    store: Store(
      initialState: TaskListReducer.State(),
      reducer: {
        TaskListReducer()
      }
    )
  )
}

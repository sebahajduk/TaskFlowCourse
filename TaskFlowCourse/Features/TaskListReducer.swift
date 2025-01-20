import ComposableArchitecture
import Foundation

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
    case cancelEffect
    case tasksFetched([Task])
    case onAppear
    case eventReceived([Task])
    case deleteTask(String)
  }

  private enum CancelId: Hashable {
    case cancellation
  }

  @Dependency(\.date.now) private var now
  @Dependency(\.firebaseClient) private var firebase

  var body: some ReducerOf<Self> {
    BindingReducer()

    Reduce { state, action in
      switch action {
      case .addButtonTapped:
        let task = Task(name: state.taskName, dateCreated: self.now)
        state.taskName = ""
        return .run { send in
          try await self.firebase.saveTask(task)
        }

      case .deleteTask(let id):
        return .run { _ in
          try await self.firebase.deleteTask(id)
        }

      case .onAppear:
        return .run { send in
          for await event in try await self.firebase.changesStream() {
            await send(.eventReceived(event))
          }
        }
        .cancellable(id: CancelId.cancellation)

      case .eventReceived(let event):
        state.taskList = event
        return .none

      case .cancelEffect:
        return .cancel(id: CancelId.cancellation)

      case .tasksFetched(let tasks):
        state.taskList = tasks
        return .none

      case .binding:
        return .none
      }
    }
    ._printChanges()
  }
}

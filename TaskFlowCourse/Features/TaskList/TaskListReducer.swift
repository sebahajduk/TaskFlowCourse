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
    case deleteTask(IndexSet)
    case taskTapped(Task)
    case delegate(Delegate)

    enum Delegate: Equatable {
      case addToFinishedTasks(Task)
    }
  }

  private enum CancelId: Hashable {
    case cancellation
  }

  @Dependency(\.date.now) private var now
  @Dependency(\.uuid) private var uuid
  @Dependency(\.firebaseClient) private var firebase

  var body: some ReducerOf<Self> {
    BindingReducer()

    Reduce { state, action in
      switch action {
      case .addButtonTapped:
        let task = Task(
          id: self.uuid(),
          name: state.taskName,
          dateCreated: self.now
        )
        state.taskName = ""
        return .run { send in
          try await self.firebase.saveTask(task)
        }

      case .taskTapped(var task):
        task.finishDate = self.now
        return .run { [task] send in
          try await self.firebase.saveTask(task)
          await send(.delegate(.addToFinishedTasks(task)))
        }

      case .deleteTask(let indexSet):
        guard let index = indexSet.first
        else { return .none }
        let task = state.taskList[index]
        return .run { _ in
          try await self.firebase.deleteTask(task.id.uuidString)
        }

      case .onAppear:
        return .run { send in
          for await event in try await self.firebase.changesStream() {
            await send(.eventReceived(event))
          }
        }
        .cancellable(id: CancelId.cancellation)

      case .eventReceived(let event):
        state.taskList = event.filter { $0.finishDate == nil }
        return .none

      case .cancelEffect:
        return .cancel(id: CancelId.cancellation)

      case .tasksFetched(let tasks):
        state.taskList = tasks
        return .none

      case .binding:
        return .none

      case .delegate:
        return .none
      }
    }
  }
}

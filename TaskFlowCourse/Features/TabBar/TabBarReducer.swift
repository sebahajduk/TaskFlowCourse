import ComposableArchitecture
import Foundation

@Reducer
struct TabBarReducer {
  @ObservableState
  struct State: Equatable {
    var taskList = TaskListReducer.State()
    var finishedTasks = FinishedTasksReducer.State()
  }

  enum Action: Equatable {
    case taskList(TaskListReducer.Action)
    case finishedTasks(FinishedTasksReducer.Action)
  }

  var body: some ReducerOf<Self> {
    Scope(state: \.taskList, action: \.taskList) {
      TaskListReducer()
    }

    Scope(state: \.finishedTasks, action: \.finishedTasks) {
      FinishedTasksReducer()
    }

    Reduce { state, action in
      switch action {
      case .taskList(.delegate(.addToFinishedTasks(let task))):
        return .send(.finishedTasks(.addToFinishedTasks(task)))

      case .taskList:
        return .none

      case .finishedTasks:
        return .none
      }
    }
  }
}

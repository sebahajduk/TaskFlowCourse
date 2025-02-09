import ComposableArchitecture
import Foundation

@Reducer
struct FinishedTasksReducer {
  @ObservableState
  struct State: Equatable {
    var finishedTasks: [Task]

    init(finishedTasks: [Task] = []) {
      self.finishedTasks = finishedTasks
    }
  }

  enum Action: Equatable {
    case addToFinishedTasks(Task)
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .addToFinishedTasks(let task):
        state.finishedTasks.append(task)
        return .none
      }
    }
  }
}

import ComposableArchitecture
import Foundation

@Reducer
struct TaskDetailsReducer {
  @ObservableState
  struct State: Equatable {
    var task: Task
    var time: Double
    var timerIsRunning: Bool
    @Presents var alert: AlertState<Action.Alert>?

    init(
      task: Task,
      time: Double = 0.0,
      timerIsRunning: Bool = false
    ) {
      self.task = task
      self.time = time
      self.timerIsRunning = timerIsRunning
    }
  }

  enum Action: Equatable {
    case alert(PresentationAction<Alert>)
    case backButtonTapped
    case showAlert
    case startTimer
    case stopTimer
    case timerTick

    @CasePathable
    enum Alert: Equatable {
      case leaveButtonTapped
    }
  }

  enum CancelId {
    case timer
  }

  @Dependency(\.calendar) private var calendar
  @Dependency(\.continuousClock) private var clock
  @Dependency(\.date.now) private var now
  @Dependency(\.dismiss) private var dismiss
  @Dependency(\.firebaseClient) private var firebase

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .alert(.presented(.leaveButtonTapped)):
        state.task.sessions[self.calendar.startOfDay(for: self.now), default: 0.0] += state.time
        return .run { [task = state.task] _ in
          try await self.firebase.saveTask(task)
          await self.dismiss()
        }

      case .alert:
        return .none

      case .backButtonTapped:
        guard !state.timerIsRunning
        else { return .send(.showAlert) }
        return .run { _ in await self.dismiss() }

      case .showAlert:
        state.alert = .init(
          title: { TextState("Czy jesteś pewny?") },
          actions: {
            ButtonState(
              role: .destructive,
              action: .leaveButtonTapped,
              label: { TextState("Wróć") }
            )

            ButtonState(
              role: .cancel,
              label: { TextState("Anuluj") }
            )
          },
          message: { TextState("Timer zostanie zatrzymany") }
        )
        return .none

      case .startTimer:
        state.timerIsRunning = true
        return .run { send in
          await withTaskCancellation(id: CancelId.timer, cancelInFlight: true) {
            for await _ in clock.timer(interval: .seconds(1.0)) {
              await send(.timerTick)
            }
          }
        }

      case .stopTimer:
        state.timerIsRunning = false
        state.task.sessions[self.calendar.startOfDay(for: self.now), default: 0.0] += state.time
        state.time = 0.0
        return .cancel(id: CancelId.timer)

      case .timerTick:
        state.time += 1.0
        return .none
      }
    }
    .ifLet(\.$alert, action: \.alert)
  }
}

import ComposableArchitecture
import SwiftUI

struct TaskDetailsView: View {
  @Bindable var store: StoreOf<TaskDetailsReducer>

  var body: some View {
    VStack {
      Text(store.time.asDuration, format: .time(pattern: .hourMinuteSecond))
        .font(.largeTitle)

      Button(
        action: { store.timerIsRunning ? store.send(.stopTimer) : store.send(.startTimer) },
        label: { Image(systemName: store.timerIsRunning ? "pause" : "play") }
      )
      .font(.largeTitle)

      Divider()

      List {
        ForEach(store.task.sessions.sorted(by: >), id: \.key) { key, value in
          HStack {
            Text(key, style: .date)
              .fontWeight(.semibold)

            Text(value.asDuration, format: .time(pattern: .hourMinuteSecond))
          }
        }
      }
      .padding(.top, 50.0)
    }
    .alert($store.scope(state: \.alert, action: \.alert))
    .navigationTitle(store.task.name)
    .navigationBarTitleDisplayMode(.inline)
    .navigationBarBackButtonHidden()
    .toolbar {
      ToolbarItem(placement: .navigation) {
        Button("< Back") {
          store.send(.backButtonTapped)
        }
      }
    }
  }
}

extension Double {
  var asDuration: Duration {
    .seconds(self)
  }
}

#Preview {
  TaskDetailsView(
    store: .init(
      initialState: TaskDetailsReducer.State(
        task: .init(
          id: UUID(),
          name: "Task",
          dateCreated: Date(),
          sessions: [Date().advanced(by: -200_000): 1_000]
        )
      ),
      reducer: TaskDetailsReducer.init
    )
  )
}

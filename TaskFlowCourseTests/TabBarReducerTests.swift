import ComposableArchitecture
import Foundation
import Testing
@testable import TaskFlowCourse

struct TabBarReducerTests {
  @Test
  func finishingTask_shouldBeAddedToFinishedInSession() async throws {
    let task = Task(id: UUID(0), name: "Test", dateCreated: .mock)
    let finishedTask = Task(id: UUID(0), name: "Test", dateCreated: .mock, finishDate: .mock)

    let store = await TestStore(
      initialState: TabBarReducer.State(),
      reducer: TabBarReducer.init,
      withDependencies: {
        $0.uuid = .incrementing
        $0.date.now = .mock
        $0.firebaseClient.saveTask = { _ in }
      }
    )

    await store.send(.taskList(.taskTapped(task)))
    await store.receive(.taskList(.delegate(.addToFinishedTasks(finishedTask))))
    await store.receive(.finishedTasks(.addToFinishedTasks(finishedTask))) {
      $0.finishedTasks.finishedTasks = [finishedTask]
    }
  }
}

private extension Date {
  static let mock = Date(timeIntervalSince1970: 1000)
}

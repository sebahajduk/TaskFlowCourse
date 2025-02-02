import ComposableArchitecture
import Foundation
import SnapshotTesting
import XCTest
@testable import TaskFlowCourse

class TaskListSnapshot: XCTestCase {
  func test_taskList() {
    let view = TaskListView(
      store: Store(
        initialState: TaskListReducer.State(
          taskName: "Nazwa taska",
          taskList: [
            Task(id: UUID(0), name: "Dodany task 5", dateCreated: .mock),
            Task(id: UUID(1), name: "Dodany task 2", dateCreated: .mock),
          ]
        ),
        reducer: {}
      )
    )

    assertSnapshot(
      of: view,
      as: .image(
        perceptualPrecision: 0.98,
        layout: .device(
          config: .iPhone12Pro
        )
      )
    )
  }
}

private extension Date {
  static let mock = Date(timeIntervalSince1970: 1000)
}

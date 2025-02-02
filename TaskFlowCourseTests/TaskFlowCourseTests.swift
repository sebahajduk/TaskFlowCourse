import ComposableArchitecture
import Combine
import Foundation
import Testing
@testable import TaskFlowCourse

struct TaskFlowCourseTests {
  @Test
  func addingTask_shouldAdd() async throws {
    let expectedTask = Task(
      id: UUID(0),
      name: "Nazwa taska",
      dateCreated: Date(timeIntervalSince1970: 1000)
    )
    let store = await TestStore(
      initialState: TaskListReducer.State(
        taskName: "Nazwa taska"
      ),
      reducer: {
        TaskListReducer()
      },
      withDependencies: {
        $0.date.now = Date(timeIntervalSince1970: 1000)
        $0.uuid = .incrementing
        $0.firebaseClient.saveTask = { _ in }
        $0.firebaseClient.changesStream = {
          AsyncStream<[Task]> { _ in

          }
        }
      }
    )

    await store.send(.onAppear)

    await store.send(.addButtonTapped) {
      $0.taskName = ""
    }

    await store.send(.cancelEffect)
  }

  @Test
  func addingTask_shouldAddToTaskList() async throws {
    let expectedTask = Task(
      id: UUID(0),
      name: "Nazwa taska",
      dateCreated: Date(timeIntervalSince1970: 1000)
    )

    let taskList: LockIsolated<[Task]> = .init([])
    let event: PassthroughSubject<[Task], Never> = .init()

    let store = await TestStore(
      initialState: TaskListReducer.State(
        taskName: "Nazwa taska"
      ),
      reducer: {
        TaskListReducer()
      },
      withDependencies: {
        $0.date.now = Date(timeIntervalSince1970: 1000)
        $0.uuid = .incrementing
        $0.firebaseClient.saveTask = { task in
          var lockIsolatedValue = taskList.value
          lockIsolatedValue.append(task)
          taskList.setValue(lockIsolatedValue)
          event.send(taskList.value)
        }
        $0.firebaseClient.changesStream = {
          event.values.eraseToStream()
        }
      }
    )

    await store.send(.onAppear)

    await store.send(.addButtonTapped) {
      $0.taskName = ""
    }

    await store.receive(.eventReceived([expectedTask])) {
      $0.taskList = [expectedTask]
    }

    await store.send(.cancelEffect)
  }
}

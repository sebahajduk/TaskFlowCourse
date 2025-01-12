//
//  TaskFlowCourseApp.swift
//  TaskFlowCourse
//
//  Created by Sebastian Hajduk on 12/01/2025.
//
import ComposableArchitecture
import SwiftUI

@main
struct TaskFlowCourseApp: App {
    var body: some Scene {
        WindowGroup {
          ContentView(
            store: Store(
              initialState: TaskListReducer.State(),
              reducer: {
                TaskListReducer()
              }
            )
          )
        }
    }
}

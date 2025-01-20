//
//  TaskFlowCourseApp.swift
//  TaskFlowCourse
//
//  Created by Sebastian Hajduk on 12/01/2025.
//
import ComposableArchitecture
import FirebaseCore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
  ) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct TaskFlowCourseApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  var body: some Scene {
    WindowGroup {
      TaskListView(
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

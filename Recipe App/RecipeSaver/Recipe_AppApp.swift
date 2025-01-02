//
//  Recipe_AppApp.swift
//  Recipe App
//
//  Created by Gaming Lab on 7/11/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct Recipe_AppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//    init() {
//        FirebaseApp.configure()
//    }
    var body: some Scene {
        WindowGroup {
            LoadingView()
        }
    }
}

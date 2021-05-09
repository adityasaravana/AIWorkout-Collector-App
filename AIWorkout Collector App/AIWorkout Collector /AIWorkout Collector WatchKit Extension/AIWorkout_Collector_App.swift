//
//  AIWorkout_Collector_App.swift
//  AIWorkout Collector WatchKit Extension
//
//  Created by Aditya Saravana on 4/26/21.
//

import SwiftUI

@main
struct AIWorkout_Collector_App: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}

//
//  RemindersWithNotificationsApp.swift
//  RemindersWithNotifications
//
//  Created by Russell Gordon on 2025-05-17.
//

import SwiftUI

@main
struct RemindersWithNotificationsApp: App {
    
    // MARK: Stored properties
    @State private var notificationController = NotificationController()
    
    // MARK: Computed properties
    var body: some Scene {
        WindowGroup {
            RemindersListView()
                .environment(notificationController)
        }
    }
}

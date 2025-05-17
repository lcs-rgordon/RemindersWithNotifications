//
//  RemindersListViewModel.swift
//  RemindersWithNotifications
//
//  Created by Russell Gordon on 2025-05-17.
//

import Foundation

@Observable @MainActor
class RemindersListViewModel {
    
    // MARK: Stored properties
    
    // The list of reminders
    var reminders: [Reminder]
    
    // MARK: Initializer(s)
    init(reminders: [Reminder] = exampleItems) {
        self.reminders = reminders
    }
    
    // MARK: Functions
    func createReminder(withTitle title: String, notification: Notification? = nil) {
        
        // Create the new to-do item instance
        // NOTE: The id will be nil for now
        let newReminder = Reminder(
            id: UUID(),
            title: title,
            done: false,
            notification: notification
        )
        
        debugPrint(newReminder.notification?.scheduledFor.formatted())
        
        self.reminders.append(newReminder)

    }
    
}

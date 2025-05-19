//
//  RemindersListViewModel.swift
//  RemindersWithNotifications
//
//  Created by Russell Gordon on 2025-05-17.
//

import Foundation
import OSLog

@Observable @MainActor
class RemindersListViewModel {
    
    // MARK: Stored properties
    
    // The list of reminders
    var reminders: [Reminder]
    
    // MARK: Initializer(s)
    init(reminders: [Reminder] = exampleItems) {
        self.reminders = reminders
        Logger.data.info("RemindersListViewModel: Initalizer has completed.")
    }
    
    // MARK: Functions
    func createReminder(withTitle title: String, andNotificationAt providedDateAndTime: Date? = nil) {
        
        // Create the new to-do item instance
        // NOTE: The id will be nil for now
        let newReminder = Reminder(
            id: UUID(),
            title: title,
            done: false,
            notification: providedDateAndTime == nil ? nil : Notification(id: UUID(), scheduledFor: providedDateAndTime!)
        )
        
        Logger.data.info("RemindersListViewModel: Created new reminder (\(newReminder.title)) \(newReminder.notificationSet ? "WITH" : "WITHOUT") a notification set.")
        
        self.reminders.append(newReminder)

        Logger.data.info("RemindersListViewModel: Added new reminder to list of reminders.")

    }
    
}

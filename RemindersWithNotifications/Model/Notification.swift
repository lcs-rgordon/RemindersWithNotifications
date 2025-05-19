//
//  Notification.swift
//  RemindersWithNotifications
//
//  Created by Russell Gordon on 2025-05-19.
//

import Foundation

@Observable
class Notification: Identifiable {
    
    // MARK: Stored properties
    
    // Unique identifier for this notification
    var id: UUID
    
    // When the notification will be scheduled to show to the user
    var scheduledFor: Date
    
    // Whether the notification was successfully registered (created)
    var successfullyCreated: Bool = false
    
    // MARK: Initializer(s)
    init(id: UUID = UUID(), scheduledFor: Date, successfullyCreated: Bool = false) {
        self.id = id
        self.scheduledFor = scheduledFor
        self.successfullyCreated = successfullyCreated
    }
    
}


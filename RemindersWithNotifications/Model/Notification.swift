//
//  Notification.swift
//  RemindersWithNotifications
//
//  Created by Russell Gordon on 2025-05-19.
//

import Foundation

// NOTE: Since properties of a notification (when it is scheduled for)
//       will change (and we want this to be reflected in the user interface)
//       each notification must be an observable class, rather than a structure
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


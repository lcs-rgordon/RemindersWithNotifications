//
//  Reminder.swift
//  RemindersWithNotifications
//
//  Created by Russell Gordon on 2025-05-17.
//

import Foundation

struct Reminder: Identifiable, Codable, Hashable, Equatable {

    // MARK: Stored properties
    var id: UUID
    var title: String
    var done: Bool
    var notification: Notification?
    
    // MARK: Computed properties
    var notificationSet: Bool {
        if self.notification == nil {
            return false
        } else {
            return true
        }
    }
    
    // MARK: Function(s)
    static func == (lhs: Reminder, rhs: Reminder) -> Bool {
        lhs.id == rhs.id
    }
}

struct Notification: Identifiable, Codable, Hashable, Equatable {
    
    // MARK: Stored properties
    var id: UUID
    var scheduledFor: Date?
    
    // MARK: Function(s)
    static func == (lhs: Notification, rhs: Notification) -> Bool {
        lhs.id == rhs.id
    }

}

// Example data

let firstItem = Reminder(id: UUID(), title: "Study for Chemisty quiz", done: false)

let secondItem = Reminder(id: UUID(), title: "Finish Computer Science task", done: true)

let thirdItem = Reminder(id: UUID(), title: "Go for a run around campus", done: false)

let exampleItems = [
    
    firstItem
    ,
    secondItem
    ,
    thirdItem
    ,
    
]

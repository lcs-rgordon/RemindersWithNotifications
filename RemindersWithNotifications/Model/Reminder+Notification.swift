//
//  Reminder.swift
//  RemindersWithNotifications
//
//  Created by Russell Gordon on 2025-05-17.
//

import Foundation

@Observable
class Reminder: Identifiable, Hashable, Equatable {

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
    
    // MARK: Initializer(s)
    init(id: UUID, title: String, done: Bool, notification: Notification? = nil) {
        self.id = id
        self.title = title
        self.done = done
        self.notification = notification
    }
    
    // MARK: Function(s)
    static func == (lhs: Reminder, rhs: Reminder) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Notification: Identifiable, Hashable, Equatable {
    
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

//
//  Reminder.swift
//  RemindersWithNotifications
//
//  Created by Russell Gordon on 2025-05-17.
//

import Foundation

// NOTE: In order to keep track of which reminder is currently
//       selected in the list of reminders, the Reminder
//       type must conform to Hashable and Equatable.

// NOTE: Since properties of a reminder will change (and we want
//       this to be reflected in the user interface) each reminder
//       must be an observable class, rather than a structure
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
    init(id: UUID = UUID(), title: String, done: Bool, notification: Notification? = nil) {
        self.id = id
        self.title = title
        self.done = done
        self.notification = notification
    }
    
    // MARK: Function(s)
    
    // Required for Equatable conformance
    static func == (lhs: Reminder, rhs: Reminder) -> Bool {
        lhs.id == rhs.id
    }
    
    // Required for Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// Example data

let firstItem = Reminder(title: "Study for Chemisty quiz", done: false)

let secondItem = Reminder(title: "Finish Computer Science task", done: true)

let thirdItem = Reminder(title: "Go for a run around campus", done: false)

let exampleItems = [
    
    firstItem
    ,
    secondItem
    ,
    thirdItem
    ,
    
]

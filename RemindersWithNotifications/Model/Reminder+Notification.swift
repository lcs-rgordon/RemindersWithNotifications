//
//  Reminder.swift
//  RemindersWithNotifications
//
//  Created by Russell Gordon on 2025-05-17.
//

import Foundation

struct Reminder: Identifiable, Codable {
    
    var id: UUID
    var title: String
    var done:  Bool
    var notification: Notification?
    
}

struct Notification: Identifiable, Codable {
    
    var id: UUID
    var scheduledFor: Date?
    
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

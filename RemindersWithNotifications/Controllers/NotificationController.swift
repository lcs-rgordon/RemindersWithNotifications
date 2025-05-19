//
//  NotificationController.swift
//  RemindersWithNotifications
//
//  Created by Russell Gordon on 2025-05-19.
//

import Foundation
import UserNotifications

// NOTE: Adapted from example authored by Paul Hudson, here:
//       https://www.hackingwithswift.com/plus/ultimate-portfolio-app/adding-local-notifications

/// Handles creation of new notifications, edits to existing ones, or removals of a notification
/// A single instance of this class will be shared through the environment for use throughout the app
@Observable
class NotificationController: Observable {
    
    func addNotification(for reminder: Reminder) async -> Bool {
    
        /*
         We’re going to start off with a simplified version covering the easy parts:

         First we check our authorization status for local notifications.
         If the status is not determined – if the user hasn’t made a choice yet – then we’ll just leave a comment for more code, because it requires thinking.
         If we are already authorized we can call placeReminders() immediately.
         If we’re in any other authorization state, we’ll consider it a failure – the user has not granted us permission.
         */
        
        do {
            let center = UNUserNotificationCenter.current()
            let settings = await center.notificationSettings()
            
            switch settings.authorizationStatus {
            case .notDetermined:
                /*
                 Request notifications and respond accordingly – if they allow them, we should call placeReminders(); if not, we send back false because we've failed.
                 */
                let success = try await requestNotifications()
                if success {
                    try await placeNotification(for: reminder)
                } else {
                    return false
                }
            case .authorized:
                try await placeNotification(for: reminder)
            default:
                return false
            }
            
            // Success, if we got here!
            return true
            
        } catch {
            return false
        }
        
    }
    
    func removeNotifications(for reminder: Reminder) {
        
        // Get a reference to UNUserNotificationCenter (the hub of the UserNotifications framework)
        // Handles reading and writing local notifications for apps on iOS
        let center = UNUserNotificationCenter.current()

        // Remove the notification for the provided reminder
        center.removePendingNotificationRequests(withIdentifiers: [reminder.id.uuidString])
    }
    
    // This method is marked as "private" so we don’t accidentally try to call it
    // from elsewhere – it’s an implementation detail of the way we’ve made notifications
    // work, rather than a method that any other part of our project should be aware of.
    private func requestNotifications() async throws -> Bool {
        
        // Get a reference to UNUserNotificationCenter (the hub of the UserNotifications framework)
        // Handles reading and writing local notifications for apps on iOS
        let center = UNUserNotificationCenter.current()
        
        // Returns true if user provided permission for this app to show notifications
        return try await center.requestAuthorization(options: [.alert, .sound])
    }
    
    // Marked "private" because we don't want anyone else to call this by accident – it will be used
    // by another function within this class
    private func placeNotification(for reminder: Reminder) async throws {
        
        // Get a reference to UNUserNotificationCenter (the hub of the UserNotifications framework)
        // Handles reading and writing local notifications for apps on iOS
        let center = UNUserNotificationCenter.current()

        // 1. Create content of the notification to be shown
        // NOTE: We could add a subtitle to the notification, but there's no need for that within this app
        let content = UNMutableNotificationContent()
        content.sound = .default
        content.title = reminder.title
        
        // 2. Set the trigger for the notification
        // NOTE: This could be set "x" seconds from now, at a specific time, or using a geofencing trigger
        //       that causes the notification to appear when the user enters or leaves a specific location
        //       We will use the datetime the user selected for when to be notified.
        let components = Calendar.current.dateComponents([.hour, .minute, .day, .month, .year], from: reminder.notification!.scheduledFor)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        // NOTE: UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        //       Useful when debugging (Cmd-L to lock simulator screen, then test the notification)
        
        // 3. Set the ID for the notification. This MUST be stable (which is why we will use the UUID created when a notification date
        //    was selected for the reminder
        let id = reminder.notification!.id.uuidString
        
        // 4. Create the request
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        // 5. Now send the request to add the notification off to iOS
        return try await center.add(request)
        
    }
    
}

//
//  ReminderView.swift
//  RemindersWithNotifications
//
//  Created by Russell Gordon on 2025-05-17.
//

import OSLog
import SwiftUI

struct ReminderView: View {
    
    // MARK: Stored properties
    
    // Holds a reference to the current reminder
    @Binding var reminder: Reminder
    
    // Allow this view to make EditReminderView appear
    @Binding var presentingSheet: Bool

    // Allow this view to set the selected reminder in the list
    @Binding var selectedReminder: Reminder?

    // Access the view model through the environment
    @Environment(RemindersListViewModel.self) var viewModel
    
    // MARK: Computed properties
    var notificationIconName: String {
        if reminder.notificationSet {
            if reminder.notification!.successfullyCreated {
                return "bell.fill"
            } else {
                return "bell.slash.circle.fill"
            }
        } else {
            return "bell.slash"
        }
    }
    
    var notificationColor: Color {
        if reminder.notificationSet {
            if reminder.notification!.successfullyCreated {
                return .yellow
            } else {
                return .red
            }
        } else {
            return .gray
        }
    }
    
    var body: some View {
        HStack {
            Label(
                title: {
                    TextField("", text: $reminder.title, axis: .vertical)
                }, icon: {
                    Image(systemName: reminder.done == true ? "checkmark.circle" : "circle")
                        // Tap to mark as done
                        .onTapGesture {
                            Logger.viewCycle.info("ReminderView: Toggling completion status for reminder with id \(reminder.id).")
                            reminder.done.toggle()
                        }
                }
            )
            
            VStack(alignment: .trailing) {

                Image(systemName: notificationIconName)
                    .foregroundStyle(notificationColor)
                    .onTapGesture {
                        Logger.viewCycle.info("ReminderView: Showing sheet to set notification details for reminder with id \(reminder.id).")
                        selectedReminder = reminder
                        presentingSheet = true
                    }

                if reminder.notificationSet {
                    Text(reminder.notification!.scheduledFor.formatted(.relative(presentation: .numeric)))
                        .font(.caption)
                }
                
            }

        }
    }
}

#Preview {
    RemindersListView()
}

//
//  ReminderView.swift
//  RemindersWithNotifications
//
//  Created by Russell Gordon on 2025-05-17.
//

import OSLog
import SwiftUI

struct ReminderView: View {
    
    // Holds a reference to the current reminder
    @Binding var reminder: Reminder
    
    // Allow this view to make EditReminderView appear
    @Binding var presentingSheet: Bool

    // Allow this view to set the selected reminder in the list
    @Binding var selectedReminder: Reminder?

    // Access the view model through the environment
    @Environment(RemindersListViewModel.self) var viewModel
    
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
            
            Image(systemName: reminder.notificationSet ? "bell.fill" : "bell.slash")
                .foregroundStyle(reminder.notificationSet ? .yellow : .gray)
                .onTapGesture {
                    Logger.viewCycle.info("ReminderView: Showing sheet to set notification details for reminder with id \(reminder.id).")
                    selectedReminder = reminder
                    presentingSheet = true
                }

        }
    }
}

#Preview {
    RemindersListView()
}

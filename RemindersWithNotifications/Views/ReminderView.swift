//
//  ReminderView.swift
//  RemindersWithNotifications
//
//  Created by Russell Gordon on 2025-05-17.
//

import SwiftUI

struct ReminderView: View {
    
    // Holds a reference to the current to-do item
    @Binding var currentItem: Reminder
    
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
                    TextField("", text: $currentItem.title, axis: .vertical)
                }, icon: {
                    Image(systemName: currentItem.done == true ? "checkmark.circle" : "circle")
                        // Tap to mark as done
                        .onTapGesture {
                            currentItem.done.toggle()
                        }
                }
            )
            
            Image(systemName: currentItem.notificationSet ? "bell.fill" : "bell.slash")
                .foregroundStyle(currentItem.notificationSet ? .yellow : .gray)
                .onTapGesture {
                    selectedReminder = currentItem
                    presentingSheet = true
                }

        }
    }
}

#Preview {
    RemindersListView()
}

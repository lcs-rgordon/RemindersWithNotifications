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
            
        }
    }
}

#Preview {
    List {
        ReminderView(currentItem: .constant(firstItem))
        ReminderView(currentItem: .constant(secondItem))
    }
}

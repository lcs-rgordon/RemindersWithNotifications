//
//  RemindersListView.swift
//  RemindersWithNotifications
//
//  Created by Russell Gordon on 2025-05-17.
//

import OSLog
import SwiftUI

struct RemindersListView: View {
    
    // MARK: Stored properties
        
    // The view model
    @State private var viewModel = RemindersListViewModel()
    
    // Is the sheet that shows the view to allow for adding
    // or editing a reminder being presented?
    @State private var presentingSheet = false
    
    // The currently selected reminder
    @State private var selectedReminder: Reminder?
        
    // MARK: Computed properties
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
                if viewModel.reminders.isEmpty {
                    
                    ContentUnavailableView(
                        "Nothing to do",
                        systemImage: "pencil.tip.crop.circle.badge.plus",
                        description: Text("Add a reminder to get started")
                    )

                } else {
                    
                    List(
                        $viewModel.reminders,
                        id: \.self,
                        selection: $selectedReminder
                    ) { $reminder in
                        
                        ReminderView(
                            reminder: $reminder,
                            presentingSheet: $presentingSheet,
                            selectedReminder: $selectedReminder
                        )
                    }
                }
            }
            // When presentingNewItemSheet becomes true, this shows
            // the view within the sheet
            .sheet(isPresented: $presentingSheet) {
                SetReminderView(
                    showSheet: $presentingSheet,
                    reminder: $selectedReminder
                )
                // The word "detent" means to hold something in place
                // Here we ask for the size of the sheet to take up
                // 35% of the height of the existing window
                    .presentationDetents([.fraction(0.35)])
            }
            // Show a button to allow new to-do items to be added
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        Logger.viewCycle.info("RemindersListView: Toggling completion status for reminder.")
                        presentingSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationTitle("Reminders")
            
        }
        .environment(viewModel)
    }
}

#Preview {
    RemindersListView()
}

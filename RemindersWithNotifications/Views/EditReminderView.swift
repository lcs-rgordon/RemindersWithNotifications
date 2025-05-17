//
//  EditReminderView.swift
//  RemindersWithNotifications
//
//  Created by Russell Gordon on 2025-05-17.
//

import SwiftUI

struct EditReminderView: View {
    
    // MARK: Stored properties
    
    // The reminder sent for editing
    @Binding var currentReminder: Reminder?
    
    // The revised title
    @State private var title = ""
    
    // The revised notification
    @State private var notification: Notification?
    
    // Access the view model through the environment
    @Environment(RemindersListViewModel.self) var viewModel
    
    // Whether we are editing an existing reminder
    @State private var editingExistingReminder = false
    
    // Binding to control whether this sheet
    @Binding var showSheet: Bool
    
    // MARK: Computed properties
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Enter a reminder", text: $title)
                    
                    Button(editingExistingReminder ? "Save" : "Add") {
                        
                        if !editingExistingReminder {
                            // Add reminder
                            viewModel.createReminder(withTitle: title)
                            
                            // Clear the input field
                            title = ""
                        } else {
                            
                            // Save the changes to the existing reminder

                            
                        }
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(
                        title
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                            .isEmpty == true
                    )
                }

            }
            .padding(20)
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        showSheet = false
                        currentReminder = nil
                    } label: {
                        Text("Done")
                            .bold()
                    }
                    
                }
            }
            .onAppear {
                // Populate sheet with existing reminder if one was supplied
                if let currentReminder = currentReminder {
                    editingExistingReminder = true
                    title = currentReminder.title
                    notification = currentReminder.notification
                }
            }
        }


    }
        
}

// When it is a new reminder being created
#Preview {
    
    @Previewable @State var presentingNewReminderSheet = true
    @Previewable @State var currentReminder: Reminder? = nil
    
    Rectangle()
        .ignoresSafeArea()
        .foregroundStyle(.orange)
        .overlay {
            Text("View the sheet is connected to")
        }
        .sheet(isPresented: $presentingNewReminderSheet) {
            EditReminderView(
                currentReminder: $currentReminder,
                showSheet: $presentingNewReminderSheet
            )
                // Control size of the sheet when it slides up
                .presentationDetents([.fraction(0.15), .medium])
                // Add instance of view model to the environment
                .environment(RemindersListViewModel())

        }
}

// When it is an existing reminder being edited
#Preview {
    
    @Previewable @State var presentingNewReminderSheet = true
    @Previewable @State var currentReminder: Reminder? = Reminder(
        id: UUID(),
        title: "Have a nap",
        done: false
    )
    
    Rectangle()
        .ignoresSafeArea()
        .foregroundStyle(.orange)
        .overlay {
            Text("View the sheet is connected to")
        }
        .sheet(isPresented: $presentingNewReminderSheet) {
            EditReminderView(
                currentReminder: $currentReminder,
                showSheet: $presentingNewReminderSheet
            )
                // Control size of the sheet when it slides up
                .presentationDetents([.fraction(0.15), .medium])
                // Add instance of view model to the environment
                .environment(RemindersListViewModel())

        }
}


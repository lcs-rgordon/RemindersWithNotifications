//
//  SetReminderView.swift
//  RemindersWithNotifications
//
//  Created by Russell Gordon on 2025-05-17.
//

import SwiftUI

struct SetReminderView: View {
    
    // MARK: Stored properties
    
    // The reminder sent for editing
    @Binding var reminder: Reminder?
    
    // The reminder's title
    @State private var title = ""
    
    // Whether to be notified
    @State private var withNotification: Bool = false
    
    // Date for notification to appear
    @State private var notificationDate = Date()
    
    // The reminder's notification, if it exists
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
                
                TextField("Enter a reminder", text: $title)
                    .textFieldStyle(.roundedBorder)
                
                Toggle("Notification?", isOn: $withNotification)
                
                DatePicker(selection: $notificationDate, in: Date.now...) {
                    Text("At:")
                }
                .disabled(withNotification == false)
                                
                Button(editingExistingReminder ? "Save" : "Add") {
                    
                    if !editingExistingReminder {
                        
                        // Add reminder
                        if withNotification {
                            
                            viewModel.createReminder(
                                withTitle: title,
                                notification: Notification(
                                    id: UUID(),
                                    scheduledFor: notificationDate
                                )
                            )

                        } else {
                            viewModel.createReminder(withTitle: title)
                        }
                        
                        // Reset input fields
                        title = ""
                        withNotification = false
                        notificationDate = Date()
                    } else {
                        
                        // Save the changes to the existing reminder
                        reminder!.title = title
                        
                        // TODO: Handle updating notifications
                        // 1. Could have not had notification, now it does
                        // 2. Could be editing existing notification
                        // 3. Could be removing existing notification
                        
                    }
                    
                }
                .buttonStyle(.borderedProminent)
                .disabled(
                    title
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .isEmpty == true
                )

            }
            .padding(20)
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        showSheet = false
                        reminder = nil
                    } label: {
                        Text("Done")
                            .bold()
                    }
                    
                }
            }
            .onAppear {
                // Populate sheet with existing reminder if one was supplied
                if let currentReminder = reminder {
                    editingExistingReminder = true
                    title = currentReminder.title
                    notification = currentReminder.notification
                    if let notification = notification {
                        withNotification = true
                        notificationDate = currentReminder.notification.scheduledFor
                    } else {
                        withNotification = false
                        notificationDate = Date()
                    }
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
            SetReminderView(
                reminder: $currentReminder,
                showSheet: $presentingNewReminderSheet
            )
                // Control size of the sheet when it slides up
                .presentationDetents([.fraction(0.35), .medium])
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
            SetReminderView(
                reminder: $currentReminder,
                showSheet: $presentingNewReminderSheet
            )
                // Control size of the sheet when it slides up
                .presentationDetents([.fraction(0.35), .medium])
                // Add instance of view model to the environment
                .environment(RemindersListViewModel())

        }
}


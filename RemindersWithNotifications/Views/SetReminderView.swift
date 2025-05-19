//
//  SetReminderView.swift
//  RemindersWithNotifications
//
//  Created by Russell Gordon on 2025-05-17.
//

import OSLog
import SwiftUI

struct SetReminderView: View {
    
    // MARK: Stored properties
    
    // The reminder sent for editing
    @Binding var reminder: Reminder?
    
    // The reminder's title
    @State private var title = ""
    
    // Whether to be notified
    @State private var withNotification: Bool = false
    
    // Whether the reminder PREVIOUSLY had a notification
    @State private var hadPriorNotification: Bool = false
    
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
                    setReminder()
                }
                .buttonStyle(.borderedProminent)
                // Don't allow reminder to be saved or added when it is empty
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
                        Logger.viewCycle.info("SetReminderView: Closing sheet ('Done' was pressed).")
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
                Logger.viewCycle.info("SetReminderView: View is appearing.")
                if let currentReminder = reminder {
                    Logger.viewCycle.info("SetReminderView: Existing reminder is being edited.")
                    editingExistingReminder = true
                    title = currentReminder.title
                    notification = currentReminder.notification
                    if let notification = notification {
                        Logger.viewCycle.info("SetReminderView: Existing reminder had a notification scheduled.")
                        withNotification = true
                        hadPriorNotification = true
                        notificationDate = notification.scheduledFor
                    } else {
                        Logger.viewCycle.info("SetReminderView: Existing reminder did not have a notification.")
                        notificationDate = Date()
                    }
                } else {
                    Logger.viewCycle.info("SetReminderView: New reminder will be created.")
                }
            }
        }


    }
    
    // MARK: Function(s)
    func setReminder() {
        if !editingExistingReminder {
            
            // Add reminder
            if withNotification {

                Logger.viewCycle.info("SetReminderView: About to create NEW reminder with a notification.")

                viewModel.createReminder(
                    withTitle: title,
                    notification: Notification(
                        id: UUID(),
                        scheduledFor: notificationDate
                    )
                )

            } else {

                Logger.viewCycle.info("SetReminderView: About to create NEW reminder without a notification.")

                viewModel.createReminder(withTitle: title)
            }
            
            // Reset input fields
            title = ""
            withNotification = false
            notificationDate = Date()
        } else {
            
            // Save the changes to the existing reminder's title
            reminder!.title = title
            
            Logger.viewCycle.info("SetReminderView: Updating existing reminder.")
            
            // TODO: Handle updating notifications
            // 1. Could have not had notification, now it does
            // 2. Could be editing existing notification
            // 3. Could be removing existing notification
            if !hadPriorNotification {
                
                Logger.viewCycle.info("SetReminderView: Existing reminder did NOT previously have a notification.")
                
                // 1. Adding new notification
                Logger.viewCycle.info("SetReminderView: About to schedule NEW notification.")

            } else {
                
                Logger.viewCycle.info("SetReminderView: Existing reminder previously had a notification.")

                if withNotification {
                    
                    // 2. Editing existing notification
                    Logger.viewCycle.info("SetReminderView: We are editing details of existing notification.")

                } else {

                    // 3. Removing existing notification
                    Logger.viewCycle.info("SetReminderView: We are removing notification.")
                    
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


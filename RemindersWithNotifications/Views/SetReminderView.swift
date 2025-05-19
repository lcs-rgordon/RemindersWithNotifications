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
    
    // Access the view model through the environment
    @Environment(RemindersListViewModel.self) var viewModel
        
    // The reminder sent for editing (occurs when user clicks the notification bell)
    @Binding var reminder: Reminder?
    
    // The reminder's title
    @State private var title = ""
    
    // Whether user has asked for a notification to go along with this reminder
    @State private var withNotification: Bool = false
    
    // Whether the reminder PREVIOUSLY had a notification
    @State private var hadPriorNotification: Bool = false
    
    // Date for notification to appear
    @State private var notificationDate = Date()
    
    // Access the controller that handles adding, editing, or removing notifications
    @Environment(NotificationController.self) var notificationContoller
    
    // Whether we are editing an existing reminder
    @State private var editingExistingReminder = false
    
    // Determines whether an error message displaying a problem creating
    // a notification is showing or not
    @State private var showingNotificationsError = false
    
    // Makes it possible to open the Settings page for this app to allow user to enable notifications, if necessary
    @Environment(\.openURL) var openURL
    
    // Binding to control whether this sheet is visible or not
    @Binding var showSheet: Bool
    
    // MARK: Computed properties
    var body: some View {
        NavigationView {
            VStack {
                
                TextField("Enter a reminder", text: $title)
                    .textFieldStyle(.roundedBorder)
                
                Toggle("Receive notification?", isOn: $withNotification.animation())

                if withNotification {
                    DatePicker(selection: $notificationDate, in: Date.now...) {
                        Text("At:")
                    }
                }
                                
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

                Spacer()
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
            // Shows if we are not authorized to create notifications
            .alert("Oops!", isPresented: $showingNotificationsError) {
                Button("Check Settings", action: showAppSettings)
                Button("Cancel", role: .cancel) {
                    // Does nothing right now
                }
            } message: {
                Text("There was a problem creating a notification for this reminder. Please check that you have allowed notifications from this app.")
            }
            // Populate sheet with existing reminder (if one was supplied)
            .onAppear {
                Logger.viewCycle.info("SetReminderView: View is appearing.")
                if let currentReminder = reminder {
                    Logger.viewCycle.info("SetReminderView: Existing reminder is being edited.")
                    editingExistingReminder = true
                    title = currentReminder.title
                    if let notification = currentReminder.notification {
                        Logger.viewCycle.info("SetReminderView: Existing reminder has a notification scheduled.")
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

                let newlyCreatedReminder = viewModel.createReminder(
                    withTitle: title,
                    andNotificationAt: notificationDate
                )
                
                Logger.viewCycle.info("SetReminderView: New reminder created, now about to try scheduling its notification.")
                
                // Try to create the notification for this reminder
                updateNotificationFor(existingReminder: newlyCreatedReminder)

            } else {

                Logger.viewCycle.info("SetReminderView: About to create NEW reminder without a notification.")

                let _ = viewModel.createReminder(withTitle: title)

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
                reminder!.notification = Notification(scheduledFor: notificationDate)
                updateNotificationFor(existingReminder: reminder!)

            } else {
                
                Logger.viewCycle.info("SetReminderView: Existing reminder previously had a notification.")

                if withNotification {
                    
                    // 2. Editing existing notification
                    Logger.viewCycle.info("SetReminderView: We are editing details of existing notification.")
                    updateNotificationFor(existingReminder: reminder!)

                } else {

                    // 3. Removing existing notification
                    Logger.viewCycle.info("SetReminderView: We are removing notification.")
                    
                    // First remove any notification(s) that exist for this reminder
                    notificationContoller.removeNotifications(for: reminder!)
                    reminder!.notification = nil

                }
                
            }
            
        }

    }
    
    // Shows the app's setting page, if requested by the user
    func showAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openNotificationSettingsURLString) else {
            return
        }
        
        openURL(settingsURL)
    }
    
    // Handles updating or creating a notification for a given reminder
    func updateNotificationFor(existingReminder: Reminder) {
        
        // First remove any notification(s) that exist for this reminder
        notificationContoller.removeNotifications(for: existingReminder)
        
        // Try to create the notification for this reminder
        Task {
            
            let success = await notificationContoller.addNotification(for: existingReminder)
            
            if success {
                Logger.viewCycle.info("SetReminderView: Successfully updated notification.")
                existingReminder.notification!.successfullyCreated = true
                showingNotificationsError = false
            } else {
                Logger.viewCycle.info("SetReminderView: Unable to update notification.")
                existingReminder.notification!.successfullyCreated = false
                showingNotificationsError = true
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
                // Add instance of the notification controller class to the environment
                .environment(NotificationController())

        }
}

// When it is an existing reminder being edited
#Preview {
    
    @Previewable @State var presentingNewReminderSheet = true
    @Previewable @State var currentReminder: Reminder? = Reminder(
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
                // Add instance of the notification controller class to the environment
                .environment(NotificationController())

        }
}


//
//  NewItemView.swift
//  RemindersWithNotifications
//
//  Created by Russell Gordon on 2025-05-17.
//

import SwiftUI

struct NewReminderView: View {
    
    // MARK: Stored properties
    
    // The item currently being added
    @State var title = ""
    
    // Access the view model through the environment
    @Environment(RemindersListViewModel.self) var viewModel
    
    // Binding to control whether this sheet
    @Binding var showSheet: Bool
    
    // MARK: Computed properties
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Enter a reminder", text: $title)
                    
                    Button("Add") {
                        // Add reminder
                        viewModel.createReminder(withTitle: title)
                        
                        // Clear the input field
                        title = ""
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
                    } label: {
                        Text("Done")
                            .bold()
                    }
                    
                }
            }
        }


    }
    
}

#Preview {
    
    @Previewable @State var presentingNewReminderSheet = true
    
    Rectangle()
        .ignoresSafeArea()
        .foregroundStyle(.orange)
        .overlay {
            Text("View the sheet is connected to")
        }
        .sheet(isPresented: $presentingNewReminderSheet) {
            NewReminderView(showSheet: $presentingNewReminderSheet)
                // Control size of the sheet when it slides up
                .presentationDetents([.fraction(0.15), .medium])
                // Add instance of view model to the environment
                .environment(RemindersListViewModel())

        }
}

//
//  AccountView.swift
//  Summits
//
//  Created by Nick on 10/13/23.
//

import SwiftUI

struct AccountView: View {
    @Environment(\.modelContext) private var modelContext

    @State var confirmResetVisible = false
    
    func resetData() {
        confirmResetVisible = false
        do {
            try modelContext.delete(model: Hike.self)
        } catch {
            print("Failed to reset Hike data.")
        }
    }
    
    var body: some View {
        Form {
            Section {
                Text("Developed by Nick Schaefer")
                Link(destination: URL(string: "https://www.nschaefer.com/")!, label: {
                    Text("nschaefer.com")
                })
                Link(destination: URL(string: "https://github.com/naturalnick/Summits/blob/main/Privacy%20Policy")!, label: {
                    Text("Privacy Policy")
                })
                ShareLink("Share App", item: URL(string: "https://apps.apple.com/us/app/white-mountain-4000ft-tracker/id6476589208")!)
            } header: {
                Text("About")
            }

            Section {
                Button(role: .destructive, action: {
                    confirmResetVisible = true
                }, label: {
                    Text("Clear Hike Data")
                })
            } header: {
                Text("Actions")
            }
        }
        .navigationTitle("Settings")
        .confirmationDialog("Confirm Clear Hike Data", isPresented: $confirmResetVisible, titleVisibility: .visible) {
            Button(role: .destructive, action: {
                resetData()
            }, label: {
                Text("Clear Data")
            })
        } message: {
           Text("This action cannot be undone.")
        }
    }
}

#Preview {
    NavigationStack {
        AccountView()
    }
}

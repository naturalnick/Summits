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
                Label("A summit hiking log for tracking hikes of the New Hampshire 4000 foot mountains", systemImage: "mountain.2.circle")
                Label("Developed by Nick Schaefer", systemImage: "person.fill")
                Link(destination: URL(string: "https://www.nschaefer.com/")!, label: {
                    Label("www.nschaefer.com", systemImage: "globe")
                })
            }

            Section {
                Link(destination: URL(string: "https://github.com/naturalnick/Summits/blob/main/Privacy%20Policy")!, label: {
                    Label("Privacy Policy", systemImage: "lock.circle")
                })
                ShareLink("Share App", item: URL(string: "https://apps.apple.com/us/app/white-mountain-4000ft-tracker/id6476589208")!)
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
        .navigationTitle("About")
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

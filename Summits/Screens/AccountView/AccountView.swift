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
                    Text("www.nschaefer.com")
                })
//                Button(action: {}, label: {
//                    Label("Share App", systemImage: "square.and.arrow.up")
//                })
            } header: {
                Text("About")
            }
            
            Section {
                Button(role: .destructive, action: {
                    confirmResetVisible = true
                }, label: {
                    Text("Clear Hike Data")
                })
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

//
//  EmptyState.swift
//  Summits
//
//  Created by Nick on 10/13/23.
//

import SwiftUI

struct EmptyState: View {
    let imageName: String
    let message: String
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea(edges: .all)
            
            VStack {
                Image(systemName: "figure.hiking")
                    .font(.system(size: 80))
                    .foregroundColor(.secondary)
                Text(message)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
        .padding()
    }
}

#Preview {
    EmptyState(imageName: "checklist.checked", message: "This is a placeholder.")
}

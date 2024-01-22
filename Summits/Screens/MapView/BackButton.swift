//
//  BackButton.swift
//  Summits
//
//  Created by Nick Schaefer on 1/22/24.
//

import SwiftUI

struct BackButton: View {
    @Environment(\.dismiss) var dismiss
    
    func navigateBack() {
        dismiss()
    }
    
    var body: some View {
        Button(action: {
            navigateBack()
        }, label: {
            Image(systemName: "arrow.left")
                .padding()
                .foregroundStyle(.black)
                .background(Circle().fill(.white).shadow(radius: 10))
        })
        .offset(y: 30)
    }
}

#Preview {
    BackButton()
}

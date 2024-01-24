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
                .font(.system(size: 20))
                .frame(width: 50, height: 50)
                .foregroundStyle(.black)
                .background(Circle().fill(.thickMaterial).shadow(radius: 10))
        })
        .offset(y: 30)
    }
}

#Preview {
    BackButton()
}

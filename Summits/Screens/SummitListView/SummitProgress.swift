//
//  ProgressView.swift
//  Summits
//
//  Created by Nick Schaefer on 2/23/25.
//

import SwiftUI

let maxSummits: Int = 48

struct SummitProgress: View {
    var progress: Int
    var body: some View {
        Text("\(progress) / \(maxSummits)")
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 3)
            .padding(.horizontal, 10)
            .background(
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color("Emerald").opacity(0.6))
                            .frame(maxWidth: geometry.size.width * (Double(progress) / Double(maxSummits)))
                            .padding(.horizontal, 1)
                        
                        RoundedRectangle(cornerRadius: 10.0)
                            .strokeBorder(Color.primary.opacity(0.3), lineWidth: 1)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                }
            )
            .padding(.horizontal, 8)
    }
}

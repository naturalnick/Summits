//
//  Rating.swift
//  Summits
//
//  Created by Nick Schaefer on 1/22/24.
//

import SwiftUI

struct Rating: View {
    @Binding var rating: Int
    var disabled: Bool
    
    var body: some View {
        HStack {
            ForEach(1..<6, id: \.self) { num in
                Image(systemName: "star.fill")
                    .foregroundStyle(num <= rating ? .yellow : .gray)
                    .onTapGesture {
                        if (!disabled) {
                            rating = num
                        }
                    }
            }
        }
    }
}

#Preview {
    Rating(rating: .constant(4), disabled: true)
}

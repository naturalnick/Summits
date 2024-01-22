//
//  HikeDetailView.swift
//  Summits
//
//  Created by Nick Schaefer on 1/21/24.
//

import SwiftUI

struct HikeDetailView: View {
    var hike: Hike
    
    var body: some View {
        VStack {
            HStack {
                Text("Hiked \(formatDate(date: hike.date))")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.headline)
                RatingView(rating: .constant(hike.rating), disabled: true)
            }
            
            if !hike.weather.isEmpty {
                Text("Weather: \(hike.weather)")
                    .underline()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
            }
            
            if !hike.companions.isEmpty {
                Text("Companions: \(hike.companions)")
                    .underline()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
            }
            
            if !hike.details.isEmpty {
                Text("Details: \(hike.details)")
                    .underline()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 12).foregroundStyle( Color(#colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9215686275, alpha: 1))))
        .foregroundStyle(.black)
    }
}

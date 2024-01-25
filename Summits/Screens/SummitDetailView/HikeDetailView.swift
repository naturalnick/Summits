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
            if !hike.images.isEmpty, let uiImage = UIImage(data: hike.images[0]) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: 300)
                    .clipShape(UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 10, topTrailing: 10)))
            }
            
            VStack (alignment: .leading) {
                HStack {
                    Text("Hiked \(formatDate(date: hike.date))")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.headline)
                    Rating(rating: .constant(hike.rating), disabled: true)
                }
                .padding(.bottom, 5)
                
                if !hike.companions.isEmpty {
                    HStack (alignment: .top) {
                        Text("With: ")
                            .underline()
                        Text(hike.companions)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                if !hike.weather.isEmpty {
                    HStack (alignment: .top) {
                        Text("Weather: ")
                            .underline()
                        Text(hike.weather)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                
                if !hike.details.isEmpty {
                    HStack (alignment: .top) {
                        Text("Details: ")
                            .underline()
                        Text(hike.details)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .multilineTextAlignment(.leading)
            .padding(.top, hike.images.isEmpty ? 12 : 5)
            .padding([.horizontal, .bottom])
        }
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 12).foregroundStyle( Color(#colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9215686275, alpha: 1))))
        .foregroundStyle(.black)
    }
}

//#Preview {
//    List {
//        HikeDetailView(hike: Hike(summitID: "0", date: Date(), rating: 4, weather: "Sunny", companions: "None", details: "Details", images: []))
//    }
//}

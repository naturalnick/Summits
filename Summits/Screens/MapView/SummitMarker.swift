//
//  SummitMarker.swift
//  Summits
//
//  Created by Nick Schaefer on 1/22/24.
//

import SwiftUI

struct SummitMarker: View {
    var summit: Summit
    @Binding var selectedSummit: Summit?
    var hikes: [Hike]
    
    func getPinColor(summitID: String) -> Color {
        return hikes.contains(where: { $0.summitID == summitID }) ? .green : .red
    }
    
    func getPinBorderColor(summitID: String) -> Color {
        guard let selectedSummit else { return .black }
        
        return summitID == selectedSummit.id ? .white : .black
    }
    
    var body: some View {
        Image(systemName: "mountain.2.circle.fill")
            .font(.title)
            .foregroundColor(getPinColor(summitID: summit.id))
            .background(
                Circle()
                    .fill(getPinBorderColor(summitID: summit.id))
            )
            .onTapGesture {
                selectedSummit = summit
            }
    }
}

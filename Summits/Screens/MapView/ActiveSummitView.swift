//
//  ActiveSummitView.swift
//  Summits
//
//  Created by Nick Schaefer on 1/22/24.
//

import SwiftUI
import MapKit

struct ActiveSummitView: View {
    @State private var isZoomed: Bool = false
    var selectedSummit: Summit
    var summits: [Summit]
    @Binding var cameraPosition: MapCameraPosition
    
    var body: some View {
        HStack {
            VStack(alignment: .leading){
                Text(selectedSummit.name)
                    .font(.title2)
                Text("\(selectedSummit.elevationFt) ft")
                    .font(.title3)
            }
            .padding(.leading, 10)
            Spacer()
            if !isZoomed {
                Button {
                    isZoomed = true
                    withAnimation {
                        cameraPosition = .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: selectedSummit.geolocation.latitude, longitude: selectedSummit.geolocation.longitude), distance: 40000))
                    }
                } label: {
                    Text("Zoom")
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .foregroundStyle(.blue)
                        .background(RoundedRectangle(cornerRadius: 10)
                            .fill(.ultraThinMaterial)
                        )
                }
            }
            
            NavigationLink {
                SummitDetailView(summits: summits, summit: selectedSummit)
            } label: {
                Text("Open")
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .foregroundStyle(.white)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(.blue)
                    )
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10)
            .fill(.ultraThinMaterial)
        )
        .onChange(of: cameraPosition) { oldValue, newValue in
            if newValue.positionedByUser {
                isZoomed = false
            }
        }
    }
}

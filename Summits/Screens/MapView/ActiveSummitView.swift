//
//  ActiveSummitView.swift
//  Summits
//
//  Created by Nick Schaefer on 1/22/24.
//

import SwiftUI
import MapKit

struct ActiveSummitView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var isZoomed: Bool = false
    var selectedSummit: Summit
    var currentSummit: Summit?
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
                    Image(systemName: "scope")
                        .font(.system(size: 20))
                        .frame(width: 50, height: 50)
                        .background(
                            Circle()
                                .fill(.ultraThinMaterial)
                        )
                }
            }
            
            if let currentSummit, selectedSummit.id == currentSummit.id {
                Button(action: {
                    dismiss()
                }, label: {
                    SummitButton()
                })
            } else {
                NavigationLink {
                    SummitDetailView(summit: selectedSummit)
                } label: {
                    SummitButton()
                }
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

struct SummitButton: View {
    var body: some View {
        Image(systemName: "arrowshape.turn.up.right.fill")
            .font(.system(size: 20))
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .fill(.ultraThinMaterial)
            )
    }
}

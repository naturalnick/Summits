//
//  MapView.swift
//  Summits
//
//  Created by Nick on 10/2/23.
//

import SwiftUI
import SwiftData
import MapKit

struct MapView: View {
    @Query var hikes: [Hike]
    
    @State private var summits: [Summit] = []
    @State private var selectedSummit: Summit?
    @State private var cameraPosition: MapCameraPosition = .automatic
    
    var currentSummit: Summit?
    
    func loadSummits() {
        do {
            let summits = try getSummits()
            self.summits = summits
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        ZStack {
            if !summits.isEmpty {
                Map(position: $cameraPosition) {
                    ForEach(summits) { summit in
                        Annotation(summit.name, coordinate: CLLocationCoordinate2D(latitude: summit.geolocation.latitude, longitude: summit.geolocation.longitude)) {
                            SummitMarker(summit: summit, selectedSummit: $selectedSummit, hikes: hikes)
                        }
                    }
                }
                .mapControlVisibility(.visible)
                .mapStyle(.hybrid())
            }
            VStack {
                HStack {
                    BackButton()
                    Spacer()
                }
                
                Spacer()
                
                if let selectedSummit{
                    ActiveSummitView(selectedSummit: selectedSummit, currentSummit: currentSummit, summits: summits, cameraPosition: $cameraPosition)
                }
            }
            .padding()
            .padding(.bottom, 10) // to not hide Apple Maps logo
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear(perform: {
            loadSummits()
            
            if let currentSummit {
                selectedSummit = currentSummit
            }
        })
    }
}

#Preview {
    MapView(currentSummit: Summit(id: "0", name: "Washington", elevationFt: 6288, range: "Presidential Range", prominenceFt: 5288, geolocation: Geolocation(latitude: 71.3034, longitude: 44.2704), state: "New Hampshire"))
}

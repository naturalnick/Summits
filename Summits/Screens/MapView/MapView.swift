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
    
    var summits: [Summit]
    var currentSummit: Summit
    
    @State var selectedSummit: Summit?
    @State private var cameraPosition: MapCameraPosition = .automatic
    
    var body: some View {
        ZStack {
            Map(position: $cameraPosition) {
                ForEach(summits) { summit in
                    Annotation(summit.name, coordinate: CLLocationCoordinate2D(latitude: summit.geolocation.latitude, longitude: summit.geolocation.longitude)) {
                        SummitMarker(summit: summit, selectedSummit: $selectedSummit, hikes: hikes)
                    }
                }
            }
            .mapControlVisibility(.visible)
            .mapStyle(.hybrid())
            
            VStack {
                HStack {
                    BackButton()
                    Spacer()
                }
                
                Spacer()
                
                if let selectedSummit {
                    ActiveSummitView(selectedSummit: selectedSummit, summits: summits, cameraPosition: $cameraPosition)
                }
            }
            .padding()
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear(perform: {
            selectedSummit = currentSummit
        })
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(summits: [Summit(id: "0", name: "Washington", elevationFt: 6288, range: "Presidential Range", prominenceFt: 5288, geolocation: Geolocation(latitude: 71.3034, longitude: 44.2704), state: "New Hampshire")], currentSummit: Summit(id: "0", name: "Washington", elevationFt: 6288, range: "Presidential Range", prominenceFt: 5288, geolocation: Geolocation(latitude: 71.3034, longitude: 44.2704), state: "New Hampshire"))
    }
}

//
//  SummitDetailView.swift
//  Summits
//
//  Created by Nick on 10/7/23.
//

import SwiftUI
import SwiftData

struct SummitDetailView: View {
    @Environment(\.modelContext) private var modelContext
    
    let summits: [Summit]
    let summit: Summit
    
    @State var hikes: [Hike]?
    @State var currentHike: Hike? = nil
    @State private var hikeLogVisible: Bool = false
    
    func getHikes(summitID: String) {
        do {
            let descriptor = FetchDescriptor<Hike>(predicate: #Predicate { hike in
                hike.summitID == summitID
            })
            let hikes = try modelContext.fetch(descriptor)
            self.hikes = hikes
        } catch {
            print("Failed to fetch hikes.")
        }
    }
    
    var body: some View {
        ScrollView {
            Details(summit: summit)
            
            NavigationLink {
                MapView(summits: summits, currentSummit: summit)
            } label: {
                Label("View on Map", systemImage: "location.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            
            if let hikes {
                Button(action: {
                    let newHike = Hike(summitID: summit.id, date: Date(), rating: 5, weather: "", companions: "", details: "")
                    modelContext.insert(newHike)
                    currentHike = newHike
                    hikeLogVisible = true
                }, label: {
                    Label(hikes.isEmpty ? "Mark as Complete" : "Add Another Hike", systemImage: "checkmark")
                        .frame(maxWidth: .infinity)
                })
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                
                ForEach(hikes) { hike in
                    Button(action: {
                        currentHike = hike
                        hikeLogVisible = true
                    }, label: {
                        HikeDetailView(hike: hike)
                            .allowsHitTesting(false)
                    })
                }
            }
        }
        .padding()
        .navigationTitle(summit.name)
        .sheet(isPresented: $hikeLogVisible) { [currentHike] in
            if currentHike != nil {
                HikeLogView(summit: summit, currentHike: currentHike!, hikeLogVisible: $hikeLogVisible)
            }
        }
        .onAppear(perform: {
            getHikes(summitID: summit.id)
        })
        .onChange(of: hikeLogVisible) { oldValue, newValue in
            if newValue == false {
                getHikes(summitID: summit.id)
            }
        }
    }
}

struct Details: View {
    let summit: Summit
    
    var body: some View {
        VStack {
            Text(summit.range)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(summit.state)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom)
            
            HStack {
                VStack {
                    Text("Elevation:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(summit.elevationFt) ft")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title)
                }
                
                VStack {
                    Text("Prominence:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(summit.prominenceFt) ft")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title)
                }
            }
        }
    }
}

//#Preview {
//    SummitDetailView(summit: MockData.sampleSummit, hikes: [Hike(summitID: "0", date: Date(), rating: 5, weather: "Sunny", companions: "", details: "Fun times")])
//}

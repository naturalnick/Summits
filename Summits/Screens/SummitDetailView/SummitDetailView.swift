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
    
    func addHike() {
        let newHike = Hike(summitID: summit.id, date: Date(), rating: 5, weather: "", companions: "", details: "")
        modelContext.insert(newHike)
        currentHike = newHike
        hikeLogVisible = true
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let hikes, !hikes.isEmpty {
                    VStack {
                        Image(systemName: "checkmark.seal")
                            .font(.system(size: 100))
                            .position(x: geometry.size.width - 160, y: -80)
                            .rotationEffect(Angle(degrees: 15))
                            .foregroundStyle(Color("Emerald"))
                            .opacity(0.5)
                    }
                }
                VStack {
                    HStack {
                        VStack {
                            Text(summit.range)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(summit.state)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Spacer()
                        
                        NavigationLink {
                            MapView(currentSummit: summit)
                        } label: {
                            Image(systemName: "location.fill")
                                .font(.system(size: 20))
                                .frame(width: 50, height: 50)
                                .foregroundStyle(Color("AmcRed"))
                                .background(
                                    Circle()
                                        .fill(.white)
                                        .shadow(color: Color("LightestGray"), radius: 6)
                                )
                        }
                    }
                    
                    DetailView(summit: summit)
                    
                    Button(action: {
                        addHike()
                    }, label: {
                        Label(hikes != nil && hikes!.isEmpty ? "Mark as Complete" : "Add Another Hike", systemImage: "checkmark")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundStyle(.white)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color("Emerald")))
                    })
                    
                    ScrollView {
                        if let hikes {
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
                }
            }
        }
        .padding()
        .navigationTitle(summit.name)
        .navigationBarTitleDisplayMode(.large)
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

struct DetailView: View {
    let summit: Summit
    
    var body: some View {
        VStack {
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

#Preview {
    NavigationStack {
        SummitDetailView(summit: MockData.sampleSummit, hikes: [])
    }
    .modelContainer(for: Hike.self)
}

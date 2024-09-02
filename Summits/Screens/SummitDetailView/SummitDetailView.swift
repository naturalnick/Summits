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
    @State private var hikeLogVisible = false
    
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
        let newHike = Hike(
            summitID: summit.id,
            date: .now,
            rating: 5,
            weather: "",
            companions: "",
            details: ""
        )
        modelContext.insert(newHike)
        currentHike = newHike
        hikeLogVisible = true
    }
    
    var body: some View {
        VStack(spacing: 0) {
            header
            list
        }
        .scrollContentBackground(.hidden)
        .overlay {
            GeometryReader { geometry in
                if let hikes, !hikes.isEmpty {
                    Image(systemName: "checkmark.seal")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                        .position(x: geometry.size.width - 180, y: -70)
                        .rotationEffect(Angle(degrees: 15))
                        .foregroundStyle(Color("Emerald"))
                        .opacity(0.5)
                }
            }
        }
        .foregroundStyle(.primary)
        .navigationTitle(summit.name)
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $hikeLogVisible) { [currentHike] in
            if currentHike != nil {
                HikeLogView(
                    summit: summit,
                    currentHike: currentHike!,
                    hikeLogVisible: $hikeLogVisible
                )
            }
        }
        .onAppear {
            getHikes(summitID: summit.id)
        }
        .onChange(of: hikeLogVisible) { oldValue, newValue in
            if newValue == false {
                getHikes(summitID: summit.id)
            }
        }
    }
    
    private var header: some View {
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
                    Image(systemName: "location.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                        .foregroundStyle(.blue, Color(.systemBackground))
                        .shadow(color: Color("LightestGray"), radius: 6)
                }
            }
            
            ElevationView(summit: summit)
            
            Button {
                addHike()
            } label: {
                Label(
                    hikes != nil && hikes!.isEmpty ? "Mark as Complete" : "Add Another Hike",
                    systemImage: "checkmark"
                )
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(.emerald)
            .foregroundStyle(.white)
        }
        .padding(.horizontal)
    }
    
    private var list: some View {
        List {
            if let hikes {
                ForEach(hikes) { hike in
                    Button {
                        currentHike = hike
                        hikeLogVisible = true
                    } label: {
                        HikeDetailView(hike: hike)
                            .allowsHitTesting(false)
                    }
                    .listRowBackground(Color(.tertiarySystemGroupedBackground))
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SummitDetailView(
            summit: .washington, 
            hikes: []
        )
    }
    .modelContainer(for: Hike.self)
}

//
//  SummitsListView.swift
//  Summits
//
//  Created by Nick on 10/2/23.
//

import SwiftUI
import SwiftData

struct SummitsListView: View {
    @StateObject var viewModel = SummitListViewModel()
    var appearance = UIToolbarAppearance()
    
    @Query private var hikes: [Hike]
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollViewReader { scrollProxy in
                    VStack {
                        if viewModel.filterShown {
                            SummitListFilter(hikes: hikes, filteredSummits: viewModel.filteredSummits, filterSummits: viewModel.filterSummits, sortSummits: viewModel.sortSummits)
                        }
                        
                    }
                    List {
                        ForEach(Array(viewModel.filteredSummits.enumerated()), id: \.element.id) { index, summit in
                            NavigationLink {
                                SummitDetailView(summit: summit)
                            } label: {
                                SummitListCell(summit: summit, index: index, hiked: hikes.filter { $0.summitID == summit.id }.count > 0)
                            }
                            .id(summit.name)
                        }
                        
                        if viewModel.filteredSummits.isEmpty {
                            EmptyState(imageName: "checklist.checked", message: "No summits for this filter")
                        }
                    }
                }
                .listStyle(.plain)
                .navigationBarTitleDisplayMode(.large)
                .navigationTitle("White Mountain 48")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        NavigationLink {
                            AccountView()
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .foregroundStyle(.gray)
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            withAnimation {
                                viewModel.filterShown.toggle()
                            }
                        } label: {
                            Image(systemName: viewModel.filterShown ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                                .foregroundStyle(.gray)
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            MapView()
                        } label: {
                            Image(systemName: "map.fill")
                                .foregroundStyle(.gray)
                        }
                    }
                }
            }
            
        }
        .onAppear {
            viewModel.loadSummits()
            appearance.backgroundColor = UIColor(Color("AmcRed"))
        }
        .alert(isPresented: viewModel.alertShown, error: viewModel.alertError, actions: { error in
            // buttons
        }, message: { error in
            if let message = error.errorMessage {
                Text(message)
            }
        })
    }
}

#Preview {
    SummitsListView()
}

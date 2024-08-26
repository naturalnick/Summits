//
//  SummitsListView.swift
//  Summits
//
//  Created by Nick on 10/2/23.
//

import SwiftUI
import SwiftData

struct SummitsListView: View {
    var viewModel = SummitListViewModel()
    
    @Query private var hikes: [Hike]
    @State var isMapViewLoading = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack {
                    List {
                        if viewModel.filterShown {
                            SummitListFilter(hikes: hikes, filteredSummits: viewModel.filteredSummits, filterSummits: viewModel.filterSummits, sortSummits: viewModel.sortSummits)
                        }
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
                .navigationTitle("New Hampshire 48")
                .toolbar {
                    SummitListToolbar(viewModel: viewModel)
                }
            }
            
        }
        .onAppear {
            viewModel.loadSummits()
            viewModel.updateProgress(hikes: hikes)
        }
        .onChange(of: hikes, { _, _ in
            print("changed")
            viewModel.updateProgress(hikes: hikes)
        })
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
        .modelContainer(for: Hike.self)
}

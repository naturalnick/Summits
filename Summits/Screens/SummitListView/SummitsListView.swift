//
//  SummitsListView.swift
//  Summits
//
//  Created by Nick on 10/2/23.
//

import SwiftUI
import SwiftData

struct SummitsListView: View {
    @State var viewModel = SummitListViewModel()
    
    @Query private var hikes: [Hike]
    @State var isMapViewLoading = false
    @State private var exportFeatureAlertVisible = false
    
func checkForExportFeatureAlert() {
        let hasSeenExportAlert = UserDefaults.standard.bool(forKey: "hasSeenExportAlert")
        if !hasSeenExportAlert {
            exportFeatureAlertVisible = true
            UserDefaults.standard.set(true, forKey: "hasSeenExportAlert")
        }
    }

    var body: some View {
        NavigationStack {
            List {
                if viewModel.filterShown {
                    SummitListFilter(
                        filter: $viewModel.filter,
                        sort: $viewModel.sort,
                        showSort:  !viewModel.filteredSummits.isEmpty
                    )
                }
                if let progress = viewModel.progress, !viewModel.filterShown {
                    SummitProgress(progress: progress.0)
                        .listRowSeparator(.hidden)
                }
                ForEach(Array(viewModel.filteredSummits.enumerated()), id: \.element.id) { index, summit in
                    NavigationLink {
                        SummitDetailView(summit: summit)
                    } label: {
                        SummitListCell(
                            summit: summit,
                            index: index,
                            hiked: hikes.filter { $0.summitID == summit.id }.count > 0
                        )
                    }
                    .id(summit.name)
                }
                
                if viewModel.filteredSummits.isEmpty {
                    EmptyState(
                        imageName: "checklist.checked",
                        message: "No summits for this filter"
                    )
                }
            }
            .animation(.default, value: viewModel.sort)
            .animation(.default, value: viewModel.filter)
            .animation(.default, value: viewModel.searchText)
            .listStyle(.plain)
            .searchable(text: $viewModel.searchText)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("New Hampshire 48")
            .toolbar {
                SummitListToolbar(filterShown: $viewModel.filterShown)
            }
            
        }
        .onAppear {
            viewModel.hikes = hikes
            viewModel.loadSummits()
            viewModel.updateProgress(hikes: hikes)
            checkForExportFeatureAlert()
        }
        .onChange(of: hikes, { _, _ in
            viewModel.updateProgress(hikes: hikes)
        })
        .alert(isPresented: viewModel.alertShown, error: viewModel.alertError, actions: { error in
            // buttons
        }, message: { error in
            if let message = error.errorMessage {
                Text(message)
            }
        })
        .alert("New Feature: Export Your Hikes", isPresented: $exportFeatureAlertVisible) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("You can now export your hiking data directly into the 4000 Footer Club Application! \n\nJust go to\nSettings > Export Hike Data.")
        }
    }
}

#Preview {
    SummitsListView()
        .modelContainer(for: Hike.self)
}

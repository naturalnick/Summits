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
    
    @Query private var hikes: [Hike]
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { scrollProxy in
                List {
                    VStack {
                        Picker("Filter", selection: $viewModel.filter) {
                            Text("All").tag("all")
                            Text("To Hike").tag("incomplete")
                            Text("Completed").tag("complete")
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                        .onChange(of: viewModel.filter) { oldValue, newValue in
                            viewModel.filterSummits(viewModel.filter, hikes: hikes)
                        }
                        
                        if !viewModel.filteredSummits.isEmpty {
                            Picker("Sort", selection: $viewModel.sortBy) {
                                Text("By Elevation").tag("elevation")
                                Text("By Name").tag("alphabetical")
                            }
                            .pickerStyle(.segmented)
                            .padding(.horizontal)
                            .onChange(of: viewModel.sortBy) { oldValue, newValue in
                                viewModel.sortSummits(viewModel.sortBy)
                            }
                        }
                    }
                    
                    ForEach(Array(viewModel.filteredSummits.enumerated()), id: \.element.id) { index, summit in
                        NavigationLink {
                            SummitDetailView(summits: viewModel.summits, summit: summit)
                        } label: {
                            SummitListCell(summit: summit, index: index, hiked: hikes.filter { $0.summitID == summit.id }.count > 0)
                        }
                        .id(summit.name)
                    }
                    
                    if viewModel.filteredSummits.isEmpty {
                        EmptyState(imageName: "checklist.checked", message: "No summits for this filter")
                    }
                }
                .listStyle(.plain)
                .navigationTitle("White Mountain 48")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            AccountView()
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .foregroundStyle(.gray)
                        }
                    }
                }
            }
            
        }
        .onAppear {
            viewModel.loadSummits()
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

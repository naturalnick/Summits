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
    @State var isMapViewLoading = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.filterShown {
                    SummitListFilter(
                        filter: $viewModel.filter,
                        sort: $viewModel.sort,
                        showSort:  !viewModel.filteredSummits.isEmpty
                    )
                }
            }
            
            List {
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
                        Image(systemName: viewModel.filterSymbol)
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
        .onAppear {
            viewModel.hikes = hikes
            viewModel.loadSummits()
            appearance.backgroundColor = UIColor(Color("AmcRed"))
        }
        .alert(
            isPresented: viewModel.alertShown,
            error: viewModel.alertError,
            actions: {
                error in
                // buttons
            },
            message: { error in
                if let message = error.errorMessage {
                    Text(message)
                }
            }
        )
    }
}

#Preview {
    SummitsListView()
}

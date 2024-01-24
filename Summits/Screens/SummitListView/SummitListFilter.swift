//
//  SummitListFilter.swift
//  Summits
//
//  Created by Nick Schaefer on 1/22/24.
//

import SwiftUI

struct SummitListFilter: View {
    @State private var filter = "all"
    @State private var sortBy = "elevation"
    
    var hikes: [Hike]
    var filteredSummits: [Summit]
    
    var filterSummits: (_ filter: String, _ hikes: [Hike]) -> Void
    var sortSummits: (_ sortBy: String) -> Void
    
    var body: some View {
        VStack {
            Picker("Filter", selection: $filter) {
                Text("All").tag("all")
                Text("To Hike").tag("incomplete")
                Text("Completed").tag("complete")
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .onChange(of: filter) { oldValue, newValue in
                filterSummits(filter, hikes)
            }
            
            if !filteredSummits.isEmpty {
                Picker("Sort", selection: $sortBy) {
                    Text("By Elevation").tag("elevation")
                    Text("By Name").tag("alphabetical")
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .onChange(of: sortBy) { oldValue, newValue in
                    sortSummits(sortBy)
                }
            }
        }
    }
}

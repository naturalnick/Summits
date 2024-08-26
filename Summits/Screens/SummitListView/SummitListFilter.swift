//
//  SummitListFilter.swift
//  Summits
//
//  Created by Nick Schaefer on 1/22/24.
//

import SwiftUI

struct SummitListFilter: View {
    @Binding var filter: Filter
    @Binding var sort: Sort
    
    let showSort: Bool
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            Picker("Filter", selection: $filter) {
                ForEach(Filter.allCases) { filter in
                    Text(filter.rawValue)
                        .tag(filter)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            if showSort {
                Picker("Sort", selection: $sort) {
                    ForEach(Sort.allCases) { sort in
                        Text(sort.rawValue)
                            .tag(sort)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
            }
        }
    }
}

//
//  SummitListToolbar.swift
//  Summits
//
//  Created by Nick Schaefer on 2/3/24.
//

import SwiftUI

struct SummitListToolbar: ToolbarContent {
    @Binding var viewModel: SummitListViewModel
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            NavigationLink {
                AccountView()
            } label: {
                Image(systemName: "gearshape.fill")
                    .tint(.primary)
            }
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                withAnimation {
                    viewModel.filterShown.toggle()
                }
            } label: {
                Image(systemName: viewModel.filterSymbol)
                    .tint(.primary)
            }
        }
        
        if let progress = viewModel.progress {
            ToolbarItem(placement: .principal) {
                Text("\(progress.0) / \(progress.1)")
                    .font(.headline)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10.0)
                            .strokeBorder(style: StrokeStyle(lineWidth: 2))
                    )
            }
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            NavigationLink {
                MapView()
            } label: {
                Image(systemName: "map.fill")
                    .tint(.primary)
            }
        }
    }
}

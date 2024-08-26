//
//  SummitListToolbar.swift
//  Summits
//
//  Created by Nick Schaefer on 2/3/24.
//

import SwiftUI

struct SummitListToolbar: ToolbarContent {
    var viewModel: SummitListViewModel
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            NavigationLink {
                AccountView()
            } label: {
                Image(systemName: "gearshape.fill")
                    .foregroundStyle(.black)
            }
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                withAnimation {
                    viewModel.filterShown.toggle()
                }
            } label: {
                Image(systemName: viewModel.filterShown ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                    .foregroundStyle(.black)
            }
        }
        
        if let (completed, total) = viewModel.progress, completed > 0 {
            ToolbarItem(placement: .principal) {
                Text("\(completed) / \(total)")
                    .font(.headline)
                    .foregroundStyle(.black)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(RoundedRectangle(cornerRadius: 10.0)
                        .strokeBorder(style: StrokeStyle(lineWidth: 2))
                    )
            }
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            NavigationLink {
                MapView()
            } label: {
                    Image(systemName: "map.fill")
                        .foregroundStyle(.black)
            }
        }
    }
}

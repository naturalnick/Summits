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
                    .foregroundStyle(.black)
            }
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                withAnimation {
                    viewModel.filterShown.toggle()
                    print(viewModel.filterShown)
                }
            } label: {
                Image(systemName: viewModel.filterShown ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                    .foregroundStyle(.black)
                    .onAppear(perform: {
                        print(viewModel.filterShown, "Here")
                    })
            }
        }
        
        if let progress = viewModel.progress {
            ToolbarItem(placement: .principal) {
                Text("\(progress.0) / \(progress.1)")
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

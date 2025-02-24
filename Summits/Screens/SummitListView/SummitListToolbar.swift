//
//  SummitListToolbar.swift
//  Summits
//
//  Created by Nick Schaefer on 2/3/24.
//

import SwiftUI

struct SummitListToolbar: ToolbarContent {
    @Binding var filterShown: Bool
    
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
                    filterShown.toggle()
                }
            } label: {
                Image(systemName: filterShown ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                    .tint(.primary)
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

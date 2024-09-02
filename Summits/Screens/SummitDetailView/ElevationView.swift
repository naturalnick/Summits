//
//  ElevationView.swift
//  Summits
//
//  Created by Nick Schaefer on 1/24/24.
//

import SwiftUI

struct ElevationView: View {
    let summit: Summit
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("Elevation:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(summit.formattedElevation)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title)
                }
                
                VStack {
                    Text("Prominence:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(summit.formattedProminence)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title)
                }
            }
        }
    }
}

//
//  SummitListCell.swift
//  Summits
//
//  Created by Nick on 10/2/23.
//

import SwiftUI

struct SummitListCell: View {
    var summit: Summit
    var index: Int
    var hiked: Bool
    
    var body: some View {
        HStack {
            Text("\(index + 1)")
                .foregroundStyle(.secondary)
                .frame(width: 32, alignment: .leading)
            
            VStack {
                Image(systemName: "mountain.2")
                    .font(.system(size: 32))
                Text(summit.formattedElevation)
                    .font(.system(size: 16, weight: .semibold))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(summit.name)
                    .font(.title3)
            }
            .padding(.leading, 10)
            
            Spacer()
            
            if hiked {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(Color("Emerald"))
                    .font(.title3)
            }
        }
        .foregroundStyle(.primary)
        .padding(.horizontal, 5)
    }
}

struct SummitListCell_Previews: PreviewProvider {
    static var previews: some View {
        SummitListCell(
            summit: .washington,
            index: 0,
            hiked: true
        )
    }
}

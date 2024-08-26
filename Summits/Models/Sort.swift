//
//  Sort.swift
//  Summits
//
//  Created by Ricky on 8/25/24.
//

import Foundation

enum Sort: String, CaseIterable, Identifiable {
    case elevation = "By Elevation"
    case name = "By Name"
    
    var id: String { rawValue }
}

//
//  Filter.swift
//  Summits
//
//  Created by Ricky on 8/25/24.
//

import Foundation

enum Filter: String, CaseIterable, Identifiable {
    case all = "All"
    case toHike = "To Hike"
    case completed = "Completed"
    
    var id: String { rawValue }
}

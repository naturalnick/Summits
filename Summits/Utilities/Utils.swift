//
//  Utils.swift
//  Summits
//
//  Created by Nick Schaefer on 1/21/24.
//

import SwiftUI

func formatDate(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM dd, yyyy"
    
    return formatter.string(from: date)
}

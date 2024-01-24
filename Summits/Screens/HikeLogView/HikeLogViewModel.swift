//
//  SummitLogViewModel.swift
//  Summits
//
//  Created by Nick on 10/9/23.
//

import SwiftUI
import SwiftData
import PhotosUI

@Observable class HikeLogViewModel {
    var selectedDate = Date()
    var rating: Int = 5
    var weather: String = ""
    var companions: String = ""
    var details: String = ""
    
    var images: [Data] = []
    
    var deleteAlertVisible: Bool = false
    
    var dateRange: ClosedRange<Date> {
        let today = Date()
        let earliestDate = Date.distantPast
        return earliestDate...today
    }
}

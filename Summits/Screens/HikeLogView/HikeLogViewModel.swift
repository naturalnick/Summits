//
//  SummitLogViewModel.swift
//  Summits
//
//  Created by Nick on 10/9/23.
//

import SwiftUI
import SwiftData

@Observable class HikeLogViewModel {
    var selectedDate = Date()
    var rating: Int = 5
    var weather: String = ""
    var companions: String = ""
    var details: String = ""
    
    var alertError: AlertError? = nil
    var alertShown: Binding<Bool> {
        Binding {
            self.alertError != nil
        } set: { _ in
            self.alertError = nil
        }
    }
}

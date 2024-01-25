//
//  Hike.swift
//  Summits
//
//  Created by Nick Schaefer on 1/21/24.
//

import Foundation
import SwiftData

@Model
class Hike: Identifiable {
    var id: String
    var summitID: String
    var date: Date
    var rating: Int
    var weather: String
    var companions: String
    var details: String
    
    @Attribute(.externalStorage) var images: [Data] = []
    
    var saved: Bool = false
    
    init(summitID: String, date: Date, rating: Int, weather: String, companions: String, details: String, images: [Data] = []) {
        self.id = UUID().uuidString
        self.summitID = summitID
        self.date = date
        self.rating = rating
        self.weather = weather
        self.companions = companions
        self.details = details
        self.images = images
    }
    
}

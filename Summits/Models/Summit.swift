//
//  Summit.swift
//  Summits
//
//  Created by Nick on 10/2/23.
//

import Foundation


struct Summit: Decodable, Identifiable, Equatable {
    private let prominenceFt: Int
    let elevationFt: Int
    let id: String
    let name: String
    let officialName: String
    let range: String
    let geolocation: Geolocation
    let state: String
    
    var formattedElevation: String {
        let measurement = Measurement(value: Double(elevationFt), unit: UnitLength.feet)
        return measurement.formatted(.measurement(width: .abbreviated, usage: .asProvided))
    }
    
    var formattedProminence: String {
        let measurement = Measurement(value: Double(prominenceFt), unit: UnitLength.feet)
        return measurement.formatted(.measurement(width: .abbreviated, usage: .asProvided))
    }
    
    init(
        id: String,
        name: String,
        officialName : String,
        elevationFt: Int,
        range: String,
        prominenceFt: Int,
        geolocation: Geolocation,
        state: String
    ) {
        self.id = id
        self.name = name
        self.officialName = officialName
        self.elevationFt = elevationFt
        self.range = range
        self.prominenceFt = prominenceFt
        self.geolocation = geolocation
        self.state = state
    }
    
    static let washington = Summit(
        id: "0",
        name: "Washington",
        officialName: "WASHINGTON",
        elevationFt: 6288,
        range: "Presidential Range",
        prominenceFt: 6148,
        geolocation: Geolocation(latitude: 44.2704, longitude: -71.3033),
        state: "New Hampshire"
    )
    
    static let summits: [Summit] = [.washington, .washington, .washington, .washington]
    
    static func == (lhs: Summit, rhs: Summit) -> Bool {
        lhs.id == rhs.id
    }
}

struct Geolocation: Decodable {
    let latitude: Double
    let longitude: Double
}

struct SummitResponse: Decodable {
    let response: [Summit]
}

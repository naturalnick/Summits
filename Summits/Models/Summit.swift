//
//  Summit.swift
//  Summits
//
//  Created by Nick on 10/2/23.
//

import Foundation


struct Summit: Decodable, Identifiable, Equatable {
    let id: String
    let name: String
    let elevationFt: Int
    let range: String
    let prominenceFt: Int
    let geolocation: Geolocation
    let state: String
    
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

struct MockData {
    static let sampleSummit = Summit(id: "0", name: "Washington", elevationFt: 6288, range: "Presidential Range", prominenceFt: 6148, geolocation: Geolocation(latitude: 44.2704, longitude: -71.3033), state: "New Hampshire")
    
    static let summits = [sampleSummit, sampleSummit, sampleSummit, sampleSummit]
}

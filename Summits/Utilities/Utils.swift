//
//  Utils.swift
//  Summits
//
//  Created by Nick Schaefer on 1/21/24.
//

import SwiftUI

func getSummits() throws -> [Summit] {
    if let file = Bundle.main.url(forResource: "data", withExtension: "json") {
        do {
            let data = try Data(contentsOf: file)
            let decoder = JSONDecoder()
            let result = try decoder.decode(SummitResponse.self, from: data)
            let summits = result.response
            
            return summits
        } catch {
            print("Error decoding JSON: \(error)")
            throw AlertError.invalidJSON
        }
    } else {
        print("Summits file not found.")
        throw AlertError.fileNotFound
    }
}


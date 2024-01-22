//
//  SummitListViewModel.swift
//  Summits
//
//  Created by Nick on 10/2/23.
//

import SwiftUI

final class SummitListViewModel: ObservableObject {
    @Published var summits: [Summit] = []
    @Published var filteredSummits: [Summit] = []
    @Published var filter = "all"
    @Published var sortBy = "elevation"
    @Published var alertError: AlertError?
    
    var alertShown: Binding<Bool> {
        Binding {
            self.alertError != nil
        } set: { _ in
            self.alertError = nil
        }
    }
    
    func loadSummits() {
        if let file = Bundle.main.url(forResource: "data", withExtension: "json") {
            do {
                let data = try Data(contentsOf: file)
                let decoder = JSONDecoder()
                let result = try decoder.decode(SummitResponse.self, from: data)
                summits = result.response
                filteredSummits = summits
            } catch {
                print("Error decoding JSON: \(error)")
                alertError = AlertError.invalidJSON
            }
        } else {
            print("Summits file not found.")
            alertError = AlertError.fileNotFound
        }
    }
    
    func filterSummits(_ filter: String, hikes: [Hike]) {
        switch filter {
        case "all":
            filteredSummits = summits
        case "incomplete":
            filteredSummits = summits.filter { summit in
                return !hikes.contains { hike in
                    hike.summitID == summit.id
                }
            }
        case "complete":
            filteredSummits = summits.filter { summit in
                return hikes.contains { hike in
                    hike.summitID == summit.id
                }
            }
        default:
            return
        }
    }
    
    func sortSummits(_ sortBy: String) {
        switch sortBy {
        case "elevation":
            filteredSummits = summits
        case "alphabetical":
            filteredSummits = summits.sorted(by: { summit1, summit2 in
                summit1.name < summit2.name
            })
        default:
            return
        }
    }
}

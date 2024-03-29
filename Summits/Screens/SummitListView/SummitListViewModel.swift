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
    @Published var filterShown = false
    @Published var alertError: AlertError?
    
    var alertShown: Binding<Bool> {
        Binding {
            self.alertError != nil
        } set: { _ in
            self.alertError = nil
        }
    }
    
    func loadSummits() {
        do {
            let summits = try getSummits()
            self.summits = summits
            filteredSummits = summits
        } catch let error as AlertError {
            alertError = error
        } catch {
            print(error)
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

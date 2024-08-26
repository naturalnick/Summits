//
//  SummitListViewModel.swift
//  Summits
//
//  Created by Nick on 10/2/23.
//

import SwiftUI

@Observable
class SummitListViewModel {
    var summits: [Summit] = []
    var hikes: [Hike] = []
    var progress: (Int, Int)?
    var filteredSummits: [Summit] = []
    var filterShown = true
    var alertError: AlertError?
    
    
    var sort: Sort = .name {
        didSet { sortSummits() }
    }
    var filter: Filter = .all {
        didSet { filterSummits() }
    }
    var searchText: String = "" {
        didSet { filterSummits() }
    }
    
    var filterSymbol: String {
        filterShown ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill"
    }
    
    var alertShown: Binding<Bool> {
        Binding {
            self.alertError != nil
        } set: { _ in
            self.alertError = nil
        }
    }
    
    func loadSummits() {
        do {
            summits = try getSummits()
            filteredSummits = summits
        } catch let error as AlertError {
            alertError = error
        } catch {
            print(error)
        }
    }
    
    func filterSummits() {
        let searchedSummits = !searchText.isEmpty ? summits.filter { $0.name.localizedCaseInsensitiveContains(searchText)} : summits
        
        switch filter {
        case .all:
            filteredSummits = searchedSummits
        case .toHike:
            filteredSummits = searchedSummits.filter { summit in
                !hikes.contains { $0.summitID == summit.id }
            }
        case .completed:
            filteredSummits = searchedSummits.filter { summit in
                hikes.contains { $0.summitID == summit.id }
            }
        }
    }
    
    func sortSummits() {
        switch sort {
        case .elevation:
            filteredSummits = filteredSummits.sorted(by: {$0.elevationFt > $1.elevationFt})
        case .name:
            filteredSummits = filteredSummits.sorted(by: {$0.name < $1.name})
        }
    }
    
    func updateProgress(hikes: [Hike]) {
        let hikedSummits = summits.filter { summit in
            return hikes.contains { hike in
                hike.summitID == summit.id
            }
        }
        progress = (hikedSummits.count, summits.count)
    }
}

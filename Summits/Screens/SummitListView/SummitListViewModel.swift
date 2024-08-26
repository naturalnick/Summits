//
//  SummitListViewModel.swift
//  Summits
//
//  Created by Nick on 10/2/23.
//

import SwiftUI



final class SummitListViewModel: ObservableObject {
    private var summits: [Summit] = []
    var hikes: [Hike] = []
    var progress: (Int, Int)?
    @Published var filteredSummits: [Summit] = []
    @Published var filterShown = false
    @Published var alertError: AlertError?

    
    @Published var sort: Sort = .name {
        didSet { sortSummits() }
    }
    @Published var filter: Filter = .all {
        didSet { filterSummits() }
    }
    @Published var searchText: String = "" {
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
    
    // MARK: - Public
    
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
        switch filter {
        case .all:
            filteredSummits = summits
        case .toHike:
            filteredSummits = summits.filter { summit in
                !hikes.contains { $0.summitID == summit.id }
            }
        case .completed:
            filteredSummits = summits.filter { summit in
                hikes.contains { $0.summitID == summit.id }
            }
        }
        
        guard !searchText.isEmpty else { return }
        filteredSummits = filteredSummits.filter { $0.name.localizedCaseInsensitiveContains(searchText)}
    }
    
    func sortSummits() {
        switch sort {
        case .elevation:
            filteredSummits = summits
        case .name:
            filteredSummits = summits.sorted(by: {$0.name < $1.name})
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

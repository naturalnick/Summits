//
//  SummitsApp.swift
//  Summits
//
//  Created by Nick on 10/2/23.
//

import SwiftUI
import SwiftData

@main
struct SummitsApp: App {
    var body: some Scene {
        WindowGroup {
            SummitsListView()
        }
        .modelContainer(for: Hike.self)
    }
}

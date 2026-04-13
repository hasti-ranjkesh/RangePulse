//
//  Range​PulseApp.swift
//  Range​Pulse
//
//  Created by Hasti on 10/04/2026.
//

import SwiftUI
import SwiftData

@main
struct Range​PulseApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ShotListView(viewModel: ShotsViewModel(bleManager: BLEManager()))
        }
        .modelContainer(sharedModelContainer)
    }
}

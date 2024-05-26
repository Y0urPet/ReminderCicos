//
//  BasicWatchApp.swift
//  BasicWatch Watch App
//
//  Created by Timothy Andrian on 13/05/24.
//

import SwiftUI
import SwiftData

@main
struct BasicWatch_Watch_AppApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UserShift.self,
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
            ContentView()
                .modelContainer(sharedModelContainer)
        }
    }
}

//
//  AlphaQueueApp.swift
//  AlphaQueue
//
//  Created by Spencer Wolf on 3/18/25.
//

import SwiftUI

@main
struct AlphaQueueApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

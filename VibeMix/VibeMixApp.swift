//
//  VibeMixApp.swift
//  VibeMix
//
//  Created by Christopher Endress on 3/23/24.
//

import SwiftUI

@main
struct VibeMixApp: App {
    // Shared instance of PersistenceController
    @StateObject var tabSelection = TabSelection()
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            TabBarView()
            // Inject the managed object context into the environment of ContentView
            // This allows ContentView and any of its children to access the managed object context for Core Data operations
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(tabSelection)
        }
    }
}

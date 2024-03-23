//
//  VibeMixApp.swift
//  VibeMix
//
//  Created by Christopher Endress on 3/23/24.
//

import SwiftUI
import StoreKit

@main
struct VibeMixApp: App {
  let persistenceController = PersistenceController.shared
  
  init() {
    requestMusicAuthorization()
  }
  
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
  }
  
  func requestMusicAuthorization() {
    SKCloudServiceController.requestAuthorization { status in
      switch status {
      case .authorized:
        print("Music Authorization granted.")
        // Proceed with music authorization permission
      default:
        print("Music Authorization was not granted.")
        // Handle case when authorization is not granted
      }
    }
  }
}

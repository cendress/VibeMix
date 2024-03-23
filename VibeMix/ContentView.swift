//
//  ContentView.swift
//  VibeMix
//
//  Created by Christopher Endress on 3/23/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
  var body: some View {
    Text("Hello")
  }
}

#Preview {
  ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

//
//  ContentView.swift
//  VibeMix
//
//  Created by Christopher Endress on 3/23/24.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    NavigationView {
      VStack(spacing: 20) {
        Text("Welcome to VibeMix")
          .font(.largeTitle)
          .fontWeight(.bold)
          .padding()
        
        Text("Discover playlists that match your current mood")
          .font(.subheadline)
          .multilineTextAlignment(.center)
          .padding([.leading, .trailing], 40)
        
        NavigationLink(destination: MoodPromptView()) {
          Text("Start Quiz")
            .foregroundColor(.white)
            .padding()
            .background(Color(named: "AppColor"))
            .cornerRadius(10)
        }
      }
    }
  }
}

#Preview {
  ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

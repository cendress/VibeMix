//
//  ContentView.swift
//  VibeMix
//
//  Created by Christopher Endress on 3/23/24.
//

import SwiftUI
import UIOnboarding

import SwiftUI

struct ContentView: View {
  @State private var showingOnboarding = !UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
  
  var body: some View {
    TabView {
      MoodPromptView()
        .tabItem {
          Image(systemName: "wand.and.stars")
        }
      
      Text("Second View")
        .tabItem {
          Image(systemName: "heart")
        }
    }
    .fullScreenCover(isPresented: $showingOnboarding) {
      OnboardingView.init()
        .edgesIgnoringSafeArea(.all)
        .onDisappear {
          UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
          showingOnboarding = false
        }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView.init()
  }
}

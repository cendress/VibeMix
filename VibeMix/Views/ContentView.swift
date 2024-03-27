//
//  ContentView.swift
//  VibeMix
//
//  Created by Christopher Endress on 3/23/24.
//

import SwiftUI
// Library used to create onboarding screens
import UIOnboarding

struct ContentView: View {
  // Ensure onboarding screens are shown only once by using UserDefaults
  @State private var showingOnboarding = !UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
  
  var body: some View {
    // Creates tab bar
    TabView {
      MoodPromptView()
        .tabItem {
          Image(systemName: "wand.and.stars")
        }
      
      SavedPlaylistsView()
        .tabItem {
          Image(systemName: "heart")
        }
      
      SettingsView()
        .tabItem {
          Image(systemName: "gear")
        }
    }
    .accentColor(Color("AppColor"))
    .fullScreenCover(isPresented: $showingOnboarding) {
      OnboardingView.init()
        .edgesIgnoringSafeArea(.all)
      // Ensure onboarding screens are not shown again if they appear once
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

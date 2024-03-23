//
//  ContentView.swift
//  VibeMix
//
//  Created by Christopher Endress on 3/23/24.
//

import SwiftUI
import UIOnboarding

struct ContentView: View {
  @State private var showingOnboarding = !UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
  
  var body: some View {
    MoodPromptView()
      .fullScreenCover(isPresented: $showingOnboarding, content: {
        OnboardingView.init()
          .edgesIgnoringSafeArea(.all)
          .onDisappear {
            UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
          }
      })
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView.init()
  }
}

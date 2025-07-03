//
//  ContentView.swift
//  VibeMix
//
//  Created by Christopher Endress on 3/23/24.
//

import SwiftUI
import UIOnboarding

// Model to act as an observable object to hold the index of the selected tab
class TabSelection: ObservableObject {
    @Published var selectedTab: Int = 0
}

struct TabBarView: View {
    // Ensure onboarding screens are shown only once by using UserDefaults
    @State private var showingOnboarding = !UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    @EnvironmentObject var tabSelection: TabSelection
    
    var body: some View {
        // Creates tab bar
        TabView(selection: $tabSelection.selectedTab) {
            MoodPromptView()
                .tabItem {
                    Image(systemName: "wand.and.stars")
                }
                .tag(0)
            
            SavedPlaylistsView()
                .tabItem {
                    Image(systemName: "heart")
                }
                .tag(1)
        }
        .accentColor(Color("AppColor"))
        .fullScreenCover(isPresented: $showingOnboarding) {
            OnboardingView()
                .ignoresSafeArea()
            // Ensure onboarding screens are not shown again if they appear once
                .onDisappear {
                    UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                    showingOnboarding = false
                }
        }
    }
}

#Preview {
    TabBarView()
}


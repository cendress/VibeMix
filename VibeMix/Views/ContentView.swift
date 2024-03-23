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
    NavigationView {
      Text("Hello, UIOnboarding!")
        .toolbar {
          Button {
            showingOnboarding = true
          } label: {
            Image(systemName: "repeat")
          }
        }
        .fullScreenCover(isPresented: $showingOnboarding, content: {
          OnboardingView.init()
            .edgesIgnoringSafeArea(.all)
            .onDisappear {
              UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
            }
        })
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView.init()
  }
}

//struct ContentView: View {
//  var body: some View {
//    NavigationView {
//      VStack(spacing: 20) {
//        Text("Welcome to VibeMix")
//          .font(.largeTitle)
//          .fontWeight(.bold)
//          .padding()
//
//        Text("Discover playlists that match your current mood")
//          .font(.subheadline)
//          .multilineTextAlignment(.center)
//          .padding([.leading, .trailing], 40)
//
//        NavigationLink(destination: MoodPromptView()) {
//          Text("Get Started")
//            .foregroundColor(.white)
//            .padding()
//            .background(Color("AppColor"))
//            .cornerRadius(10)
//        }
//      }
//    }
//  }
//}

//#Preview {
//  ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//}

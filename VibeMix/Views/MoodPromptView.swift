//
//  MoodPromptView.swift
//  VibeMix
//
//  Created by Christopher Endress on 3/23/24.
//

import SwiftUI

enum MoodOption: String, CaseIterable {
  case happy = "Happy", sad = "Sad", energetic = "Energetic", relaxed = "Relaxed"
  
  // Computed property that returns a string for all mood options
  var description: String {
    switch self {
    case .happy:
      return "Happy"
      //      return "I'm feeling happy and upbeat."
    case .sad:
      return "Sad"
      //      return "I'm feeling a bit down."
    case .energetic:
      return "Energetic"
      //      return "I'm ready to take on the world!"
    case .relaxed:
      return "Relaxed"
      //      return "I'm in a chill, laid-back mood."
    }
  }
  
  // Computed property that returns an SF Symbol name for each mood option
  var symbol: String {
    switch self {
    case .happy:
      return "sun.max.fill"
    case .sad:
      return "cloud.rain.fill"
    case .energetic:
      return "bolt.fill"
    case .relaxed:
      return "leaf.fill"
    }
  }
}

struct MoodPromptView: View {
  @State private var selectedMood: MoodOption?
  @State private var isButtonSelected = false
  
  let columns = [
    GridItem(.flexible()),
    GridItem(.flexible())
  ]
  
  var body: some View {
    NavigationView {
      ZStack {
        Color("BackgroundColor").ignoresSafeArea()
        VStack {
          Spacer()
          Spacer()
          Text("How are you feeling?")
            .font(.title)
            .padding(.bottom, 20)
          
          // LazyVGrid for creating a grid layout
          LazyVGrid(columns: columns, spacing: 20) {
            ForEach(MoodOption.allCases, id: \.self) { mood in
              Button(action: {
                // Set the selected mood and reset button selection when buttons are tapped
                self.selectedMood = mood
                self.isButtonSelected = false
              }) {
                VStack {
                  Image(systemName: mood.symbol)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                  
                  Text(mood.description)
                    .multilineTextAlignment(.center)
                }
                .padding()
                // Make the button width fill the available space
                .frame(maxWidth: .infinity, maxHeight: 200)
                // Change the background and text color based on selection
                .background(self.selectedMood == mood ? Color("AppColor") : Color.white)
                .foregroundColor(self.selectedMood == mood ? Color.white : Color("AppColor"))
                .cornerRadius(25)
              }
              // Style the button with a border and rounded corners
              .overlay(
                RoundedRectangle(cornerRadius: 20)
                  .stroke(selectedMood == mood ? Color.clear : Color("AppColor"), lineWidth: 2)
              )
            }
          }
          .padding(.horizontal, 20)
          
          Spacer()
          
          // Create a "Find My Vibe" button that is enabled only if a mood is selected
          Button(action: {
            // Set isButtonSelected to true if a mood is selected to trigger navigation
            if self.selectedMood != nil {
              self.isButtonSelected = true
            }
          }) {
            HStack {
              Image(systemName: "music.note.list")
              Text("Find My Vibe")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color("AppColor"))
            .foregroundColor(.white)
            .cornerRadius(10)
          }
          .padding(.horizontal, 100)
          .disabled(selectedMood == nil)
          
          // Create a NavigationLink that is activated when isButtonSelected is true
          if let selectedMood = selectedMood {
            NavigationLink(destination: PlaylistView(mood: selectedMood), isActive: $isButtonSelected) {
              EmptyView()
            }
          }
          
          Spacer()
          Spacer()
        }
        .navigationTitle("New Playlist")
      }
    }
  }
}

#Preview {
  MoodPromptView()
}

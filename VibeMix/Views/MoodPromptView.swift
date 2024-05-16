//
//  MoodPromptView.swift
//  VibeMix
//
//  Created by Christopher Endress on 3/23/24.
//

import SwiftUI

/* CaseIterable protocol allows all items within a type to be iterated over in a similar behavior to an array */
enum MoodOption: String, CaseIterable {
  case happy = "Happy", sad = "Sad", energetic = "Energetic", relaxed = "Relaxed"
  
  // Computed property that returns a string description for all mood options
  var description: String {
    switch self {
    case .happy:
      return "I'm feeling happy and upbeat."
    case .sad:
      return "I'm feeling a bit down."
    case .energetic:
      return "I'm ready to take on the world!"
    case .relaxed:
      return "I'm in a chill, laid-back mood."
    }
  }
  
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
  
  var body: some View {
    NavigationView {
      VStack {
        Spacer()
        Spacer()
        Text("How are you feeling?")
          .font(.title)
          .padding(.bottom, 20)
        
        // Iterate over all mood options and create a button for each
        ForEach(MoodOption.allCases, id: \.self) { mood in
          Button(action: {
            // Set the selected mood and reset button selection when buttons are tapped
            self.selectedMood = mood
            self.isButtonSelected = false
          }) {
            Text(mood.description)
              .padding()
            // Make the button width fill the available space
              .frame(maxWidth: .infinity)
            // Change the background and text color based on selection
              .background(self.selectedMood == mood ? Color("AppColor") : Color.white)
              .foregroundColor(self.selectedMood == mood ? Color.white : Color("AppColor"))
          }
          // Style the button with a border and rounded corners
          .overlay(
            RoundedRectangle(cornerRadius: 25)
              .stroke(selectedMood == mood ? Color.clear : Color("AppColor"), lineWidth: 2)
          )
          .cornerRadius(25)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 20)
        
        Spacer()
        
        // Create a "Find My Vibe" button that is enabled only if a mood is selected
        Button(action: {
          // Set isButtonSelected to true if a mood is selected to trigger navigation
          if self.selectedMood != nil {
            self.isButtonSelected = true
          }
        }) {
          Text("Find My Vibe")
            .bold()
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

#Preview {
  MoodPromptView()
}

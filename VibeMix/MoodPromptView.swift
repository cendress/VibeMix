//
//  MoodPromptView.swift
//  VibeMix
//
//  Created by Christopher Endress on 3/23/24.
//

import SwiftUI

/* CaseIterable allows all items within a type to be iterated over in a similar behavior to an array */
enum MoodOption: String, CaseIterable {
  case happy = "Happy"
  case sad = "Sad"
  case energetic = "Energetic"
  case relaxed = "Relaxed"
  
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
}

struct MoodPromptView: View {
  @State private var selectedMood: MoodOption?
  @State private var isButtonSelected = false
  
  var body: some View {
    NavigationView {
      VStack {
        Spacer()
        
        Text("How are you feeling?")
          .font(.title)
          .padding(.bottom, 20)
        
        ForEach(MoodOption.allCases, id: \.self) { mood in
          Button(action: {
            self.selectedMood = mood
            self.isButtonSelected = false
          }) {
            Text(mood.description)
              .padding()
              .frame(maxWidth: .infinity)
              .background(self.selectedMood == mood ? Color("AppColor") : Color.white)
              .foregroundColor(self.selectedMood == mood ? Color(.white) : Color("AppColor"))
          }
          .overlay(
            RoundedRectangle(cornerRadius: 25)
              .stroke(selectedMood == mood ? Color.clear : Color("AppColor"), lineWidth: 2)
          )
          .cornerRadius(25)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 20)
        
        Spacer()
        
        Button(action: {
          self.isButtonSelected = true
        }) {
          Text("Find My Vibe")
            .bold()
            .frame(maxWidth: .infinity)
            .padding()
            .background(self.isButtonSelected == true ? Color("AppColor") : Color.white)
            .foregroundColor(self.isButtonSelected == true ? Color(.white) : Color("AppColor"))
            .cornerRadius(25)
        }
        .overlay(
          RoundedRectangle(cornerRadius: 25)
            .stroke(Color("AppColor"), lineWidth: 2)
        )
        .padding(.horizontal, 100)
        .disabled(selectedMood == nil)
        
        
        NavigationLink(destination: PlaylistView(), isActive: $isButtonSelected) {
          EmptyView()
        }
        
        Spacer()
      }
      .navigationTitle("New Playlist")
    }
  }
}

#Preview {
  MoodPromptView()
}

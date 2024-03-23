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
  var body: some View {
    Text("Hello")
  }
}

#Preview {
  MoodPromptView()
}

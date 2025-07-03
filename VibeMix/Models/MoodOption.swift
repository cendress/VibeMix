//
//  MoodOption.swift
//  VibeMix
//
//  Created by Christopher Endress on 7/3/25.
//

import Foundation

enum MoodOption: String, CaseIterable {
  case happy = "Happy", sad = "Sad", energetic = "Energetic", relaxed = "Relaxed"
  
  // Computed property that returns a string for all mood options
  var description: String {
    switch self {
    case .happy:
      return "Happy"
    case .sad:
      return "Sad"
    case .energetic:
      return "Energetic"
    case .relaxed:
      return "Relaxed"
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

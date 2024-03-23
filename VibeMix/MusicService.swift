//
//  MusicService.swift
//  VibeMix
//
//  Created by Christopher Endress on 3/23/24.
//

import MusicKit
import StoreKit

class MusicService {
  static let musicService = MusicService()
  
  private init() {}
  
  // Check if the app is authorized to access music library
  func checkMusicAuthorization(completion: @escaping (Bool) -> Void) {
    SKCloudServiceController.requestAuthorization { status in
      DispatchQueue.main.async {
        completion(status == .authorized)
      }
    }
  }
  
  func fetchSongs(forMood mood: MoodOption, completion: @escaping (Result<[Song], Error>) -> Void) {
    checkMusicAuthorization { authorized in
      // If music library access is not authorized
      guard authorized else {
        completion(.failure(NSError(domain: "MusicService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Not authorized to access music library"])))
        return
      }
      // Continue if authorization is granted
    }
  }
  
  // Method that searches songs based on mood
  private func moodToSearchQuery(_ mood: MoodOption) -> String {
    switch mood {
    case .happy:
      return "upbeat happy"
    case .sad:
      return "sad"
    case .energetic:
      return "energetic workout"
    case .relaxed:
      return "chill relax"
    }
  }
}

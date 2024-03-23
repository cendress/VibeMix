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
}

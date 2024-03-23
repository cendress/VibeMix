//
//  MusicService.swift
//  VibeMix
//
//  Created by Christopher Endress on 3/23/24.
//

import CoreData
import MusicKit
import StoreKit

class MusicService {
  static let shared = MusicService()
  
  private init() {}
  
  func requestMusicAuthorization(completion: @escaping (Bool) -> Void) {
    SKCloudServiceController.requestAuthorization { status in
      DispatchQueue.main.async {
        switch status {
        case .authorized:
          completion(true)
        default:
          completion(false)
        }
      }
    }
  }
  
  func fetchSongs(forMood mood: MoodOption, completion: @escaping (Result<[Song], Error>) -> Void) {
    requestMusicAuthorization { authorized in
      guard authorized else {
        completion(.failure(NSError(domain: "MusicService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Not authorized to access music library"])))
        return
      }
      
      let searchQuery = self.moodToSearchQuery(mood)
      
      Task {
        do {
          var request = MusicCatalogSearchRequest(term: searchQuery, types: [Song.self])
          request.limit = 10
          
          let response = try await request.response()
          
          let songsArray = Array(response.songs)
          
          completion(.success(songsArray))
        } catch {
          completion(.failure(error))
        }
      }
    }
  }
  
  private func moodToSearchQuery(_ mood: MoodOption) -> String {
    switch mood {
    case .happy:
      return "happy"
    case .sad:
      return "sad"
    case .energetic:
      return "energetic"
    case .relaxed:
      return "relaxed"
    }
  }
}

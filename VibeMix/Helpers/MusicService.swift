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
  
  func checkMusicAuthorization(completion: @escaping (Bool, String?) -> Void) {
    SKCloudServiceController.requestAuthorization { status in
      DispatchQueue.main.async {
        switch status {
        case .authorized:
          SKCloudServiceController().requestUserToken(forDeveloperToken: TokenProvider.developerToken) { userToken, error in
            DispatchQueue.main.async {
              if let userToken = userToken, error == nil {
                completion(true, userToken)
              } else {
                completion(false, nil)
              }
            }
          }
        default:
          completion(false, nil)
        }
      }
    }
  }
  
  func fetchSongs(forMood mood: MoodOption, completion: @escaping (Result<[MusicKit.Song], Error>) -> Void) {
    checkMusicAuthorization { authorized, userToken in
      guard authorized, let userToken = userToken else {
        completion(.failure(NSError(domain: "MusicService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Not authorized to access music library"])))
        return
      }
      
      let searchQuery = self.moodToSearchQuery(mood)
      
      Task {
        do {
          var request = MusicCatalogSearchRequest(term: searchQuery, types: [MusicKit.Song.self])
          request.limit = 10
          let response = try await request.response()
          
          completion(.success(response.songs.compactMap { $0 }))
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

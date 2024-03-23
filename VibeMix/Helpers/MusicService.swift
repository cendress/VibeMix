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
  
  func requestUserToken(completion: @escaping (Result<String, Error>) -> Void) {
    let developerToken = TokenProvider.developerToken
    
    SKCloudServiceController().requestUserToken(forDeveloperToken: developerToken) { userToken, error in
      DispatchQueue.main.async {
        if let error = error {
          completion(.failure(error))
        } else if let userToken = userToken {
          completion(.success(userToken))
        } else {
          completion(.failure(NSError(domain: "MusicService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unknown error requesting user token"])))
        }
      }
    }
  }
  
  func fetchSongs(forMood mood: MoodOption, completion: @escaping (Result<[Song], Error>) -> Void) {
    requestMusicAuthorization { [weak self] authorized in
      guard authorized, let self = self else {
        completion(.failure(NSError(domain: "MusicService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Not authorized to access music library"])))
        return
      }
      
      self.requestUserToken { result in
        switch result {
        case .success(let userToken):
          self.performSongFetchRequest(forMood: mood, completion: completion)
          
        case .failure(let error):
          print("Error requesting user token: \(error)")
          completion(.failure(error))
        }
      }
    }
  }
  
  private func performSongFetchRequest(forMood mood: MoodOption, completion: @escaping (Result<[Song], Error>) -> Void) {
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

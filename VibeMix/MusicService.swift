//
//  MusicService.swift
//  VibeMix
//
//  Created by Christopher Endress on 3/23/24.
//

import MusicKit
import StoreKit
import CoreData

class MusicService {
  static let shared = MusicService()
  
  private init() {}
  
  func checkMusicAuthorization(completion: @escaping (Bool) -> Void) {
    SKCloudServiceController.requestAuthorization { status in
      DispatchQueue.main.async {
        completion(status == .authorized)
      }
    }
  }
  
  func fetchSongs(forMood mood: MoodOption, context: NSManagedObjectContext, completion: @escaping (Result<[Song], Error>) -> Void) {
    checkMusicAuthorization { [weak self] authorized in
      guard authorized else {
        completion(.failure(NSError(domain: "MusicService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Not authorized to access music library"])))
        return
      }
      
      guard let self = self else { return }
      let searchQuery = self.moodToSearchQuery(mood)
      
      Task {
        do {
          var request = MusicCatalogSearchRequest(term: searchQuery, types: [MusicKit.Song.self])
          request.limit = 10
          let response = try await request.response()
          
          let songs = response.songs.compactMap { musicKitSong -> Song? in
            let song = Song(context: context)
            song.title = musicKitSong.title
            song.artistName = musicKitSong.artistName
            return song
          }
          
          try context.save()
          completion(.success(songs))
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


//
//  MusicService.swift
//  VibeMix
//
//  Created by Christopher Endress on 3/23/24.
//

import Foundation

//MARK: - Necessary structs to create objects that are used by Spotify API

struct SpotifyTrack: Codable {
  let name: String
  let id: String
  let album: Album
  var artistName: String {
    album.artists.first?.name ?? "Unknown Artist"
  }
  var imageUrl: URL? {
    URL(string: album.images.first?.url ?? "")
  }
}

struct Album: Codable {
  let images: [SpotifyImage]
  let artists: [Artist]
}

struct Artist: Codable {
  let name: String
}

struct SpotifyImage: Codable {
  let url: String
}

struct SpotifySearchResponse: Codable {
  let tracks: SpotifyTracksResponse
}

struct SpotifyTracksResponse: Codable {
  let items: [SpotifyTrack]
}

//MARK: - MusicService class

class MusicService {
  static let shared = MusicService()
  
  private init() {}
  
  func fetchSongs(forMood mood: MoodOption, completion: @escaping (Result<[SpotifyTrack], Error>) -> Void) {
    SpotifyAuthService.shared.requestAccessToken { [weak self] result in
      switch result {
      case .success(let accessToken):
        self?.performSpotifySearch(forMood: mood, accessToken: accessToken, completion: completion)
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  private func performSpotifySearch(forMood mood: MoodOption, accessToken: String, completion: @escaping (Result<[SpotifyTrack], Error>) -> Void) {
    let searchQuery = self.moodToSearchQuery(mood)
    let urlString = "https://api.spotify.com/v1/search?q=\(searchQuery)&type=track&limit=25"
    guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
      completion(.failure(NSError(domain: "MusicService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
      return
    }
    
    var request = URLRequest(url: url)
    request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      guard let data = data, error == nil else {
        completion(.failure(error ?? NSError(domain: "MusicService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch data"])))
        return
      }
      
      do {
        let response = try JSONDecoder().decode(SpotifySearchResponse.self, from: data)
        completion(.success(response.tracks.items))
      } catch {
        completion(.failure(error))
      }
    }
    task.resume()
  }
  
  private func moodToSearchQuery(_ mood: MoodOption) -> String {
    let happyKeywords = [
      "\"popular happy music\"", "\"popular upbeat tracks\"", "\"feel-good playlist\"",
      "\"positive vibes\"", "\"popular joyful beats\"", "\"popular uplifting songs\"",
      "\"top happy hits\"", "\"good mood music\"", "\"popular cheerful tunes\""
    ]
    let sadKeywords = [
      "\"top sad songs\"", "\"popular melancholic music\"", "\"top emotional tracks\"",
      "\"popular heartbreak songs\"", "\"famous tearjerkers\"", "\"deeply emotional\"",
      "\"deep reflective music\"", "\"top moody tracks\"", "\"top melancholy vibes\""
    ]
    let energeticKeywords = [
      "\"top energetic beats\"", "\"workout music\"", "\"high-energy tracks\"",
      "\"pump-up songs\"", "\"motivational music\"", "\"gym playlist\"",
      "\"running tracks\"", "\"top dance hits\"", "\"power workout\""
    ]
    let relaxedKeywords = [
      "\"top chill vibes\"", "\"top relaxing music\"", "\"popular mellow tunes\"",
      "\"top soft music\"", "\"popular peaceful melodies\"", "\"easy listening\"",
      "\"top calm vibes\"", "\"popular soothing sounds\"", "\"gentle acoustic songs\""
    ]
    
    switch mood {
    case .happy:
      return happyKeywords.randomElement() ?? "\"happy music\""
    case .sad:
      return sadKeywords.randomElement() ?? "\"sad songs\""
    case .energetic:
      return energeticKeywords.randomElement() ?? "\"energetic beats\""
    case .relaxed:
      return relaxedKeywords.randomElement() ?? "\"chill vibes\""
    }
  }
}

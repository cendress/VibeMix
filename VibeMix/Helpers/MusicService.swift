//
//  MusicService.swift
//  VibeMix
//
//  Created by Christopher Endress on 3/23/24.
//

import Foundation

//MARK: - Necessary structs to create objects that are used by Spotify API

// Define a model for a Spotify track conforming to Codable for JSON decoding and encoding
struct SpotifyTrack: Codable {
  let name: String
  let id: String
  let album: Album
  
  // Computed property to extract the primary artist's name from the album's artist list
  var artistName: String {
    album.artists.first?.name ?? "Unknown Artist"
  }
  
  // Computed property to get the URL of the album's primary image
  var imageUrl: URL? {
    URL(string: album.images.first?.url ?? "")
  }
}

// Represents album information, including images and artists, also conforming to Codable
struct Album: Codable {
  let images: [SpotifyImage]
  let artists: [Artist]
}

// Defines an artist model with a name property
struct Artist: Codable {
  let name: String
}

// Represents a Spotify image, providing the URL as a String
struct SpotifyImage: Codable {
  let url: String
}

struct SpotifyRecommendationsResponse: Codable {
  let tracks: [SpotifyTrack]
}

// Model for the top-level response from a Spotify track search
struct SpotifySearchResponse: Codable {
  let tracks: SpotifyTracksResponse
}

// Encapsulates the track list part of the search response
struct SpotifyTracksResponse: Codable {
  let items: [SpotifyTrack]
}

//MARK: - MusicService class

// MusicService class designed as a singleton for fetching songs from Spotify
class MusicService {
  // Shared instance for accessing the MusicService globally
  static let shared = MusicService()
  
  private init() {}
  
  // Public method to fetch songs based on the provided MoodOption. The completion handler returns a Result type containing an array of SpotifyTrack or an error
  func fetchSongs(forMood mood: MoodOption, completion: @escaping (Result<[SpotifyTrack], Error>) -> Void) {
    // Request an access token from the SpotifyAuthService
    SpotifyAuthService.shared.requestAccessToken { [weak self] result in
      switch result {
      case .success(let accessToken):
        // On success, perform a search on Spotify using the access token and the provided mood
        self?.performSpotifySearch(forMood: mood, accessToken: accessToken, completion: completion)
      case .failure(let error):
        // If there's an error in obtaining the access token, return the error through the completion handler
        completion(.failure(error))
      }
    }
  }
  
  // Private method to perform the actual Spotify search request
  private func performSpotifySearch(forMood mood: MoodOption, accessToken: String, completion: @escaping (Result<[SpotifyTrack], Error>) -> Void) {
    let searchQuery = self.moodToSearchQuery(mood)
    let urlString = "https://api.spotify.com/v1/recommendations?seed_genres=\(searchQuery)&limit=25"
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
        let response = try JSONDecoder().decode(SpotifyRecommendationsResponse.self, from: data)
        completion(.success(response.tracks))
      } catch {
        completion(.failure(error))
      }
    }
    task.resume()
  }
  
  // Converts a MoodOption to a suitable search query for Spotify
  private func moodToSearchQuery(_ mood: MoodOption) -> String {
    switch mood {
    case .happy:
      return "pop,dance"
    case .sad:
      return "blues,soul"
    case .energetic:
      return "electronic,rock"
    case .relaxed:
      return "jazz,classical"
    }
  }
}

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
  
  // Public method to fetch songs based on the provided MoodOption. The completion handler returns a Result type containing an array of SpotifyTrack or an error.
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
    // Convert the mood to a search query string
    let searchQuery = self.moodToSearchQuery(mood)
    // Construct the search URL
    let urlString = "https://api.spotify.com/v1/search?q=\(searchQuery)&type=track&limit=25"
    // Ensure the URL is valid
    guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
      completion(.failure(NSError(domain: "MusicService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
      return
    }
    
    // Create a URLRequest object and set the authorization header with the access token
    var request = URLRequest(url: url)
    request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    
    // Execute the network request
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      // Ensure data was received and there were no errors
      guard let data = data, error == nil else {
        completion(.failure(error ?? NSError(domain: "MusicService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch data"])))
        return
      }
      
      // Attempt to decode the JSON response into SpotifySearchResponse
      do {
        let response = try JSONDecoder().decode(SpotifySearchResponse.self, from: data)
        // On success, return the items (tracks) found
        completion(.success(response.tracks.items))
      } catch {
        // If decoding fails, return the error
        completion(.failure(error))
      }
    }
    // Start the network task
    task.resume()
  }
  
  // Converts a MoodOption to a suitable search query for Spotify
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

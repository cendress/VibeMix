//
//  SpotifyAuthService.swift
//  VibeMix
//
//  Created by Christopher Endress on 3/23/24.
//

import Foundation

// Spotify authentication service for obtaining access tokens
class SpotifyAuthService {
  static let shared = SpotifyAuthService()
  
  private init() {}
  
  // API credentials and token request URL.
  private let clientId = TokenProvider.clientId
  private let clientSecret = TokenProvider.clientSecret
  private let tokenUrl = "https://accounts.spotify.com/api/token"
  
  // Requests an access token using client credentials flow
  func requestAccessToken(completion: @escaping (Result<String, Error>) -> Void) {
    guard let tokenRequestURL = URL(string: tokenUrl) else {
      completion(.failure(NSError(domain: "SpotifyAuthService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid token URL"])))
      return
    }
    
    var request = URLRequest(url: tokenRequestURL)
    request.httpMethod = "POST"
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    let bodyComponents = "grant_type=client_credentials"
    let authString = "\(clientId):\(clientSecret)".data(using: .utf8)?.base64EncodedString() ?? ""
    request.addValue("Basic \(authString)", forHTTPHeaderField: "Authorization")
    request.httpBody = bodyComponents.data(using: .utf8)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      guard let data = data, error == nil else {
        completion(.failure(error ?? NSError(domain: "SpotifyAuthService", code: 1, userInfo: [NSLocalizedDescriptionKey: "No response from server"])))
        return
      }
      
      do {
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let accessToken = json["access_token"] as? String {
          completion(.success(accessToken))
        } else {
          completion(.failure(NSError(domain: "SpotifyAuthService", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
        }
      } catch {
        completion(.failure(error))
      }
    }
    task.resume()
  }
}


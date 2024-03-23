//
//  PlaylistView.swift
//  VibeMix
//
//  Created by Christopher Endress on 3/23/24.
//

import SwiftUI

struct PlaylistView: View {
  var mood: MoodOption
  @State private var tracks: [SpotifyTrack] = []
  @State private var showError = false
  
  var body: some View {
    List(tracks, id: \.id) { track in
      Text(track.name)
    }
    .onAppear {
      MusicService.shared.fetchSongs(forMood: mood) { result in
        switch result {
        case .success(let fetchedTracks):
          self.tracks = fetchedTracks
        case .failure:
          self.showError = true
        }
      }
    }
    .alert("Error", isPresented: $showError) {
      Button("OK", role: .cancel) { }
    } message: {
      Text("Could not load songs. Please check your internet connection.")
    }
  }
}

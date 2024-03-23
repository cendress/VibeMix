//
//  PlaylistView.swift
//  VibeMix
//
//  Created by Christopher Endress on 3/23/24.
//

import SwiftUI
import MusicKit

struct PlaylistView: View {
  var mood: MoodOption
  @State private var songs: [MusicKit.Song] = []
  @State private var showError = false
  
  var body: some View {
    List(songs, id: \.id) { song in
      Text(song.title)
    }
    .onAppear {
      MusicService.shared.fetchSongs(forMood: mood) { result in
        switch result {
        case .success(let fetchedSongs):
          self.songs = fetchedSongs
        case .failure:
          self.showError = true
        }
      }
    }
    .alert("Error", isPresented: $showError) {
      Button("OK", role: .cancel) { }
    } message: {
      Text("Could not load songs. Please check your music authorization and internet connection.")
    }
  }
}

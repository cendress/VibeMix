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
    VStack {
      Text("Playlist")
        .font(.title)
      
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
      
      Spacer()
      Spacer()
      
      PlaylistViewButtons()
    }
  }
}

struct PlaylistViewButtons: View {
  var body: some View {
    NavigationView {
      HStack(spacing: 10) {
        NavigationLink(destination: SavedPlaylistsView()) {
          HStack {
            Image(systemName: "square.and.arrow.down")
            Text("Save")
          }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color("AppColor"))
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        
        NavigationLink(destination: MoodPromptView()) {
          HStack {
            Image(systemName: "gobackward")
            Text("Reshuffle")
          }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color("AppColor"))
            .foregroundColor(.white)
            .cornerRadius(10)
        }
      }
      .padding(.horizontal, 20)
    }
  }
}

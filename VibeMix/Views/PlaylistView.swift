//
//  PlaylistView.swift
//  VibeMix
//
//  Created by Christopher Endress on 3/23/24.
//

import AVFoundation
import SwiftUI

struct PlaylistView: View {
  // Variable to determine what mood to fetch
  var mood: MoodOption
  @State private var tracks: [SpotifyTrack] = []
  @State private var showError = false
  @State private var isLoading = true
  
  var body: some View {
      VStack {
        if isLoading {
          // Show a loading indicator while the tracks are loading
          ProgressView()
            .scaleEffect(1.5)
            .progressViewStyle(CircularProgressViewStyle(tint: Color("AppColor")))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
          // Create a list displaying tracks
          List(tracks, id: \.id) { track in
            HStack {
              // Display an image if the URL exists. If not, display a placeholder
              if let imageUrl = track.imageUrl {
                AsyncImage(url: imageUrl) { image in
                  image.resizable()
                } placeholder: {
                  Color.gray
                }
                .frame(width: 50, height: 50)
                .cornerRadius(5)
              } else {
                Image(systemName: "music.note")
                  .frame(width: 50, height: 50)
              }
              
              // Display track name and artist
              VStack(alignment: .leading) {
                Text(track.name)
                  .fontWeight(.bold)
                Text(track.artistName)
                  .font(.caption)
              }
            }
          }
          
          PlaylistViewButtons()
        }
      }
      // Fetch songs when the view appears
      .onAppear {
        MusicService.shared.fetchSongs(forMood: mood) { result in
          switch result {
          case .success(let fetchedTracks):
            self.tracks = fetchedTracks
            self.isLoading = false
          case .failure:
            self.showError = true
            self.isLoading = false
          }
        }
      }
      
      // Show errors if songs can't be fetched
      .alert("Error", isPresented: $showError) {
        Button("OK", role: .cancel) { }
      } message: {
        Text("Could not load songs. Please check your internet connection.")
      }
  }
}

// Define buttons view to perform actions
struct PlaylistViewButtons: View {
  var body: some View {
    HStack {
      Button(action: {
        // Perform an action
        // Refetch new songs
      }) {
        HStack {
          Image(systemName: "gobackward")
          Text("Reshuffle")
        }
        .frame(maxWidth: .infinity)
        .padding(15)
        .background(Color("AppColor"))
        .foregroundColor(.white)
        .cornerRadius(10)
      }
      
      Button(action: {
        // Perform an action
        // Save the playlist
      }) {
        HStack {
          Image(systemName: "square.and.arrow.down")
          Text("Save")
        }
        .frame(maxWidth: .infinity)
        .padding(15)
        .background(Color("AppColor"))
        .foregroundColor(.white)
        .cornerRadius(10)
      }
    }
    .padding(.horizontal, 40)
    .padding(.bottom)
  }
}

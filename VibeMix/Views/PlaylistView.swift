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
    GeometryReader { geometry in
      VStack {
        Text("Playlist")
          .font(.title)
        
        List(tracks, id: \.id) { track in
          HStack {
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
            
            VStack(alignment: .leading) {
              Text(track.name)
                .fontWeight(.bold)
              Text(track.artistName)
                .font(.caption)
            }
          }
        }
        .frame(minHeight: 0, maxHeight: .infinity)
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
        
        PlaylistViewButtons()
          .frame(height: geometry.size.height * 0.2)
      }
    }
  }
}

struct PlaylistViewButtons: View {
  var body: some View {
    HStack {
      Button(action: {
        //do something
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
      
      Button(action: {
        // do something
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
    }
    .padding(.horizontal, 40)
    .padding(.bottom)
  }
}

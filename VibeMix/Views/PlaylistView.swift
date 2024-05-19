//
//  PlaylistView.swift
//  VibeMix
//
//  Created by Christopher Endress on 3/23/24.
//

import AVFoundation
import SwiftUI

struct PlaylistView: View {
  var mood: MoodOption
  @State private var tracks: [SpotifyTrack] = []
  @State private var showError = false
  @State private var isLoading = true
  @State private var audioPlayer: AVAudioPlayer?
  @State private var playlistName = ""
  @State private var showingNameSheet = false
  
  @Environment(\.managedObjectContext) private var viewContext
  @EnvironmentObject var tabSelection: TabSelection
  
  var body: some View {
    VStack {
      if isLoading {
        ProgressView()
          .scaleEffect(1.5)
          .progressViewStyle(CircularProgressViewStyle(tint: Color("AppColor")))
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      } else {
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
            
            Spacer()
            
            Button(action: {
              playPausePreview(track: track)
            }) {
              Image(systemName: audioPlayer != nil && audioPlayer!.isPlaying ? "pause.circle" : "play.circle")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(Color("AppColor"))
            }
          }
        }
      }
      
      PlaylistViewButtons(reshuffleAction: fetchSongs, saveAction: {
        self.showingNameSheet = true
      })
    }
    .sheet(isPresented: $showingNameSheet, onDismiss: savePlaylist) {
      VStack(alignment: .leading, spacing: 30) {
        HStack {
          Button(action: {
            self.showingNameSheet = false
          }) {
            Image(systemName: "xmark.circle.fill")
              .imageScale(.large)
              .foregroundColor(.gray)
          }
        }
        
        VStack(spacing: 20) {
          Text("Enter Playlist Name")
            .font(.headline)
            .padding(.horizontal)
          
          TextField("Playlist Name", text: $playlistName)
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(8)
            .shadow(radius: 1)
          
          Button(action: {
            self.showingNameSheet = false
          }) {
            Text("Save")
              .foregroundColor(.white)
              .frame(maxWidth: .infinity)
              .padding()
              .background(Color("AppColor"))
              .cornerRadius(12)
          }
          .buttonStyle(PlainButtonStyle())
          .padding(.horizontal)
        }
        .frame(maxWidth: 300)
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(radius: 10)
      }
    }
    
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
    .alert("Error", isPresented: $showError) {
      Button("OK", role: .cancel) { }
    } message: {
      Text("Could not load songs. Please check your internet connection.")
    }
  }
  
  private func savePlaylist() {
    let newPlaylist = Playlist(context: viewContext)
    newPlaylist.createdAt = Date()
    newPlaylist.mood = mood.rawValue
    newPlaylist.playlistID = UUID().uuidString
    newPlaylist.name = playlistName.trimmingCharacters(in: .whitespacesAndNewlines)
    
    do {
      try viewContext.save()
      self.tabSelection.selectedTab = 1
    } catch {
      let nsError = error as NSError
      fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
  }
  
  private func fetchSongs() {
    if let player = audioPlayer, player.isPlaying {
      player.stop()
      self.audioPlayer = nil
    }
    
    isLoading = true
    
    MusicService.shared.fetchSongs(forMood: mood) { result in
      DispatchQueue.main.async {
        switch result {
        case .success(let fetchedTracks):
          self.tracks = fetchedTracks
        case .failure:
          self.showError = true
        }
        self.isLoading = false
      }
    }
  }
  
  private func playPausePreview(track: SpotifyTrack) {
    guard let previewUrl = track.previewUrl, let url = URL(string: previewUrl) else {
      print("Invalid URL or no preview available")
      return
    }
    
    if let player = audioPlayer, player.isPlaying {
      player.stop()
      self.audioPlayer = nil
      print("Audio stopped")
    } else {
      do {
        let soundData = try Data(contentsOf: url)
        audioPlayer = try AVAudioPlayer(data: soundData)
        audioPlayer?.play()
        print("Audio playing")
      } catch {
        print("Playback failed.")
      }
    }
  }
}

struct PlaylistViewButtons: View {
  var reshuffleAction: () -> Void
  var saveAction: () -> Void
  
  var body: some View {
    HStack {
      Button(action: reshuffleAction) {
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
      
      Button(action: saveAction)  {
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

//
//  PlaylistRowView.swift
//  VibeMix
//
//  Created by Christopher Endress on 4/28/24.
//

import SwiftUI

struct PlaylistRowView: View {
  let playlist: Playlist
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      if let name = playlist.name, !name.isEmpty {
        Text(name)
          .font(.headline)
          .foregroundColor(.primary)
          .lineLimit(1)
          .truncationMode(.tail)
      }
      
      Text("Mood: \(playlist.mood ?? "N/A")")
        .font(.subheadline)
        .foregroundColor(.secondary)
        .lineLimit(1)
        .truncationMode(.tail)
      
      Text("\(playlist.createdAt ?? Date(), formatter: itemFormatter)")
        .font(.subheadline)
        .foregroundColor(.secondary)
        .lineLimit(1)
        .truncationMode(.tail)
    }
  }
  
  private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
  }()
}


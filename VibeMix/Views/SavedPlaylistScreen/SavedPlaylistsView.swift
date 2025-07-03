//
//  SavedPlaylistView.swift
//  VibeMix
//
//  Created by Christopher Endress on 3/23/24.
//

import CoreData
import SwiftUI

struct SavedPlaylistsView: View {
  @Environment(\.managedObjectContext) var viewContext
  @FetchRequest(
    entity: Playlist.entity(),
    sortDescriptors: [NSSortDescriptor(keyPath: \Playlist.createdAt, ascending: false)],
    animation: .default)
  var playlists: FetchedResults<Playlist>
  
  var body: some View {
    NavigationView {
      List {
        ForEach(playlists, id: \.self) { playlist in
          PlaylistRowView(playlist: playlist)
            .padding(.vertical, 8)
        }
        .onDelete(perform: deletePlaylists)
      }
      .navigationTitle("Saved Playlists")
      .toolbar {
        EditButton()
      }
    }
  }
  
  private func deletePlaylists(offsets: IndexSet) {
    withAnimation {
      offsets.map { playlists[$0] }.forEach(viewContext.delete)
      saveContext()
    }
  }
  
  private func saveContext() {
    do {
      try viewContext.save()
    } catch {
      let nsError = error as NSError
      fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
  }
}

#Preview {
  SavedPlaylistsView()
}

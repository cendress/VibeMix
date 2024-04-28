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
          VStack(alignment: .leading, spacing: 8) {
            if let name = playlist.name, !name.isEmpty {
              Text(name)
                .font(.headline)
            }
            Text("Mood: \(playlist.mood ?? "N/A")")
            Text("\(playlist.createdAt ?? Date(), formatter: itemFormatter)")
              .font(.subheadline)
          }
          .padding(.vertical, 4)
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

private let itemFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateStyle = .long
  formatter.timeStyle = .none
  return formatter
}()

#Preview {
  SavedPlaylistsView()
}

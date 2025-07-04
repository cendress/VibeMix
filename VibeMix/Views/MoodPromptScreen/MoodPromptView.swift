//
//  MoodPromptView.swift
//  VibeMix
//
//  Created by Christopher Endress on 3/23/24.
//

import SwiftUI

struct MoodPromptView: View {
    @State private var selectedMood: MoodOption? = nil
    @State private var navigateToMood: MoodOption? = nil
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Text("What's the vibe?")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Spacer()
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(MoodOption.allCases, id: \.self) { mood in
                        MoodOptionButtonView(
                            mood: mood,
                            isSelected: selectedMood == mood
                        ) {
                            selectedMood = mood
                        }
                    }
                    .padding(.horizontal, 8)
                }
                .padding(.horizontal, 16)
                
                Spacer()
                
                CustomButtonView(imageName: "music.note.list", title: "Find My Vibe") {
                    if let selected = selectedMood {
                        navigateToMood = selected
                    }
                }
                    .disabled(selectedMood == nil)
                
                Spacer()
            }
            .navigationTitle("New Playlist")
            .navigationDestination(item: $navigateToMood) { mood in
                PlaylistView(mood: mood)
            }
        }
    }
}

#Preview {
    MoodPromptView()
}

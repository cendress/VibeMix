//
//  MoodPromptView.swift
//  VibeMix
//
//  Created by Christopher Endress on 3/23/24.
//

import SwiftUI

struct MoodPromptView: View {
    @State private var selectedMood: MoodOption? = nil
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Text("How are you feeling?")
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
                
                // Navigate by updating selectedMood (triggers navigationDestination)
                Button(action: {}) {
                    NavigationLink(value: selectedMood) {
                        HStack {
                            Image(systemName: "music.note.list")
                            Text("Find My Vibe")
                                .font(.headline)
                        }
                        .padding()
                        .background(Color("AppColor"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(selectedMood == nil)
                }
                
                Spacer()
            }
            .navigationTitle("New Playlist")
            .navigationDestination(for: MoodOption.self) { mood in
                PlaylistView(mood: mood)
            }
        }
    }
}

#Preview {
    MoodPromptView()
}

#Preview {
    MoodPromptView()
}

//
//  MoodPromptView.swift
//  VibeMix
//
//  Created by Christopher Endress on 3/23/24.
//

import SwiftUI

struct MoodPromptView: View {
  @State private var selectedMood: MoodOption?
  @State private var isButtonSelected = false
  
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
        
        // LazyVGrid for creating a grid layout
        LazyVGrid(columns: columns, spacing: 24) {
          ForEach(MoodOption.allCases, id: \.self) { mood in
            Button(action: {
              // Set the selected mood and reset button selection when buttons are tapped
              self.selectedMood = mood
              self.isButtonSelected = false
            }) {
              VStack {
                Image(systemName: mood.symbol)
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(width: 50, height: 50)
                
                Text(mood.description)
                      .font(.headline)
              }
              .padding()
              .frame(maxWidth: .infinity, maxHeight: 200)
              .background(self.selectedMood == mood ? Color("AppColor") : Color.white)
              .foregroundColor(self.selectedMood == mood ? Color.white : Color("AppColor"))
              .cornerRadius(25)
            }
            // Style the button with a border and rounded corners
            .overlay(
              RoundedRectangle(cornerRadius: 20)
                .stroke(selectedMood == mood ? Color.clear : Color("AppColor"), lineWidth: 2)
            )
          }
          .padding(.horizontal, 10)
        }
        .padding(.horizontal, 16)
        
        Spacer()
        
        // Create a "Find My Vibe" button that is enabled only if a mood is selected
        Button(action: {
          // Set isButtonSelected to true if a mood is selected to trigger navigation
          if self.selectedMood != nil {
            self.isButtonSelected = true
          }
        }) {
          HStack {
            Image(systemName: "music.note.list")
            Text("Find My Vibe")
                  .font(.headline)
          }
          .frame(maxWidth: .infinity)
          .padding()
          .background(Color("AppColor"))
          .foregroundColor(.white)
          .cornerRadius(10)
        }
        .padding(.horizontal, 100)
        .disabled(selectedMood == nil)
        
        // Create a NavigationLink that is activated when isButtonSelected is true
        if let selectedMood = selectedMood {
          NavigationLink(destination: PlaylistView(mood: selectedMood), isActive: $isButtonSelected) {
            EmptyView()
          }
        }
        
        Spacer()
      }
      .navigationTitle("New Playlist")
    }
  }
}

#Preview {
  MoodPromptView()
}

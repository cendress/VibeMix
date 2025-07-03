//
//  MoodOptionButtonView.swift
//  VibeMix
//
//  Created by Christopher Endress on 7/3/25.
//

import SwiftUI

struct MoodOptionButtonView: View {
    let mood: MoodOption
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: mood.symbol)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                
                Text(mood.description)
                    .font(.headline)
            }
            .padding(.vertical, 25)
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color("AppColor") : Color.white)
            .foregroundColor(isSelected ? Color.white : Color("AppColor"))
            .cornerRadius(25)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(isSelected ? Color.clear : Color("AppColor"), lineWidth: 2)
        )
    }
}

#Preview {
    MoodOptionButtonView(mood: MoodOption.energetic, isSelected: false, action: {})
}

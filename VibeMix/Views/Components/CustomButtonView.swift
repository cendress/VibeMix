//
//  CustomButtonView.swift
//  VibeMix
//
//  Created by Christopher Endress on 7/4/25.
//

import SwiftUI

struct CustomButtonView: View {
    let imageName: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            action()
        }) {
            HStack {
                Image(systemName: imageName)
                
                Text(title)
                    .font(.headline)
            }
            .padding(.vertical)
            .frame(maxWidth: .infinity)
            .background(Color("AppColor"))
            .foregroundColor(.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.primary, lineWidth: 1)
            )
            .shadow(radius: 1)
        }
    }
}

#Preview {
    CustomButtonView(imageName: "music.note.list", title: "Find My Vibe", action: {})
}

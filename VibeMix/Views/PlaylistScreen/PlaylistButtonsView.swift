//
//  PlaylistButtonsView.swift
//  VibeMix
//
//  Created by Christopher Endress on 7/4/25.
//

import SwiftUI

struct PlaylistButtonsView: View {
    var reshuffleAction: () -> Void
    var saveAction: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            CustomButtonView(imageName: "gobackward", title: "Reshuffle", action: reshuffleAction)
            
            CustomButtonView(imageName: "square.and.arrow.down", title: "Save", action: saveAction)
        }
        .padding(.horizontal, 40)
        .padding(.bottom)
    }
}

#Preview {
    PlaylistButtonsView(reshuffleAction: {}, saveAction: {})
}

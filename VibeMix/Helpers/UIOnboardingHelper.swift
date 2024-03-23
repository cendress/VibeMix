//
//  UIOnboardingHelper.swift
//  VibeMix
//
//  Created by Christopher Endress on 3/23/24.
//

import UIKit
import UIOnboarding

struct UIOnboardingHelper {
  // App Icon
  static func setUpIcon() -> UIImage {
    return Bundle.main.appIcon ?? .init(named: "onboarding-icon")!
  }
  
  // First Title Line
  // Welcome Text
  static func setUpFirstTitleLine() -> NSMutableAttributedString {
    .init(string: "Welcome to", attributes: [.foregroundColor: UIColor(named: "AppColor")!])
  }
  
  // Second Title Line
  // App Name
  static func setUpSecondTitleLine() -> NSMutableAttributedString {
    .init(string: Bundle.main.displayName ?? "VibeMix", attributes: [
      .foregroundColor: UIColor.init(named: "AppColor")!
    ])
  }
  
  // Core Features
  static func setUpFeatures() -> Array<UIOnboardingFeature> {
    return .init([
      .init(icon: UIImage(systemName: "bolt.fill")!,
            title: "Mood check-in",
            description: "Record how you feel to generate a curated playlist."),
      .init(icon: UIImage(systemName: "music.note")!,
            title: "Playlist generator",
            description: "Generate a personal playlist to match your vibe."),
      .init(icon: UIImage(systemName: "square.and.arrow.down")!,
            title: "Save your favorites",
            description: "Save your favorite playlists to listen on your own terms.")
    ])
  }
  
  // Notice Text
  static func setUpNotice() -> UIOnboardingTextViewConfiguration {
    return .init(icon: UIImage(systemName: "info.circle")!,
                 text: "Developed for music ethusiasts in mind.",
                 linkTitle: "Learn more",
                 link: "https://www.google.com/",
                 tint: .init(named: "AppColor"))
  }
  
  // Continuation Title
  static func setUpButton() -> UIOnboardingButtonConfiguration {
    return .init(title: "Continue",
                 titleColor: .white, // Optional, `.white` by default
                 backgroundColor: .init(named: "AppColor")!)
  }
}

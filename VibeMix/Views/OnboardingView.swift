//
//  OnboardingView.swift
//  VibeMix
//
//  Created by Christopher Endress on 3/23/24.
//

import SwiftUI
import UIOnboarding

struct OnboardingView: UIViewControllerRepresentable {
  typealias UIViewControllerType = UIOnboardingViewController
  
  func makeUIViewController(context: Context) -> UIOnboardingViewController {
    let onboardingController: UIOnboardingViewController = .init(withConfiguration: .setUp())
    onboardingController.delegate = context.coordinator
    return onboardingController
  }
  
  func updateUIViewController(_ uiViewController: UIOnboardingViewController, context: Context) {}
  
  class Coordinator: NSObject, UIOnboardingViewControllerDelegate {
    func didFinishOnboarding(onboardingViewController: UIOnboardingViewController) {
      onboardingViewController.dismiss(animated: true, completion: nil)
    }
  }
  
  func makeCoordinator() -> Coordinator {
    return .init()
  }
}

extension UIOnboardingViewConfiguration {
  // UIOnboardingViewController init
  static func setUp() -> UIOnboardingViewConfiguration {
    return .init(appIcon: UIOnboardingHelper.setUpIcon(),
                 firstTitleLine: UIOnboardingHelper.setUpFirstTitleLine(),
                 secondTitleLine: UIOnboardingHelper.setUpSecondTitleLine(),
                 features: UIOnboardingHelper.setUpFeatures(),
                 textViewConfiguration: UIOnboardingHelper.setUpNotice(),
                 buttonConfiguration: UIOnboardingHelper.setUpButton())
  }
}

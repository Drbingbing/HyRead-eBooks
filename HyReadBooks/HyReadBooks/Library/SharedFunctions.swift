//
//  SharedFunctions.swift
//  HRLibrary
//
//  Created by Bing Bing on 2023/11/18.
//

import Foundation
import UIKit

// MARK: - Haptic feedback

func generateImpactFeedback(
    feedbackGenerator: UIImpactFeedbackGeneratorType = UIImpactFeedbackGenerator(style: .light)
) {
    feedbackGenerator.prepare()
    feedbackGenerator.impactOccurred()
}

func generateSelectionFeedback(
    feedbackGenerator: UISelectionFeedbackGeneratorType = UISelectionFeedbackGenerator()
) {
    feedbackGenerator.prepare()
    feedbackGenerator.selectionChanged()
}

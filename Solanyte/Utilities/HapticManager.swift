//
//  HapticManager.swift
//  CryptoTrackerTutorial
//
//  Created by Фёдор Ткаченко on 04.01.22.
//

import Foundation
import SwiftUI

class HapticManager {
  static let generator = UINotificationFeedbackGenerator()
  
  static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
    generator.notificationOccurred(type)
  }
}

//
//  View.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 15.11.21.
//

import Foundation
import SwiftUI

extension View {
  /// Adds frame constraints to a View
  /// ```
  /// Makes width equal to (1 / 3.5) and trailing alignment
  /// ```
  func lastColumnStyled() -> some View {
    return self
      .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
  }
}


extension UIApplication {
  /// Hides keyboard
  /// ```
  /// Hides keyboard on call
  /// ```
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

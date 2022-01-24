//
//  CircleButtonAnimationView.swift
//  CryptoTrackerTutorial
//
//  Created by Фёдор Ткаченко on 10.11.21.
//

import SwiftUI

struct CircleButtonAnimationView: View {
  @Binding var animate: Bool

  var body: some View {
    Circle()
      .stroke(lineWidth: 5.0)
      .scale(animate ? 1.0 : 0.0)
      .opacity(animate ? 0.0 : 1.0)
      .animation(animate ? Animation.easeOut(duration: 1.0) : .none)
  }
}

struct CircleButtonAnimationView_Previews: PreviewProvider {
  static var previews: some View {
    CircleButtonAnimationView(animate: .constant(true))
  }
}

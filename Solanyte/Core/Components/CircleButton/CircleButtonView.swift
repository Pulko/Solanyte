//
//  CircleButtonView.swift
//  CryptoTrackerTutorial
//
//  Created by Фёдор Ткаченко on 08.11.21.
//

import SwiftUI

struct CircleButtonView: View {
  let iconName: String
  let action: () -> Void
  
  init(_ iconName: String, action: @escaping (() -> Void) = {}) {
    self.iconName = iconName
    self.action = action
  }
  
  var body: some View {
    Image(systemName: iconName)
      .foregroundColor(.theme.accent)
      .font(.headline)
      .frame(width: 50, height: 50, alignment: .center)
      .background(
        Circle()
          .foregroundColor(.theme.secondaryText.opacity(0.1))
      )
      .padding()
      .onTapGesture(perform: action)
  }
}

struct CircleButtonView_Previews: PreviewProvider {
  static var previews: some View {
    CircleButtonView("info")
      .previewLayout(.sizeThatFits)
    
    CircleButtonView("plus")
      .padding()
      .previewLayout(.sizeThatFits)
      .preferredColorScheme(.dark)
  }
}

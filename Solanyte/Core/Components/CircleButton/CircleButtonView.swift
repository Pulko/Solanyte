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
  
  var width: Double
  var height: Double
  
  init(
    _ iconName: String,
    width: Double = 50,
    height: Double = 50,
    action: @escaping (() -> Void) = {}
  ) {
    self.iconName = iconName
    self.action = action
    self.width = width
    self.height = height
  }
  
  var body: some View {
    Image(systemName: iconName)
      .foregroundColor(.theme.accent)
      .font(.headline)
      .frame(width: width, height: height, alignment: .center)
      .background(
        Rectangle()
          .foregroundColor(.theme.secondaryText.opacity(0.1))
          .cornerRadius(CGFloat(20))
      )
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

//
//  CircleButtonView.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 08.11.21.
//

import SwiftUI

struct CircleButtonView: View {
  let systemName: String
  let name: String
  let action: () -> Void
  
  var width: Double
  var height: Double
  
  var rotate: Bool
  
  init(
    _ systemName: String = "",
    name: String = "",
    width: Double = 50,
    height: Double = 50,
    rotate: Bool = false,
    action: @escaping (() -> Void) = {}
  ) {
    self.systemName = systemName
    self.name = name
    self.action = action
    self.width = width
    self.height = height
    self.rotate = rotate
  }
  
  private func imageElement() -> some View {
    if (!systemName.isEmpty) {
      return Image(systemName: systemName)
    } else if (!name.isEmpty) {
      return Image(name).resizable()
    } else {
      return Image(systemName: "pencil")
    }
  }
  
  var body: some View {
    imageElement()
      .frame(width: width / 2, height: height / 2, alignment: .center)
      .rotationEffect(Angle.degrees(rotate ? 360 : 0), anchor: .center)
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
      .padding()
      .previewLayout(.sizeThatFits)
    
    CircleButtonView("plus")
      .padding()
      .previewLayout(.sizeThatFits)
      .preferredColorScheme(.dark)
    
    CircleButtonView(name: "solana-logo")
      .padding()
      .previewLayout(.sizeThatFits)
  }
}

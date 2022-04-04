//
//  AccentButton.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 24.03.22.
//

import SwiftUI

struct AccentButton<T: View>: View {
  let content: () -> T
  let padding: CGFloat
  let perform: () -> Void
  
  init(
    padding: CGFloat = 15,
    perform: @escaping () -> Void = {},
    content: @escaping (() -> T)
  ) {
    self.content = content
    self.padding = padding
    self.perform = perform
  }
  
  
  var body: some View {
    content()
      .padding(padding)
      .onTapGesture(perform: perform)
      .background(
        Rectangle()
          .foregroundColor(.theme.secondaryText.opacity(0.1))
          .cornerRadius(CGFloat(20))
      )
    
  }
}

struct AccentButton_Previews: PreviewProvider {
  static var previews: some View {
    AccentButton(perform: {}) {
      Text("Accent Button")
    }
  }
}

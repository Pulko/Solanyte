//
//  XmarkButton.swift
//  CryptoTrackerTutorial
//
//  Created by Фёдор Ткаченко on 13.12.21.
//

import SwiftUI

struct XmarkButton: View {
  @Environment(\.presentationMode) var presentationMode

  var body: some View {
    Button(action: {
      presentationMode.wrappedValue.dismiss()
      // standard way to dismiss sheet in swiftui
    }, label: {
      Image(systemName: "xmark")
        .font(.headline)
    })
  }
}

struct XmarkButton_Previews: PreviewProvider {
  static var previews: some View {
    XmarkButton()
  }
}

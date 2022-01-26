//
//  ActivityIndicator.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 26.01.22.
//

import SwiftUI

struct ActivityIndicator: View {
  var body: some View {
    ProgressView()
      .progressViewStyle(CircularProgressViewStyle())
  }
}

struct ActivityIndicator_Previews: PreviewProvider {
  static var previews: some View {
    ActivityIndicator()
  }
}

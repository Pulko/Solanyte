//
//  Color.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 08.11.21.
//

import Foundation
import SwiftUI

extension Color {
  static let theme = ColorTheme()
}

struct ColorTheme {
  let accent = Color("AccentColor")
  let background = Color("BackgroundColor")
  let green = Color("GreenColor")
  let red = Color("RedColor")
  let secondaryText = Color("SecondaryTextColor")
  let container = Color("ContainerColor")
}

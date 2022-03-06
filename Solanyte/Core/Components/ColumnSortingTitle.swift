//
//  ColumnSortingTitle.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 05.01.22.
//

import SwiftUI

struct ColumnSortingTitle: View {
  @EnvironmentObject private var vm: HomeViewModel
  
  var text: String
  var option: SortOption
  var optionReversed: SortOption
  
  init(_ text: String, option: SortOption, optionReversed: SortOption) {
    self.text = text
    self.option = option
    self.optionReversed = optionReversed
  }
  
  var arrowOpacity: Double {
    vm.sortOption == option || vm.sortOption == optionReversed ? 1 : 0
  }
  
  var rotationAngle: Angle {
    Angle(degrees: vm.sortOption == optionReversed ? 180 : 0)
  }
  
  var body: some View {
    HStack(spacing: 4) {
      Text(text)
      Image(systemName: "chevron.down")
        .opacity(arrowOpacity)
        .rotationEffect(rotationAngle)
    }
    .onTapGesture {
      withAnimation {
        vm.sortOption = (vm.sortOption == option ? optionReversed : option)
      }
    }
  }
}

struct ColumnSortingTitle_Previews: PreviewProvider {
  static var previews: some View {
    ColumnSortingTitle("Holdings", option: .holdings, optionReversed: .holdingsReversed)
      .environmentObject(dev.homeVM)
  }
}

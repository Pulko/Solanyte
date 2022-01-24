//
//  HomeStatsView.swift
//  CryptoTrackerTutorial
//
//  Created by Фёдор Ткаченко on 03.12.21.
//

import SwiftUI

struct HomeStatsView: View {
  @Binding var showPortfolio: Bool
  @EnvironmentObject private var vm: HomeViewModel
  
  var body: some View {
    HStack {
      ForEach(vm.statistics) { stat in
        StatisticView(stat: stat)
          .frame(width: UIScreen.main.bounds.width / 3)
      }
    }
    .frame(width: UIScreen.main.bounds.width, alignment: self.showPortfolio ? .trailing : .leading)
  }
}

struct HomeStatsView_Previews: PreviewProvider {
  static var previews: some View {
    HomeStatsView(showPortfolio: .constant(false))
      .environmentObject(dev.homeVM)
  }
}

//
//  HomeStatsView.swift
//  CryptoTrackerTutorial
//
//  Created by Фёдор Ткаченко on 03.12.21.
//

import SwiftUI

struct HomeStatsView: View {
  @EnvironmentObject private var vm: HomeViewModel
  
  private var updateButton: some View {
    Button(action: {
      withAnimation(.linear(duration: 2)) {
        vm.reloadData()
      }
    }, label: {
      Image(systemName: "arrow.triangle.2.circlepath")
        .foregroundColor(.theme.secondaryText)
    })
    .rotationEffect(Angle.degrees(vm.isLoading ? 360 : 0), anchor: .center)
    .padding()

  }
  
  var body: some View {
    HStack {
      ForEach(vm.statistics) { stat in
        StatisticView(stat: stat)
          .frame(width: UIScreen.main.bounds.width / 3)
      }
      updateButton
    }
  }
}

struct HomeStatsView_Previews: PreviewProvider {
  static var previews: some View {
    HomeStatsView()
      .environmentObject(dev.homeVM)
  }
}

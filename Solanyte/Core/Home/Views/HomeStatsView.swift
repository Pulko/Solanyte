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
  }
  
  private var clearButton: some View {
    Button(action: {
      withAnimation() {
        vm.removeData()
      }
    }, label: {
      Image(systemName: "trash")
        .foregroundColor(.theme.secondaryText)
    })
    
  }
  
  var body: some View {
    HStack() {
      clearButton
        .padding()
      
      updateButton
        .padding()
    }
  }
}

struct HomeStatsView_Previews: PreviewProvider {
  static var previews: some View {
    HomeStatsView()
      .environmentObject(dev.homeVM)
  }
}

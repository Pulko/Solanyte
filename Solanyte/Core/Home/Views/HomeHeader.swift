//
//  HomeHeader.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 24.02.22.
//

import SwiftUI

struct HomeHeader: View {
  @EnvironmentObject private var vm: HomeViewModel
  @Binding var showSettingsView: Bool
  @Binding var showPortfolioView: Bool
  
  private var isContent: Bool {
    coinsToRender.count > 0
  }
  private var coinsToRender: Array<CoinModel> {
    vm.portfolioCoins
  }
  
  var body: some View {
    VStack {
      navigation
      
      if isContent {
        withAnimation {
          HStack {
            hideZeroBalance
            Spacer()
            updateButton
          }
          .padding([.bottom, .horizontal])
        }
      } else {
        portfolioEmptytext
      }
    }
    .background(Color.theme.container)
    .cornerRadius(CGFloat(20))
    .padding()
  }
}

extension HomeHeader {
  private var portfolioEmptytext: some View {
    Text("Tap + to add a Solana wallet")
      .font(.callout)
      .foregroundColor(.theme.accent)
      .padding(50)
  }
  
  private var updateButton: some View {
    CircleButtonView("arrow.triangle.2.circlepath", rotate: vm.isLoading) {
      withAnimation(.linear(duration: 2)) {
        vm.reloadData()
      }
    }
  }
  
  private var hideZeroBalance: some View {
    VStack(alignment: .leading) {
      Toggle("", isOn: $vm.isAboveZero)
        .labelsHidden()
        .toggleStyle(SwitchToggleStyle(tint: .theme.secondaryText))
      Text("Hide zero")
        .foregroundColor(.theme.accent)
        .fontWeight(.light)
        .font(.caption2)
    }
    .padding(.vertical)
  }
  
  private var navigation: some View {
    HStack {
      CircleButtonView("ellipsis") {
        showSettingsView.toggle()
      }
      .animation(.none)
      
      Spacer()
      
      VStack {
        Text(isContent ? vm.portfolioValue.asCurrencyWith2Decimals() : "Solanyte")
          .font(.title)
          .fontWeight(.heavy)
          .foregroundColor(.theme.accent)
          .animation(.none)
        if (isContent) {
          Text(vm.walletEntity?.key ?? "")
            .foregroundColor(.theme.accent)
            .frame(width: 100)
            .lineLimit(1)
            .truncationMode(.middle)
        }
      }
      
      Spacer()
      
      CircleButtonView(isContent ? "trash" : "plus") {
        withAnimation(.spring()) {
          if isContent {
            vm.removeData()
          } else {
            showPortfolioView.toggle()
          }
        }
      }
    }
    .padding()
  }
}


struct HomeHeader_Previews: PreviewProvider {
  static var previews: some View {
    HomeHeader(
      showSettingsView: .constant(false),
      showPortfolioView: .constant(false)
    )
      .environmentObject(dev.homeVM)
  }
}

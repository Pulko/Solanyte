//
//  HomeView.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 08.11.21.
//

import SwiftUI

struct HomeView: View {
  @EnvironmentObject private var vm: HomeViewModel
  
  @State private var showWalletView: Bool = false
  @State private var showSettingsView: Bool = false
  @State private var showRemoveWalletSheet: Bool = false
  
  private var isContent: Bool {
    coinsToRender.count > 0
  }
  
  private var coinsToRender: Array<CoinModel> {
    vm.portfolioCoins
  }
  
  var body: some View {
    ZStack {
      // background
      background
        .sheet(isPresented: $showWalletView, content: {
          WalletView()
        })
      // content
      VStack {
        HomeHeader(
          showSettingsView: $showSettingsView,
          showWalletView: $showWalletView,
          showRemoveWalletSheet: $showRemoveWalletSheet
        )
        
        if isContent {
          columnTitles
          coinsList
        }
        
        Spacer(minLength: 0)
        RemoveWalletAlert(showRemoveWalletSheet: $showRemoveWalletSheet)
      }
      .sheet(isPresented: $showSettingsView, content: {
        SettingsView()
      })
    }
  }
}

extension HomeView {
  private var background: some View {
    Color.theme.background
      .ignoresSafeArea()
  }
  
  private var coinsList: some View {
    List {
      ForEach(coinsToRender) { coin in
        NavigationLink(
          destination: NavigationLazyView(DetailView(coin: coin)),
          label: {
            CoinRowView(coin: coin, showHoldings: true)
          }
        )
          .listRowBackground(Color.theme.background)
          .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
      }
    }
    .listStyle(PlainListStyle())
    .transition(.move(edge: .leading))
  }
  
  private var columnTitles: some View {
    HStack{
      ColumnSortingTitle("Coin", option: .rank, optionReversed: .rankReversed)
      
      Spacer()
      
      ColumnSortingTitle("Holdings", option: .holdings, optionReversed: .holdingsReversed)
      
      ColumnSortingTitle("Price", option: .price, optionReversed: .priceReversed)
        .lastColumnStyled()
    }
    .font(.caption)
    .foregroundColor(.theme.secondaryText)
    .padding(.horizontal, 10)
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      HomeView()
        .navigationBarHidden(true)
    }
    .environmentObject(dev.homeVM)
    .preferredColorScheme(.light)
  }
}

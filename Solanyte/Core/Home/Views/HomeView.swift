//
//  HomeView.swift
//  CryptoTrackerTutorial
//
//  Created by Фёдор Ткаченко on 08.11.21.
//

import SwiftUI

struct HomeView: View {
  @EnvironmentObject private var vm: HomeViewModel
  @State private var showPortfolioView: Bool = false // new sheet
  @State private var showSettingsView: Bool = false
  
  private var isPortfolio: Bool {
    vm.portfolioCoins.count > 0
  }
  private var coinsToRender: Array<CoinModel> {
    vm.portfolioCoins
  }
  
  var body: some View {
    ZStack {
      // background
      background
        .sheet(isPresented: $showPortfolioView, content: {
          PortfolioView()
            .environmentObject(vm)
        })
      // content
      VStack {
        homeHeader
        
        HomeStatsView()
          .padding(.vertical)
        
        columnTitles
        
        renderCoins(coins: coinsToRender, showHoldings: isPortfolio, expanding: !isPortfolio)
            .transition(.move(edge: .leading))
        
        Spacer(minLength: 0)
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
  
  private var homeHeader: some View {
    HStack {
      CircleButtonView("info") {
          showSettingsView.toggle()
      }
      .animation(.none)
      .background(
        CircleButtonAnimationView(animate: .constant(true))
      )
      
      Spacer()
      
      Text("Solanyte")
        .font(.headline)
        .fontWeight(.heavy)
        .foregroundColor(.theme.accent)
        .animation(.none)
      
      Spacer()
      
      CircleButtonView("plus") {
        withAnimation(.spring()) {
          showPortfolioView.toggle()
        }
      }
    }
    .padding(.horizontal)
  }
  
  private func renderCoins(coins: [CoinModel], showHoldings: Bool, expanding: Bool = false) -> some View {
    List {
      ForEach(coins) { coin in
        NavigationLink(
          destination: NavigationLazyView(DetailView(coin: coin)),
          label: {
            CoinRowView(coin: coin, showHoldings: showHoldings)
          }
        )
        .listRowBackground(Color.theme.background)
        .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
      }
    }
    .listStyle(PlainListStyle())
  }
  
  private var portfolioEmptytext: some View {
    Text("No coins, add using ＋ button 👍")
      .font(.callout)
      .foregroundColor(.theme.accent)
      .padding(50)
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
    .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
  }
}

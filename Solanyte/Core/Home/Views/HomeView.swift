//
//  HomeView.swift
//  CryptoTrackerTutorial
//
//  Created by Фёдор Ткаченко on 08.11.21.
//

import SwiftUI

struct HomeView: View {
  @EnvironmentObject private var vm: HomeViewModel
  @State private var showPortfolio: Bool = false // animate
  @State private var showPortfolioView: Bool = false // new sheet
  
  @State private var selectedCoin: CoinModel? = nil
  @State private var showDetailView: Bool = false
  
  @State private var showSettingsView: Bool = false
  
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
        
        HomeStatsView(showPortfolio: $showPortfolio)
        
        HStack {
          SearchBarView(searchText: $vm.searchText)
            .padding(.leading)
          updateButton
        }
        
        columnTitles
        
        if !showPortfolio {
          renderCoins(coins: vm.allCoins, showHoldings: false)
            .transition(.move(edge: .leading))
        }
        
        if showPortfolio {
          ZStack(alignment: .top) {
            if vm.portfolioCoins.isEmpty && vm.searchText.isEmpty {
              portfolioEmptytext
            } else {
              renderCoins(coins: vm.portfolioCoins, showHoldings: true)
                .transition(.move(edge: .trailing))
            }
          }
        }
        
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
  
  private var updateButton: some View {
    Button(action: {
      withAnimation(.linear(duration: 2)) {
        vm.reloadData()
      }
    }, label: {
      Image(systemName: "arrow.triangle.2.circlepath")
    })
    .rotationEffect(Angle.degrees(vm.isLoading ? 360 : 0), anchor: .center)
    .padding(.trailing)
    .padding(.trailing)
  }
  
  private var homeHeader: some View {
    HStack {
      CircleButtonView(showPortfolio ? "plus" : "info") {
        if showPortfolio {
          showPortfolioView.toggle()
        } else {
          showSettingsView.toggle()
        }
      }
      .animation(.none)
      .background(
        CircleButtonAnimationView(animate: $showPortfolio)
      )
      
      Spacer()
      
      Text(showPortfolio ? "Portfolio" : "Live Prices")
        .font(.headline)
        .fontWeight(.heavy)
        .foregroundColor(.theme.accent)
        .animation(.none)
      
      Spacer()
      
      CircleButtonView("chevron.right") {
        withAnimation(.spring()) {
          showPortfolio.toggle()
        }
      }
      .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
    }
    .padding(.horizontal)
  }
  
  private func renderCoins(coins: [CoinModel], showHoldings: Bool) -> some View {
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

      if vm.isListFull == false && coins.count > 0 {
        ActivityIndicator()
          .onAppear {
            vm.fetchMore()
          }
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

      if (showPortfolio) {
        ColumnSortingTitle("Holdings", option: .holdings, optionReversed: .holdingsReversed)
      }
      
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

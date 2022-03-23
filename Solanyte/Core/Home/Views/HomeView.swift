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
        ScrollView {
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
        .transition(.move(edge: .leading))
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
    ForEach(coinsToRender) { coin in
      GroupBox {
        NavigationLink(
          destination: NavigationLazyView(DetailView(coin: coin)),
          label: {
            CoinRowView(coin: coin, showHoldings: true)
          }
        )
          .listRowBackground(Color.theme.background)
          .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
      }
      .padding(.horizontal, 10)
    }
  }
  
  private var columnTitles: some View {
    var fromWallet: Bool {
      vm.fromWallet
    }
    
    var sortings = [
      (title: "rank", option: SortOption.rank),
      (title: "price", option: SortOption.price),
    ]
    
    if (vm.fromWallet) {
      sortings.insert(
        (title: "balance", option: SortOption.holdings),
        at: 1
      )
    }
    
    return (
      VStack {
        Picker("Sort", selection: $vm.sortOption) {
          ForEach(sortings, id: \.title) { sorting in
            Text(sorting.title.uppercased())
              .tag(sorting.option)
          }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal, 10)
        .padding(.bottom)
      }
    )
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

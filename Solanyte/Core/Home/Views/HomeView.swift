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
  @State private var showInfoView: Bool = false
  
  private var isContent: Bool {
    coinsToRender.count > 0
  }
  
  private var coinsToRender: Array<CoinModel> {
    vm.portfolioCoins
  }
  
  var body: some View {
    GeometryReader { geometry in
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
              showInfoView: $showInfoView,
              showWalletView: $showWalletView
            )
              .padding(.top)
            
            if isContent {
              columnTitles
              coinsList
            }
            
            if !isContent {
              VStack {
                Spacer(minLength: geometry.size.height / 2)
                AccentButton(perform: { vm.tabView = 2 }) {
                  Text("Add wallet".uppercased())
                    .foregroundColor(.theme.accent)
                    .bold()
                }
              }
            }
            
            Spacer(minLength: 0)
          }
          .transition(.move(edge: .leading))
        }
        .sheet(isPresented: $showInfoView, content: {
          InfoView()
        })
      }
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
          label: { CoinRowView(coin: coin, showHoldings: true) }
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
      TabView(selection: .constant(1)) {
        HomeView().tabItem { Text("Home") }.tag(1)
      }
      .navigationBarHidden(true)
    }
    .environmentObject(dev.homeVM)
    .preferredColorScheme(.light)
  }
}

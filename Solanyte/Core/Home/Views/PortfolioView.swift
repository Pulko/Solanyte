//
//  PortfolioView.swift
//  CryptoTrackerTutorial
//
//  Created by Фёдор Ткаченко on 13.12.21.
//

import SwiftUI

struct PortfolioView: View {
  @EnvironmentObject private var vm: HomeViewModel
  @StateObject private var portfolioVm = PortfolioViewModel()
  
  @State private var selectedCoin: CoinModel? = nil
  @State private var quantity: String = ""
  @State private var showSaveButton: Bool = false
  
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(alignment: .leading, spacing: 0, content: {
          HStack {
            TextField("Solana wallet address", text: portfolioVm.$walletAddress)
          }
        })
      }
      .navigationTitle("Add wallet")
      .toolbar(content: {
        ToolbarItem(placement: .navigationBarLeading) {
          XmarkButton()
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          trailingNavBarButtons
        }
      })
      .onChange(of: vm.searchText, perform: { value in
        if value == "" {
          removeSelectedCoin()
        }
      })
      .background(Color.theme.background.ignoresSafeArea())
    }
  }
}

extension PortfolioView {
  private var coins: [CoinModel] {
    vm.searchText.isEmpty ? (vm.portfolioCoins.isEmpty ? vm.allCoins : vm.portfolioCoins) : vm.allCoins
  }

//  private var coinLogoList: some View {
//    ScrollView(.horizontal, showsIndicators: false, content: {
//      LazyHStack(spacing: 10) {
//        ForEach(coins) { coin in
//          CoinLogoView(coin: coin)
//            .frame(width: 75)
//            .padding(8)
//            .onTapGesture {
//              withAnimation {
//                updateSelectedCoin(coin: coin)
//              }
//            }
//            .background(
//              RoundedRectangle(cornerRadius: 10)
//                .stroke(
//                  selectedCoin?.id == coin.id ? Color.theme.green : Color.clear,
//                  lineWidth: 1
//                )
//            )
//        }
//      }
//      .frame(height: 130)
//      .padding(.leading)
//    })
//  }
  
  private func updateSelectedCoin(coin: CoinModel) {
    selectedCoin = coin
    if let portfolioCoin = vm.portfolioCoins.first(where: { $0.id == coin.id }),
       let amount = portfolioCoin.currentHoldings {
      quantity = amount.asNumberString()
    } else {
      quantity = ""
    }
  }
  
  private var portfolioInputSection: some View {
    VStack(spacing: 28) {
      HStack {
        Text("Current price of \(selectedCoin?.symbol.uppercased() ?? "")")
        Spacer()
        Text("\(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")")
      }
      Divider()
      HStack {
        Text("Amount holding")
        Spacer()
        TextField("Ex. 1.4", text: $quantity)
          .multilineTextAlignment(.trailing)
          .keyboardType(.decimalPad)
      }
      Divider()
      HStack {
        Text("Current value")
        Spacer()
        Text(getCurrentValue().asCurrencyWith2Decimals())
      }
    }
    .animation(.none)
    .padding()
    .font(.headline)
  }
  
  private var trailingNavBarButtons: some View {
    HStack(spacing: 10) {
        Button(action: {
          saveButtonPressed()
        }, label: {
          Text("Save".uppercased())
        })
        .opacity(selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantity) ? 1.0 : 0.0)
        Image(systemName: "checkmark")
          .opacity(showSaveButton ? 0.0 : 1.0)
      
      
    }
    .font(.headline)
  }
  
  private func saveButtonPressed() {
    guard
      let coin = selectedCoin,
      let amount = Double(quantity)
    else { return }
    
    // save to portfolio
    vm.updatePortfolio(coin: coin, amount: amount)
    
    withAnimation(.easeIn) {
      showSaveButton = true
      removeSelectedCoin()
    }
    
    // hide keyboard
    
    UIApplication.shared.endEditing()
    
    // hide checkmark
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
      withAnimation(.easeOut) {
        showSaveButton = false
        quantity = ""
      }
    }
  }
  
  private func removeSelectedCoin() {
    selectedCoin = nil
    vm.searchText = ""
  }
  
  private func getCurrentValue() -> Double {
    if let quantity = Double(quantity), let price = selectedCoin?.currentPrice {
      return price * quantity
    }
    
    return 0
  }
}

struct PortfolioView_Previews: PreviewProvider {
  static var previews: some View {
    PortfolioView()
      .environmentObject(dev.homeVM)
  }
}

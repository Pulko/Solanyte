//
//  PortfolioView.swift
//  CryptoTrackerTutorial
//
//  Created by Фёдор Ткаченко on 13.12.21.
//

// 5exSWLLQWC3zD5BGyFY8sRFQcRuv1dworDD5cgUwrXxD

import SwiftUI
import Solana

struct PortfolioView: View {
  @EnvironmentObject private var vm: HomeViewModel
  @StateObject private var portfolioVm = PortfolioViewModel()
  
  @State private var selectedCoin: CoinModel? = nil
  @State private var quantity: String = ""
  
  var body: some View {
    NavigationView {
      VStack {
        VStack(alignment: .leading, spacing: 0, content: {
          if $portfolioVm.coins.count > 0 {
            tokenList
          }
          walletAddressInput
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
      .background(Color.theme.background.ignoresSafeArea())
    }
  }
}

extension PortfolioView {
  private var tokenList: some View {
    List($portfolioVm.coins, id: \.id) {(each: Binding<CoinModel>) in
      HStack {
        Text(each.wrappedValue.symbol)
        Spacer()
        Text("\(each.wrappedValue.currentHoldings ?? 0)")
      }
    }
  }
  
  private var walletAddressInput: some View {
    VStack {
      TextField("Solana wallet address", text: $portfolioVm.walletAddress)
        .padding()
      Button("Fetch wallet data") {
        portfolioVm.fetchWalletByAddress()
      }
      
      if (portfolioVm.isError) {
        Text("⛔️ Incorrect address")
          .foregroundColor(.theme.red)
          .font(.footnote)
          .padding()
      }
      
      if (portfolioVm.isLoading) {
        Text("📦 Loading...")
          .foregroundColor(.theme.secondaryText)
          .font(.footnote)
          .padding()
      }
    }
    .padding(.vertical)
  }
  
  /* MARK: OLD EXTENSIONS */
  
  private var coins: [CoinModel] {
    vm.portfolioCoins
  }
  
  private var trailingNavBarButtons: some View {
    HStack(spacing: 10) {
      Button(action: {
        saveButtonPressed()
      }, label: {
        Text("Save".uppercased())
      })
    }
    .font(.headline)
  }
  
  private func saveButtonPressed() {
    let tokensToSave = portfolioVm.coins

    // save to portfolio
    tokensToSave.forEach { coin in
      vm.updatePortfolio(coin: coin, amount: coin.currentHoldings ?? 0.0)
    }

    // hide keyboard

    UIApplication.shared.endEditing()
  }
}

struct PortfolioView_Previews: PreviewProvider {
  static var previews: some View {
    PortfolioView()
      .environmentObject(dev.homeVM)
  }
}

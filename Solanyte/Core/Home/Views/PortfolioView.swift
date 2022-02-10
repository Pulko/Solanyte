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
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject private var vm: HomeViewModel
  @StateObject private var portfolioVm = PortfolioViewModel()
  
  @State private var selectedCoin: CoinModel? = nil
  @State private var quantity: String = ""
  @State private var animate: Bool = false
  
  var body: some View {
    NavigationView {
      VStack {
        VStack(alignment: .leading, spacing: 0, content: {
          walletDisplayData
            .opacity(portfolioVm.isReady ? 1.0 : 0.0)
          
          if portfolioVm.isReady {
            savePortfolioButton
          } else {
            walletAddressInput
              .padding(.top, 50)
          }
        })
          .padding(30)
        
      }
      .navigationTitle("Add wallet")
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          XmarkButton()
        }
      }
    }
  }
}

extension PortfolioView {
  private var savePortfolioButton: some View {
    VStack {
      Spacer()
      HStack(alignment: .center) {
        Button(action: {
          saveButtonPressed()
          presentationMode.wrappedValue.dismiss()
        }) {
          Spacer()
          Text("save portfolio".uppercased())
            .foregroundColor(.theme.accent)
            .padding()
            .background(
              RoundedRectangle(cornerRadius: CGFloat(20))
                .foregroundColor(.theme.container)
            )
          Spacer()
        }
      }
      .padding()
    }
  }
  
  private var walletAddressInput: some View {
    VStack {
      TextField("Solana wallet address", text: $portfolioVm.walletAddress)
        .padding()
      
      HStack(spacing: 40) {
        Button(action: {
          portfolioVm.fetchWalletByAddress()
          UIApplication.shared.endEditing()
        }, label: {
          Text("fetch".uppercased())
          Image(systemName: "arrow.forward")
        })
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
    .padding()
    .background(
      RoundedRectangle(cornerRadius: CGFloat(20))
        .foregroundColor(.theme.container)
    )
  }
  
  private var walletDisplayData: some View {
    VStack {
      HStack {
        Text("Wallet address:")
        Spacer()
        Text(portfolioVm.walletAddress)
          .frame(width: 100)
          .lineLimit(1)
          .truncationMode(.middle)
      }
      Divider()
      HStack {
        Text("Coins found:")
        Spacer()
        Text("\(portfolioVm.coins.count)")
      }
    }
  }
  
  /* MARK: OLD EXTENSIONS */
  
  private func saveButtonPressed() {
    portfolioVm.coins.forEach { coin in
      vm.updatePortfolio(coin: coin, amount: coin.currentHoldings ?? 0.0)
    }
    
    UIApplication.shared.endEditing()
  }
}

struct PortfolioView_Previews: PreviewProvider {
  static var previews: some View {
    PortfolioView()
      .environmentObject(dev.homeVM)
      .preferredColorScheme(.dark)
  }
}

//
//  PortfolioView.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 13.12.21.
//

import SwiftUI
import Solana

struct PortfolioView: View {
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject private var vm: HomeViewModel
  @StateObject private var portfolioVm = PortfolioViewModel()
  
  var body: some View {
    NavigationView {
      VStack {
        VStack(spacing: 0, content: {
          walletAddressInput
            .padding(.top)
          Spacer()
        })
          .padding(30)
          .shadow(color: .theme.container, radius: 20, x: 0, y: 0)
        
      }
      .navigationTitle("Add wallet")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          XmarkButton()
        }
      }
      .onAppear {
        portfolioVm.deleteAll()
      }
    }
  }
}

extension PortfolioView {
  private var savePortfolioButton: some View {
    VStack {
      HStack(alignment: .center) {
        Button(action: {
          saveButtonPressed()
          presentationMode.wrappedValue.dismiss()
        }) {
          Spacer()
          Text("save".uppercased())
            .foregroundColor(.theme.accent)
            .fontWeight(.bold)
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
      if portfolioVm.isReady {
        walletDisplayData
      } else {
        HStack {
          Image("solana-logo")
            .resizable()
            .scaledToFit()
            .frame(height: 20)
            .padding(.trailing)
          TextField("Solana wallet address", text: $portfolioVm.walletAddress)
            .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding()
      }
      
      HStack {
        if portfolioVm.isReady {
          savePortfolioButton
        } else {
          Button(action: {
            portfolioVm.fetchWalletByAddress()
          }, label: {
            Text("fetch".uppercased())
              .foregroundColor(.theme.accent)
              .fontWeight(.bold)
              .padding()
          })
        }
      }
      
      
      if (portfolioVm.isError) {
        Text("⛔️ Incorrect address")
          .foregroundColor(.theme.red)
          .font(.footnote)
      }
      
      if (portfolioVm.isLoading) {
        Text("📦 Loading...")
          .foregroundColor(.theme.accent)
          .font(.footnote)
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
    .padding()
  }
  
  /* MARK: OLD EXTENSIONS */
  
  private func saveButtonPressed() {
    vm.updatePortfolio(coins: portfolioVm.coins)
    vm.updateWallet(key: portfolioVm.walletAddress)
  }
}

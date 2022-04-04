//
//  WalletView.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 13.12.21.
//

import SwiftUI
import Solana

struct WalletView: View {
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject private var vm: HomeViewModel
  @StateObject private var portfolioVm = WalletViewModel()
  
  private var currentWalletAddress: String {
    portfolioVm.walletAddress == "" ? vm.walletEntity?.key ?? "" : portfolioVm.walletAddress
  }
  
  var body: some View {
    NavigationView {
      VStack {
        VStack(spacing: 0, content: {
          walletAddressInput
          Spacer()
          CircleButtonView("trash") {
            withAnimation(.spring()) {
              portfolioVm.deleteAll()
              vm.removeData()
              vm.tabView = 1
            }
          }
          Spacer()
        })
          .padding(30)
      }
      .navigationBarHidden(true)
    }
  }
}

extension WalletView {
  private var savePortfolioButton: some View {
    VStack {
      HStack(alignment: .center) {
        if portfolioVm.isReady {
          Button(action: {
            saveButtonPressed()
            presentationMode.wrappedValue.dismiss()
            vm.tabView = 1
          }) {
            Text("save".uppercased())
              .foregroundColor(.theme.accent)
              .fontWeight(.bold)
          }
        }
      }
      .padding()
    }
  }
  
  private var walletAddressInput: some View {
    GroupBox {
      VStack {
        if portfolioVm.isReady || vm.walletEntity?.key != nil {
          walletDisplayData
        } else {
          HStack {
            Image("solana-logo")
              .resizable()
              .scaledToFit()
              .frame(height: 20)
              .padding(.trailing, 6)
            TextField("Solana wallet address", text: $portfolioVm.walletAddress)
              .textFieldStyle(RoundedBorderTextFieldStyle())
          }
        }
        
        HStack {
          if portfolioVm.isReady {
            savePortfolioButton
          } else {
            if !currentWalletAddress.isEmpty {
              Button(action: {
                portfolioVm.fetchWalletByAddress()
              }, label: {
                Text("fetch".uppercased())
                  .foregroundColor(.theme.accent)
                  .fontWeight(.bold)
              })
                .padding()
            }
            
            if currentWalletAddress.isEmpty {
              Button(action: {
                if UIPasteboard.general.hasStrings {
                  portfolioVm.walletAddress = UIPasteboard.general.string ?? ""
                }
              }, label: {
                Text("paste".uppercased())
                  .foregroundColor(.theme.accent)
                  .fontWeight(.bold)
              })
                .padding()
            }
          }
        }
        
        
        if (portfolioVm.isError) {
          Text("⛔️ Error occured...")
            .foregroundColor(.theme.red)
            .font(.footnote)
        }
        
        if (portfolioVm.isLoading) {
          Text("📦 Loading...")
            .foregroundColor(.theme.accent)
            .font(.footnote)
        }
      }
    }
  }
  
  private var walletDisplayData: some View {
    VStack {
      HStack {
        Text("Wallet address:")
        Spacer()
        Text(currentWalletAddress)
          .frame(width: 100)
          .lineLimit(1)
          .truncationMode(.middle)
      }
    }
  }
  
  /* MARK: OLD EXTENSIONS */
  
  private func saveButtonPressed() {
    vm.updatePortfolio(coins: portfolioVm.coins)
    vm.updateWallet(key: portfolioVm.walletAddress, balance: portfolioVm.coins.reduce(0) { $0 + $1.currentHoldingsValue })
  }
}

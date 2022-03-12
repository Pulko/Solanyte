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
  
  var body: some View {
    NavigationView {
      VStack {
        VStack(spacing: 0, content: {
          walletAddressInput
          Spacer()
        })
          .padding(30)
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Text("Add wallet")
            .font(.title)
            .foregroundColor(.theme.accent)
            .bold()
        }
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

extension WalletView {
  private var savePortfolioButton: some View {
    VStack {
      HStack(alignment: .center) {
        if portfolioVm.isReady {
          Button(action: {
            saveButtonPressed()
            presentationMode.wrappedValue.dismiss()
          }) {
            Text("save".capitalized)
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
        if portfolioVm.isReady {
          walletDisplayData
            .padding(.top)
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
          .padding(.top)
        }
        
        HStack {
          if portfolioVm.isReady {
            savePortfolioButton
          } else {
            if !portfolioVm.walletAddress.isEmpty {
              Button(action: {
                portfolioVm.fetchWalletByAddress()
              }, label: {
                Text("fetch".capitalized)
                  .foregroundColor(.theme.accent)
                  .fontWeight(.bold)
              })
                .padding()
            }
            
            if portfolioVm.walletAddress.isEmpty {
              Button(action: {
                if UIPasteboard.general.hasStrings {
                  portfolioVm.walletAddress = UIPasteboard.general.string ?? ""
                }
              }, label: {
                Text("paste".capitalized)
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
    vm.updatePortfolio(coins: portfolioVm.coins)
    vm.updateWallet(key: portfolioVm.walletAddress, balance: portfolioVm.coins.reduce(0) { $0 + $1.currentHoldingsValue })
  }
}

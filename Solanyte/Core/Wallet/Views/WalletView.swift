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
  @StateObject private var walletVm = WalletViewModel()
  
  private var currentWalletAddress: String {
    walletVm.walletAddress == "" ? vm.walletEntity?.key ?? "" : walletVm.walletAddress
  }
  
  var body: some View {
    NavigationView {
      VStack {
        VStack(spacing: 0, content: {
          walletAddressInput
          Spacer()
          if (!vm.savedWalletEntities.isEmpty) {
            ForEach(vm.savedWalletEntities) { (wallet: WalletEntity) in
              Text(wallet.key ?? "")
                .onTapGesture {
                  if let key = wallet.key {
                    walletVm.walletAddress = key
                  }
                }
            }
          }
          Spacer()
          CircleButtonView("trash") {
            withAnimation(.spring()) {
              walletVm.deleteAll()
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
        if walletVm.isReady {
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
        HStack {
          Image("solana-logo")
            .resizable()
            .scaledToFit()
            .frame(height: 20)
            .padding(.trailing, 6)
          TextField("Solana wallet address", text: $walletVm.walletAddress)
            .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        
        HStack {
          if walletVm.isReady {
            savePortfolioButton
          } else {
            HStack {
              Button(action: {
                walletVm.fetchWalletByAddress()
              }, label: {
                Text("fetch".uppercased())
                  .foregroundColor(.theme.accent)
                  .fontWeight(.bold)
              })
              
              Button(action: {
                if UIPasteboard.general.hasStrings {
                  walletVm.walletAddress = UIPasteboard.general.string ?? ""
                }
              }, label: {
                Text("paste".uppercased())
                  .foregroundColor(.theme.accent)
                  .fontWeight(.bold)
              })
            }
            .padding()
          }
        }
        
        
        if (walletVm.isError) {
          Text("⛔️ Error occured...")
            .foregroundColor(.theme.red)
            .font(.footnote)
        }
        
        if (walletVm.isLoading) {
          Text("📦 Loading...")
            .foregroundColor(.theme.accent)
            .font(.footnote)
        }
      }
    }
  }
  
  /* MARK: OLD EXTENSIONS */
  
  private func saveButtonPressed() {
    vm.updatePortfolio(coins: walletVm.coins)
    vm.updateWallet(key: walletVm.walletAddress, balance: walletVm.coins.reduce(0) { $0 + $1.currentHoldingsValue })
  }
}

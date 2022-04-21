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
  
  @State private var showRemoveWalletSheet: Bool = false
  @State private var walletToRemove: String = ""
  
  var body: some View {
    VStack {
      VStack(spacing: 0, content: {
        GroupBox {
          VStack {
            walletAddressInput
            
            actionButtons
            RemoveWalletAlert(showRemoveWalletSheet: $showRemoveWalletSheet, key: walletToRemove)
            
            fetchedWalletStats
            
            errors
          }
        }
        
        Spacer()
        
        if (!vm.savedWalletEntities.isEmpty) {
          walletsList
        }
        
        Spacer()
      })
        .padding(30)
    }
  }
}

extension WalletView {
  private var fetchedWalletStats: some View {
    VStack {
      if (!walletVm.coins.isEmpty) {
        HStack {
          Text("Coins found:")
          Spacer()
          Text(String(walletVm.coins.count))
        }
        .foregroundColor(.theme.accent)
      }
    }
    .padding()
    .foregroundColor(.theme.accent)
  }
  
  private var walletAddressInput: some View {
    HStack {
      Image("solana-logo")
        .resizable()
        .scaledToFit()
        .frame(height: 20)
        .padding(.trailing, 6)
      TextField("Solana wallet address", text: $walletVm.walletAddress)
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
  }
  
  private var actionButtons: some View {
    HStack {
      if walletVm.isReady {
        VStack {
          HStack(alignment: .center) {
            Button(action: {
              withAnimation {
                vm.updateWallet(key: walletVm.walletAddress, balance: walletVm.coins.reduce(0) { $0 + $1.currentHoldingsValue })
                vm.updatePortfolio(coins: walletVm.coins)
                walletVm.deleteAll()
                presentationMode.wrappedValue.dismiss()
                vm.tabView = 1
              }
            }) {
              Text("track".uppercased())
                .foregroundColor(.theme.accent)
                .fontWeight(.bold)
            }
          }
          .padding()
        }
      } else {
        HStack {
          if walletVm.walletAddress.isEmpty {
            Button(action: {
              if UIPasteboard.general.hasStrings {
                walletVm.walletAddress = UIPasteboard.general.string ?? ""
              }
            }, label: {
              Text("paste".uppercased())
                .foregroundColor(.theme.accent)
                .fontWeight(.bold)
            })
          } else {
            Button(action: {
              walletVm.fetchWalletByAddress()
            }, label: {
              Text("fetch".uppercased())
                .foregroundColor(.theme.accent)
                .fontWeight(.bold)
            })
          }
        }
        .padding()
      }
    }
  }
  
  private var walletsList: some View {
    ScrollView {
      ForEach(vm.savedWalletEntities) { (wallet: WalletEntity) in
        HStack {
          Text(wallet.key ?? "")
            .foregroundColor(.theme.accent)
            .frame(width: 150)
            .lineLimit(1)
            .truncationMode(.middle)
            .padding(.horizontal)
          
          Spacer()
          
          if (wallet.current) {
            CircleButtonView("checkmark", color: .theme.green.opacity(0.8))
              .disabled(true)
          } else {
            CircleButtonView(
              "square.and.arrow.down",
              color: walletVm.isReady ? .theme.accent.opacity(0.3) : .theme.accent
            ) {
              if let key = wallet.key {
                walletVm.walletAddress = key
              }
            }
            .disabled(walletVm.isReady)
          }
          
          CircleButtonView(
            "trash",
            color: walletVm.isReady ? .theme.red.opacity(0.3) : .theme.red
          ) {
            if let key = wallet.key {
              withAnimation(.spring()) {
                walletToRemove = key
                showRemoveWalletSheet = true
              }
            }
          }
          .disabled(walletVm.isReady)
        }
        .padding(.vertical, 6)
      }
    }
  }
  
  private var errors: some View {
    VStack {
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

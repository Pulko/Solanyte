//
//  HomeHeader.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 24.02.22.
//

import SwiftUI

struct HomeHeader: View {
  @EnvironmentObject private var vm: HomeViewModel
  @Binding var showSettingsView: Bool
  @Binding var showPortfolioView: Bool
  
  private var fromWallet: Bool {
    vm.fromWallet
  }
  
  var body: some View {
    VStack(spacing: 0) {
      navigation
      
      if fromWallet {
        withAnimation {
          HStack {
            hideZeroBalance
            Spacer()
            walletKey
            Spacer()
            updateButton
          }
          .padding(.horizontal)
        }
      }
    }
    .padding(.horizontal)
  }
}

extension HomeHeader {
  private var walletKey: some View {
    Text(vm.walletEntity?.key ?? "sdf")
      .foregroundColor(.theme.secondaryText)
      .frame(width: 100)
      .lineLimit(1)
      .truncationMode(.middle)
      .animation(.none)
  }
  
  private var updateButton: some View {
    CircleButtonView("arrow.triangle.2.circlepath", rotate: vm.isLoading) {
      withAnimation(.linear(duration: 2)) {
        vm.reloadData()
      }
    }
  }
  
  private var hideZeroBalance: some View {
    VStack(alignment: .leading) {
      Toggle("Hide zero", isOn: $vm.isAboveZero)
        .labelsHidden()
        .toggleStyle(SwitchToggleStyle(tint: .theme.secondaryText))
      Text("Hide zero")
        .foregroundColor(.theme.accent)
        .fontWeight(.light)
        .font(.caption2)
    }
    .padding(.vertical)
  }
  
  private var navigation: some View {
    HStack {
      CircleButtonView("ellipsis") {
        showSettingsView.toggle()
      }
      .animation(.none)
      
      Spacer()
      
      VStack {
        Text(fromWallet ? vm.portfolioValue.asCurrencyWith2Decimals() : "Solanyte")
          .font(.title)
          .fontWeight(.heavy)
          .foregroundColor(.theme.accent)
          .animation(.none)
        if fromWallet {
          walletBalanceDelta
        }
      }
      
      Spacer()
      
      walletButtonElement
    }
    .padding()
  }
  
  private var walletBalanceDelta: some View {
    let balance = vm.walletEntity?.balance ?? 0
    let delta = (vm.portfolioValue - balance)
    
    return (
      HStack {
        Image(systemName: "triangle.fill")
          .font(.caption2)
          .rotationEffect(Angle.init(degrees: delta >= 0 ? 0 : 180))
        Text(delta.asFloatWith4Decimals())
          .font(.caption)
      }
        .foregroundColor(delta >= 0 ? Color.theme.green : Color.theme.red)
        .opacity(balance == 0 ? 0 : 1)
    )
  }
  
  private var walletButtonElement: some View {
    VStack {
      if fromWallet {
        CircleButtonView("trash") {
          withAnimation(.spring()) {
            vm.removeData()
          }
        }
      } else {
        CircleButtonView(name: "solana-logo") {
          withAnimation(.spring()) {
            showPortfolioView.toggle()
          }
        }
        .padding(.top)
      }
      if !fromWallet {
        Text("Add wallet")
          .foregroundColor(.theme.accent)
          .fontWeight(.light)
          .font(.caption2)
      }
    }
  }
}


struct HomeHeader_Previews: PreviewProvider {
  static var previews: some View {
    HomeHeader(
      showSettingsView: .constant(false),
      showPortfolioView: .constant(false)
    )
      .environmentObject(dev.homeVM)
      .preferredColorScheme(.dark)
  }
}

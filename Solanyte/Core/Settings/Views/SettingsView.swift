//
//  SettingsView.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 09.01.22.
//

import SwiftUI

struct SettingsView: View {
  @EnvironmentObject private var homeVm: HomeViewModel
  @StateObject var vm: SettingsViewModel = SettingsViewModel()
  
  @State var isBool: Bool = false
  
  var body: some View {
    NavigationView {
      ScrollView(showsIndicators: false) {
        VStack(alignment: .center, spacing: 20) {
          VStack(alignment: .center) {
            Image("solanyte-transparent")
            Text("Solanyte")
              .font(.callout)
              .foregroundColor(.theme.accent)
              .fontWeight(.bold)
            Text("Mobile tracking application")
              .font(.callout)
              .foregroundColor(.theme.secondaryText)
              .fontWeight(.medium)
              .padding()
          }
          Spacer(minLength: 100)
          
          settings
            .padding(.vertical)
          
          VStack {
            courseSection
            solanaSection
            coingeckoSection
            solscanSection
            developerSection
          }
        }
        .padding()
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          XmarkButton()
        }
      }
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
      .environmentObject(dev.homeVM)
      .preferredColorScheme(.dark)
  }
}

extension SettingsView {
  private var settings: some View {
    GroupBox {
      VStack {
        HStack {
          VStack(alignment: .leading) {
            Text("Reset balance difference")
              .foregroundColor(.theme.accent)
              .font(.callout)
              .padding(.bottom, 3)
            Text("Current balance: \(homeVm.portfolioValue.asCurrencyWith2Decimals())")
              .foregroundColor(.theme.secondaryText)
              .font(.caption)
            Text("Lastly tracked: \((homeVm.walletEntity?.balance ?? 0).asCurrencyWith2Decimals())")
              .foregroundColor(.theme.secondaryText)
              .font(.caption)
          }
          
          Spacer()
          
          Button("Reset") {
            homeVm.resetWalletValue()
          }
          .foregroundColor(.theme.red)
          .padding(.horizontal)
        }
      }
      
      Divider()
      
      VStack {
        HStack {
          VStack(alignment: .leading) {
            Text("Remove wallet")
              .foregroundColor(.theme.accent)
              .font(.callout)
              .padding(.bottom, 3)
            Text(homeVm.walletEntity?.key ?? "N/A")
              .frame(width: 100, alignment: .leading)
              .lineLimit(1)
              .truncationMode(.middle)
              .foregroundColor(.theme.secondaryText)
              .font(.caption)
          }
          
          Spacer()
          
          Button("Remove") {
            homeVm.removeData()
          }
          .foregroundColor(.theme.red)
          .padding(.horizontal)
        }
      }
    }
  }
  
  private var solanaSection: some View {
    VStack {
      HStack(spacing: 0) {
        Text("API by ")
          .font(.caption)
          .foregroundColor(.theme.secondaryText)
          .fontWeight(.medium)
        
        Text("Solana")
          .font(.caption)
          .foregroundColor(.theme.accent)
          .underline()
          .fontWeight(.medium)
          .onTapGesture {
            UIApplication.shared.open(vm.solanaUrl, options: [:])
          }
        
        Image("solana-logo")
          .resizable()
          .scaledToFit()
          .frame(height: 15)
          .padding(.horizontal, 6)
      }
    }
  }
  
  private var coingeckoSection: some View {
    VStack {
      HStack(spacing: 0) {
        Text("Powered by ")
          .font(.caption)
          .foregroundColor(.theme.secondaryText)
          .fontWeight(.medium)
        
        Text("Coingecko")
          .font(.caption)
          .foregroundColor(.theme.accent)
          .underline()
          .fontWeight(.medium)
          .onTapGesture {
            UIApplication.shared.open(vm.coingeckoUrl, options: [:])
          }
        
        Image("coingecko")
          .resizable()
          .scaledToFit()
          .frame(height: 20)
          .padding(.horizontal, 6)
      }
      
    }
  }
  
  private var solscanSection: some View {
    VStack {
      HStack(spacing: 0) {
        Text("Data from ")
          .font(.caption)
          .foregroundColor(.theme.secondaryText)
          .fontWeight(.medium)
        
        Text("Solscan")
          .font(.caption)
          .foregroundColor(.theme.accent)
          .underline()
          .fontWeight(.medium)
          .onTapGesture {
            UIApplication.shared.open(vm.solscanUrl, options: [:])
          }
        
        Image("solscan")
          .resizable()
          .scaledToFit()
          .frame(height: 20)
          .padding(.horizontal, 6)
      }
    }
  }
  
  private var courseSection: some View {
    HStack(spacing: 0) {
      Text("With help of ")
        .font(.caption)
        .foregroundColor(.theme.secondaryText)
        .fontWeight(.medium)
      Text("Swift Thinking Course")
        .font(.caption)
        .foregroundColor(.theme.accent)
        .underline()
        .fontWeight(.medium)
        .onTapGesture {
          UIApplication.shared.open(vm.youtubeUrl, options: [:])
        }
    }
  }
  
  
  
  private var developerSection: some View {
    HStack(spacing: 0) {
      Text("Made by 🥸")
        .font(.caption)
        .foregroundColor(.theme.secondaryText)
        .fontWeight(.medium)
      Text("Pulko")
        .font(.caption)
        .foregroundColor(.theme.accent)
        .underline()
        .fontWeight(.medium)
        .onTapGesture {
          UIApplication.shared.open(vm.personalUrl, options: [:])
        }
    }
    .padding()
  }
}

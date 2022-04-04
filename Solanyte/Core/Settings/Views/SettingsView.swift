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
      VStack {
        Spacer()
        
        settings
          .padding(.vertical)
        
        Spacer()
      }
      .padding()
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
}

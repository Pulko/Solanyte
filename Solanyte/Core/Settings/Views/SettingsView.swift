//
//  SettingsView.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 09.01.22.
//

import SwiftUI

struct SettingsView: View {
  @StateObject var vm: SettingsViewModel = SettingsViewModel()
  
  var body: some View {
    NavigationView {
      ScrollView(showsIndicators: false) {
        VStack(alignment: .center) {
          VStack(alignment: .center) {
            Image("logo-transparent")
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
          Spacer(minLength: 150)
          courseSection
          solanaSection
          coingeckoSection
          solscanSection
          developerSection
        }
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
  }
}

extension SettingsView {
  private var solanaSection: some View {
    VStack {
      HStack(spacing: 0) {
        Text("API by ")
          .font(.callout)
          .foregroundColor(.theme.secondaryText)
          .fontWeight(.medium)
          .padding(.vertical)
        
        Text("Solana")
          .font(.callout)
          .foregroundColor(.theme.accent)
          .underline()
          .fontWeight(.medium)
          .padding(.vertical)
          .onTapGesture {
            UIApplication.shared.open(vm.solanaUrl, options: [:])
          }
        
        Image("solana-logo")
          .resizable()
          .scaledToFit()
          .frame(height: 20)
          .padding(.horizontal)
      }
    }
  }
  
  private var coingeckoSection: some View {
    VStack {
      HStack(spacing: 0) {
        Text("Powered by ")
          .font(.callout)
          .foregroundColor(.theme.secondaryText)
          .fontWeight(.medium)
          .padding(.vertical)
        
        Text("Coingecko")
          .font(.callout)
          .foregroundColor(.theme.accent)
          .underline()
          .fontWeight(.medium)
          .padding(.vertical)
          .onTapGesture {
            UIApplication.shared.open(vm.coingeckoUrl, options: [:])
          }
      }
      Image("coingecko")
        .resizable()
        .scaledToFit()
        .frame(height: 30)
    }
  }
  
  private var solscanSection: some View {
    VStack {
      HStack(spacing: 0) {
        Text("Data from ")
          .font(.callout)
          .foregroundColor(.theme.secondaryText)
          .fontWeight(.medium)
          .padding(.vertical)
        
        Text("Solscan")
          .font(.callout)
          .foregroundColor(.theme.accent)
          .underline()
          .fontWeight(.medium)
          .padding(.vertical)
          .onTapGesture {
            UIApplication.shared.open(vm.solscanUrl, options: [:])
          }
      }
      Image("solscan")
        .resizable()
        .scaledToFit()
        .frame(height: 20)
    }
  }
  
  private var courseSection: some View {
    VStack(spacing: 0) {
      Text("With help of")
        .font(.callout)
        .foregroundColor(.theme.secondaryText)
        .fontWeight(.medium)
      Text("Swift Thinking Course")
        .font(.callout)
        .foregroundColor(.theme.accent)
        .underline()
        .fontWeight(.medium)
        .onTapGesture {
          UIApplication.shared.open(vm.youtubeUrl, options: [:])
        }
    }
    .padding()
  }
  
  
  
  private var developerSection: some View {
    HStack(spacing: 0) {
      Text("Made by 🥸")
        .font(.callout)
        .foregroundColor(.theme.secondaryText)
        .fontWeight(.medium)
        .padding(.vertical)
      Text("Pulko")
        .font(.callout)
        .foregroundColor(.theme.accent)
        .underline()
        .fontWeight(.medium)
        .padding(.vertical)
        .onTapGesture {
          UIApplication.shared.open(vm.personalUrl, options: [:])
        }
    }
  }
}

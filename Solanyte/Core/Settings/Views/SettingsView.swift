//
//  SettingsView.swift
//  CryptoTrackerTutorial
//
//  Created by Фёдор Ткаченко on 09.01.22.
//

import SwiftUI

struct SettingsView: View {
  @StateObject var vm: SettingsViewModel = SettingsViewModel()
  
  var body: some View {
    NavigationView {
      VStack {
        VStack(alignment: .center) {
          Spacer()
          courseSection
          Spacer()
          coingeckoSection
          Spacer()
          developerSection
        }
      }
      .listStyle(GroupedListStyle())
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
      .preferredColorScheme(.dark)
  }
}

extension SettingsView {
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
  
  private var courseSection: some View {
    VStack(spacing: 0) {
      Text("This app was made with help of ")
        .font(.callout)
        .foregroundColor(.theme.secondaryText)
        .fontWeight(.medium)
      Text("Swift Thinking Course")
        .font(.callout)
        .foregroundColor(.theme.accent)
        .fontWeight(.medium)
        .onTapGesture {
          UIApplication.shared.open(vm.youtubeUrl, options: [:])
        }
    }
  }
  
  
  
  private var developerSection: some View {
    HStack(spacing: 0) {
      Text("Made by ")
        .font(.callout)
        .foregroundColor(.theme.secondaryText)
        .fontWeight(.medium)
        .padding(.vertical)
      Text("Pulko 🥸")
        .font(.callout)
        .foregroundColor(.theme.accent)
        .fontWeight(.medium)
        .padding(.vertical)
        .onTapGesture {
          UIApplication.shared.open(vm.personalUrl, options: [:])
        }
    }
  }
}

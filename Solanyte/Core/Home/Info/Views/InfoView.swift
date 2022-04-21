//
//  InfoView.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 04.04.22.
//

import SwiftUI

struct InfoView: View {
  @EnvironmentObject private var homeVm: HomeViewModel
  @StateObject var vm: InfoViewModel = InfoViewModel()
  
  var body: some View {
    NavigationView {
      VStack {
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
          Spacer()
          
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
        ToolbarItem(placement: .primaryAction) {
          XmarkButton()
        }
      }
    }
  }
}

struct InfoView_Previews: PreviewProvider {
  static var previews: some View {
    InfoView()
  }
}

extension InfoView {
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

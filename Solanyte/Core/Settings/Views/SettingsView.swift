//
//  SettingsView.swift
//  CryptoTrackerTutorial
//
//  Created by Фёдор Ткаченко on 09.01.22.
//

import SwiftUI

struct SettingsView: View {
  private let youtubeUrl: URL = URL(string: "https://www.youtube.com/channel/UCp25X4LzOLaksp5qY0YMUzg")!
  private let coingeckoUrl: URL = URL(string: "https://www.coingecko.com/")!
  private let personalUrl: URL = URL(string: "https://github.com/pulko")!
  
  var body: some View {
    NavigationView {
      ZStack {
        List {
          siftThinkingSection
            .listRowBackground(Color.theme.background.opacity(0.5))
          coingeckoSection
            .listRowBackground(Color.theme.background.opacity(0.5))
          developerSection
            .listRowBackground(Color.theme.background.opacity(0.5))
          // applicationService
        }
      }
      .listStyle(GroupedListStyle())
      .navigationTitle("Settings")
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          XmarkButton()
        }
      }
      .background(Color.theme.background.ignoresSafeArea())
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}

extension SettingsView {
  private var developerSection: some View {
    Section(header: Text("Developer")) {
      VStack(alignment: .leading) {
        Text("Made by Pulko 🥸")
          .font(.callout)
          .foregroundColor(.theme.accent)
          .fontWeight(.medium)
          .padding(.vertical)
      }
      Link("Github 💾", destination: personalUrl)
        .foregroundColor(.blue)
    }
  }
  
  private var coingeckoSection: some View {
    Section(header: Text("CoinGecko")) {
      VStack(alignment: .leading) {
        Image("coingecko")
          .resizable()
          .scaledToFit()
          .frame(height: 100)
        Text("All cryptocurrency data is coming from Coingecko")
          .font(.callout)
          .foregroundColor(.theme.accent)
          .fontWeight(.medium)
          .padding(.vertical)
      }
      Link("CoinGecko website 🦎", destination: coingeckoUrl)
        .foregroundColor(.blue)
    }
  }

  private var siftThinkingSection: some View {
    Section(header: Text("Swift Thinking")) {
      VStack(alignment: .leading) {
        Image("logo")
          .resizable()
          .frame(width: 120, height: 120)
          .clipShape(RoundedRectangle(cornerRadius: 25.0))
        Text("This app was made by Swift Thinking Course")
          .font(.callout)
          .foregroundColor(.theme.accent)
          .fontWeight(.medium)
          .padding(.vertical)
      }
      Link("YouTube channel 🎥", destination: youtubeUrl)
        .foregroundColor(.blue)
    }
  }
}

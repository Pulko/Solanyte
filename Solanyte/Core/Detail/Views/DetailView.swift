//
//  DetailView.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 08.01.22.
//

import Foundation
import SwiftUI

struct DetailView: View {
  @StateObject private var vm: DetailViewModel
  @EnvironmentObject private var homeVm: HomeViewModel
  
  @State private var showFullDescription: Bool = false
  @State private var showAllHolders: Bool = false
  
  init(coin: CoinModel) {
    _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
  }
  
  var body: some View {
    ScrollView {
      if (vm.chart?.price ?? []).count > 0 {
        VStack {
          ChartView(sparkline: vm.chart, lastUpdated: vm.coin.lastUpdated)
            .padding(.vertical)
        }
      }
      
      VStack(spacing: 20) {
        statisticSection
        
        holdersSection
        
        descriptionSection
        
        if let redditUrl = vm.redditUrl,
           let urlLink = URL(string: redditUrl) {
          getLinksSection(title: "Reddit", url: urlLink)
        }
        
        if let websiteUrl = vm.websiteUrl,
           let urlLink = URL(string: websiteUrl) {
          getLinksSection(title: "Homepage", url: urlLink)
        }
      }
      .padding()
    }
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        toolbarItemContent
      }
    }
    .background(Color.theme.background.ignoresSafeArea())
  }
}

extension DetailView {
  private var spacing: CGFloat { 30 }
  private var columns: [GridItem]  {
    [
      GridItem(.flexible()),
      GridItem(.flexible())
    ]
  }
  
  private func renderWalletRow(owner: String) -> some View {
    let found = homeVm.savedWalletEntities.first {
      if let key = $0.key {
        return key == owner
      }
      
      return false
    }
    
    if found != nil {
      return WalletRowView(current: true, key: owner)
    } else {
      return WalletRowView(key: owner, onLoad: {
        withAnimation(.spring()) {
          homeVm.updateWallet(key: owner, balance: 0.0, current: false)
        }
      })
    }
  }
  
  private var holdersSection: some View {
    VStack(alignment: .leading) {
      if (!vm.tokenHolders.isEmpty) {
        Text("Top holders")
          .font(.callout)
          .foregroundColor(.theme.accent)
          .frame(maxWidth: .infinity, alignment: .leading)
        ForEach(vm.tokenHolders.dropLast(showAllHolders ? 0 : 8), id: \.address) { holder in
          renderWalletRow(owner: holder.owner)
        }
        
        readMoreButton(readMore: showAllHolders) {
          withAnimation(.easeInOut) {
            showAllHolders.toggle()
          }
        }
      }
    }
  }
  
  private func readMoreButton(readMore: Bool, action: @escaping () -> Void) -> some View {
    Button(action: action, label: {
      Text(readMore ? "Read less" : "Read more")
        .font(.caption)
        .foregroundColor(.theme.accent)
        .padding(.vertical, 4)
    })
  }
  
  private var statisticSection: some View {
    LazyVGrid(
      columns: columns,
      alignment: .leading,
      spacing: spacing,
      content: {
        ForEach(vm.statistics) {  StatisticView(stat: $0) }
      }
    )
  }
  
  private func getLinksSection(title: String, url: URL) -> some View {
    VStack {
      Link(destination: url, label: {
        HStack {
          Image(systemName: "link")
          Text(title)
            .font(.callout)
            .foregroundColor(.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
      })
        .padding(.top)
    }
  }
  
  private var toolbarItemContent: some View {
    HStack {
      HStack {
        Text(String(vm.coin.rank))
          .fontWeight(.bold)
          .font(.title2)
          .foregroundColor(.theme.secondaryText)
        Text(vm.coin.name)
          .fontWeight(.bold)
          .font(.title)
          .foregroundColor(.theme.accent)
          .lineLimit(1)
          .truncationMode(.tail)
      }
      CoinImageView(coin: vm.coin)
        .frame(width: 25, height: 25)
    }
  }
  
  private var descriptionSection: some View {
    VStack {
      if let description = vm.coinDescription, !description.isEmpty {
        VStack(alignment: .leading) {
          Text(description)
            .lineLimit(showFullDescription ? nil : 3)
            .font(.callout)
            .foregroundColor(.theme.secondaryText)
            .frame(maxWidth: .infinity, alignment: .leading)
          
          readMoreButton(readMore: showFullDescription) {
            withAnimation(.easeInOut) {
              showFullDescription.toggle()
            }
          }
        }
        .padding(.top)
      }
    }
  }
}

struct DetailView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      DetailView(coin: dev.coin)
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
}

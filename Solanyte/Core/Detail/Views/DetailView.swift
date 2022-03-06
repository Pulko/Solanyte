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
  
  @State private var showFullDescription: Bool = false
  
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
          .frame(width: 200)
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
          
          Button(action: {
            withAnimation(.easeInOut) {
              showFullDescription.toggle()
            }
          }, label: {
            Text(showFullDescription ? "Read less" : "Read more")
              .font(.caption)
              .foregroundColor(.theme.accent)
              .padding(.vertical, 4)
          })
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

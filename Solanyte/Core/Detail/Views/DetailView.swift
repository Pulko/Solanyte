//
//  DetailView.swift
//  CryptoTrackerTutorial
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
      VStack {
        ChartView(coin: vm.coin)
          .padding(.vertical)
      }
      VStack(spacing: 20) {
        descriptionSection
        
        self.getSectionTitleitle("Overview", systemName: "square.fill.text.grid.1x2")
        self.getStatisticsGrid(stats: vm.overviewStatistics)
        
        self.getSectionTitleitle("Additional Details", systemName: "square.fill.text.grid.1x2")
        self.getStatisticsGrid(stats: vm.additionalStatistics)
        
        
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
    .navigationTitle(vm.coin.name)
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
  
  private func getSectionTitleitle(_ text: String, systemName: String? = nil) -> some View {
    VStack {
      HStack {
        Text(text)
          .bold()
          .font(.title)
        
        if let name = systemName {
          Image(systemName: name)
            .font(.title3)
        }
      }
      .foregroundColor(.theme.accent)
      .frame( maxWidth: .infinity, alignment: .leading)
      Divider()
    }
  }
  
  private func getStatisticsGrid(stats: Array<StatisticModel>) -> some View {
    LazyVGrid(
      columns: columns,
      alignment: .leading,
      spacing: spacing,
      content: {
        ForEach(stats) {  StatisticView(stat: $0) }
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
        Text(vm.coin.symbol.uppercased())
          .font(.headline)
          .foregroundColor(.theme.secondaryText)
      }
      CoinImageView(coin: vm.coin)
        .frame(width: 25, height: 25)
    }
  }
  
  private var updateButton: some View {
    Button(action: {
      withAnimation(.linear(duration: 2)) {
        vm.reloadData()
      }
    }, label: {
      Image(systemName: "arrow.triangle.2.circlepath")
        .rotationEffect(Angle.degrees(vm.isLoading ? 360 : 0), anchor: .center)
    })      
  }
  
  private var descriptionSection: some View {
    VStack {
      if let description = vm.coinDescription, !description.isEmpty {
        self.getSectionTitleitle("Description", systemName: "info.circle")
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

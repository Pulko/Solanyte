//
//  DetailViewModel.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 08.01.22.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
  @Published var statistics: Array<StatisticModel> = []
  @Published var coin: CoinModel
  @Published var coinDescription: String? = nil
  @Published var websiteUrl: String? = nil
  @Published var redditUrl: String? = nil
  @Published var tokenHolders: Array<HolderData> = []
  
  @Published var chart: SparklineIn7D? = nil
  @Published var lastUpdated: String = ""
  
  private let coinDetailsDataService: CoinDetailDataService
  private var cancellables = Set<AnyCancellable>()
  
  init(coin: CoinModel) {
    self.coin = coin
    self.coinDetailsDataService = CoinDetailDataService(coin: coin)
    addSubscribers()
  }

  private func addSubscribers() {
    coinDetailsDataService.$coinDetails
      .combineLatest($coin)
      .map(mapCoinDetailsStatistics)
      .sink { [weak self] (returnedArrays: Array<StatisticModel>) in
        self?.statistics = returnedArrays
      }
      .store(in: &cancellables)
    
    coinDetailsDataService.$coinDetails
      .sink { [weak self] (returnedCoinDetails) in
        guard let self = self, let details = returnedCoinDetails else { return }
        
        self.coinDescription = details.readableDescription
        self.redditUrl = details.links?.subredditURL
        self.websiteUrl = details.links?.homepage?.first
        self.chart = SparklineIn7D(price: details.marketData.sparkline7D?.price)
        self.lastUpdated = details.marketData.lastUpdated ?? ""
      }
      .store(in: &cancellables)
    
    coinDetailsDataService.$tokenHolders
      .sink { [weak self] returnedTokenHolders in
        self?.tokenHolders = returnedTokenHolders ?? []
      }
      .store(in: &cancellables)
  }
  
  private func mapCoinDetailsStatistics(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> Array<StatisticModel> {
    createOverviewStatistics(coinModel: coinModel, coinDetailModel: coinDetailModel)
  }
  
  private func createOverviewStatistics(coinModel: CoinModel, coinDetailModel: CoinDetailModel?) -> Array<StatisticModel> {
    let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "n/a"
    let price = coinModel.currentPrice?.asCurrencyWith6Decimals() ?? "0.0"
    let priceChangePercentage = coinModel.priceChangePercentage24H
    let marketCap = "$ " + (coinModel.marketCap?.formattedWithAbbreviations() ?? "" )
    let marketCapChangePercentage = coinModel.marketCapChangePercentage24H
    let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "n/a"
    let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
    let marketCapChange = "$ " + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
    
    return [
      StatisticModel(title: "Current Price", value: price, percentChange: priceChangePercentage),
      StatisticModel(title: "Market Cap", value: marketCap, percentChange: marketCapChangePercentage),
      StatisticModel(title: "24H High", value: high),
      StatisticModel(title: "24H Low", value: low),
      StatisticModel(title: "24H Price Change", value: priceChange, percentChange: priceChangePercentage),
      StatisticModel(title: "24H Market Cap Change", value: marketCapChange, percentChange: marketCapChangePercentage),
    ]
  }
}

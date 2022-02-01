//
//  DetailViewModel.swift
//  CryptoTrackerTutorial
//
//  Created by Фёдор Ткаченко on 08.01.22.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
  @Published var overviewStatistics: Array<StatisticModel> = []
  @Published var additionalStatistics: Array<StatisticModel> = []
  @Published var coin: CoinModel
  @Published var coinDescription: String? = nil
  @Published var websiteUrl: String? = nil
  @Published var redditUrl: String? = nil
  @Published var isLoading: Bool = false
  
  private let coinDetailsDataService: CoinDetailDataService
  private var cancellables = Set<AnyCancellable>()
  
  init(coin: CoinModel) {
    self.coin = coin
    self.coinDetailsDataService = CoinDetailDataService(coin: coin)
    addSubscribers()
  }
  
  typealias CoinDetailsStatisticsType = (overview: Array<StatisticModel>, additional: Array<StatisticModel>)
  
  func reloadData() {
    self.isLoading = true
    coinDetailsDataService.reload()
  }
  
  private func addSubscribers() {
    coinDetailsDataService.$coinDetails
      .combineLatest($coin)
      .map(mapCoinDetailsStatistics)
      .sink { [weak self] (returnedArrays: CoinDetailsStatisticsType) in
        self?.additionalStatistics = returnedArrays.additional
        self?.overviewStatistics = returnedArrays.overview
      }
      .store(in: &cancellables)
    
    coinDetailsDataService.$coinDetails
      .sink { [weak self] (returnedCoinDetails) in
        guard let self = self, let details = returnedCoinDetails else { return }
        
        self.coinDescription = details.readableDescription
        self.redditUrl = details.links?.subredditURL
        self.websiteUrl = details.links?.homepage?.first
        self.isLoading = false
      }
      .store(in: &cancellables)
  }
  
  private func mapCoinDetailsStatistics(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> CoinDetailsStatisticsType {
    return (
      createOverviewStatistics(coinModel: coinModel),
      createAdditionalStatistics(coinModel: coinModel, coinDetailModel: coinDetailModel)
    )
  }
  
  private func createOverviewStatistics(coinModel: CoinModel) -> Array<StatisticModel> {
    let price = coinModel.currentPrice?.asCurrencyWith6Decimals() ?? "0.0"
    let priceChangePercentage = coinModel.priceChangePercentage24H
    let marketCap = "$ " + (coinModel.marketCap?.formattedWithAbbreviations() ?? "" )
    let marketCapChangePercentage = coinModel.marketCapChangePercentage24H
    let rank = String(coinModel.rank)
    let volume = "$ " + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
    
    return [
      StatisticModel(title: "Current Price", value: price, percentChange: priceChangePercentage),
      StatisticModel(title: "Market Cap", value: marketCap, percentChange: marketCapChangePercentage),
      StatisticModel(title: "Rank", value: rank),
      StatisticModel(title: "Volume", value: volume)
    ]
  }
  
  private func createAdditionalStatistics(coinModel: CoinModel, coinDetailModel: CoinDetailModel?) -> Array<StatisticModel> {
    let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "n/a"
    let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "n/a"
    let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
    let priceChangePercentage = coinModel.priceChangePercentage24H
    let marketCapChange = "$ " + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
    let marketCapChangePercentage = coinModel.marketCapChangePercentage24H
    let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
    let blockTimeString = blockTime == 0 ? "n/a" : String(blockTime)
    let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
    
    return [
      StatisticModel(title: "24H High", value: high),
      StatisticModel(title: "24H Low", value: low),
      StatisticModel(title: "24H Price Change", value: priceChange, percentChange: priceChangePercentage),
      StatisticModel(title: "24H Market Cap Change", value: marketCapChange, percentChange: marketCapChangePercentage),
      StatisticModel(title: "Block Time", value: blockTimeString),
      StatisticModel(title: "Hashing Algorithm", value: hashing),
    ]
  }
}

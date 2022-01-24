//
//  CoinImageViewModel.swift
//  CryptoTrackerTutorial
//
//  Created by Фёдор Ткаченко on 17.11.21.
//

import Foundation
import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
  @Published var image: UIImage? = nil
  @Published var isLoading: Bool = false
  
  private var cancellables = Set<AnyCancellable>()
  
  private let coin: CoinModel
  private let dataService: CoinImageService
  
  init(coin: CoinModel) {
    self.coin = coin
    self.dataService = CoinImageService(coin: coin)
    self.isLoading = true
    self.addSubscribers()
  }
  
  private func addSubscribers() {
    dataService.$image
      .sink(
        receiveCompletion: { [weak self] _ in
          self?.isLoading = false
        },
        receiveValue: { [weak self] (image: UIImage?) -> Void in
          self?.image = image
        })
      .store(in: &cancellables)
  }
}

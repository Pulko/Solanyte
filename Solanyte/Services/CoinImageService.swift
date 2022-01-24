//
//  CoinImageService.swift
//  CryptoTrackerTutorial
//
//  Created by Фёдор Ткаченко on 17.11.21.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
  @Published var image: UIImage? = nil
  
  private var imageSubscription: AnyCancellable?
  private var imageName: String
  private let folderName: String = "coin_images" // Hardcoded folder name for storing images
  private let coin: CoinModel
  private let fileManager = LocalFileManager.instance
  
  init(coin: CoinModel) {
    self.coin = coin
    self.imageName = coin.id
    getCoinImage()
  }
  
  private func getCoinImage() {
    if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
      self.image = savedImage
    } else {
      downloadCoinImage()
    }
  }
  
  private func downloadCoinImage() {
    guard let url = URL(string: coin.image) else { return }
    
    imageSubscription = NetworkingManager.download(url: url)
      .tryMap({ (data) -> UIImage? in
        return UIImage(data: data)
      })
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: NetworkingManager.receiveCompletion,
        receiveValue: { [weak self] returnedImage in
          guard
            let self = self,
            let unwrappedReturnedImage = returnedImage
          else { return }
          
          self.image = unwrappedReturnedImage
          self.imageSubscription?.cancel()
          self.fileManager.saveImage(
            image: unwrappedReturnedImage,
            imageName: self.imageName,
            folderName: self.folderName
          )
        })
  }
}

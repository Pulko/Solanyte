//
//  InfoViewModel.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 04.04.22.
//

import Foundation

class InfoViewModel: ObservableObject {
  var youtubeUrl: URL = URL(string: "https://www.youtube.com/channel/UCp25X4LzOLaksp5qY0YMUzg")!
  var coingeckoUrl: URL = URL(string: "https://www.coingecko.com/")!
  var personalUrl: URL = URL(string: "https://github.com/pulko")!
  var solanaUrl: URL = URL(string: "https://solana.com/")!
  var solscanUrl: URL = URL(string: "https://solscan.io/")!
}

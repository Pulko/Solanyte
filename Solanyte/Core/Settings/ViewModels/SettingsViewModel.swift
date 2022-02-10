//
//  SettingsViewModel.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 09.02.22.
//

import Foundation

class SettingsViewModel: ObservableObject {
  var youtubeUrl: URL = URL(string: "https://www.youtube.com/channel/UCp25X4LzOLaksp5qY0YMUzg")!
  var coingeckoUrl: URL = URL(string: "https://www.coingecko.com/")!
  var personalUrl: URL = URL(string: "https://github.com/pulko")!
}

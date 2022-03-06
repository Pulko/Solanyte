//
//  PreviewProvider.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 14.11.21.
//

import Foundation
import SwiftUI

extension PreviewProvider {
  static var dev: DeveloperPreview {
    return DeveloperPreview.instance
  }
}

class DeveloperPreview { // Singleton
  static let instance =  DeveloperPreview()
  private init() { }
  
  let homeVM = HomeViewModel()
  let stat1 = StatisticModel(title: "Market Cap Value", value: "$ 1246", percentChange: 12.4)
  let stat2 = StatisticModel(title: "Total Volume", value: "$ 123,78")
  let stat3 = StatisticModel(title: "Portfolio Value", value: "$ 30450", percentChange: -12.4)
  
  let coin: CoinModel = CoinModel(
    id: "bitcoin",
    symbol: "btc",
    name: "Bitcoin",
    image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
    currentPrice: 64088,
    marketCap: 1209171962888,
    marketCapRank: 1,
    fullyDilutedValuation: 1345431356393,
    totalVolume: 25021772180,
    high24H: 65739,
    low24H: 63705,
    priceChange24H: -105.538570911885,
    priceChangePercentage24H: -0.16441,
    marketCapChange24H: -1817564698.2663574,
    marketCapChangePercentage24H: -0.15009,
    circulatingSupply: 18873212,
    totalSupply: 21000000,
    maxSupply: 21000000,
    ath: 69045,
    athChangePercentage: -7.18857,
    athDate: "2021-11-10T14:24:11.849Z",
    atl: 67.81,
    atlChangePercentage: 94402.85101,
    atlDate: "2013-07-06T00:00:00.000Z",
    lastUpdated: "2021-11-14T19:26:08.106Z",
    sparklineIn7D: SparklineIn7D(price: [
      62522.222520115494,
      62590.769954374744,
      62447.41536175135,
      62916.93883108815,
      63005.03947881222,
      63036.736127182565,
      63432.566870410454,
      65058.3519486148,
      65268.41208068035,
      65335.76855149814,
      65317.59830533633,
      65379.67347675058,
      65647.25241994597,
      66342.15829314454,
      65934.95443840112,
      66121.15261786306,
      66509.5876232143,
      66259.61406087133,
      66160.1251599846,
      66130.251833762,
      66068.76531261054,
      65617.79736527929,
      65499.84217677174,
      66405.91842065833,
      66234.01514408147,
      66216.67656777156,
      66040.60747437927,
      65981.19614082146,
      66173.12485683471,
      66389.78385407776,
      66660.7342238841,
      67491.51572226828,
      67826.72401135827,
      67810.31653249671,
      67752.73671232101,
      68275.12284999067,
      68425.84344035048,
      68226.68553104943,
      68078.55816165461,
      67963.24297026609,
      68243.69457859156,
      68298.3557379976,
      68029.95057993913,
      67630.70069181747,
      67701.03971208622,
      67973.65472887407,
      67458.60612106466,
      66936.2744603693,
      66977.80796677001,
      67053.45610792036,
      66747.36100537727,
      66957.68041549953,
      67508.91375234765,
      67775.33532502735,
      67549.36763994195,
      67145.37493537061,
      67057.52582424013,
      67284.34714542133,
      66932.42513064703,
      66569.02484558128,
      66830.8768227006,
      66594.96191791273,
      66711.84975387584,
      66577.56185452912,
      66877.36762560043,
      66866.43871548047,
      67039.77941518667,
      66886.81487190626,
      66644.70926858537,
      67907.46403711349,
      68345.96407984912,
      68572.77292125227,
      68640.16034986946,
      68568.7244691428,
      67784.14155904535,
      66722.19700503723,
      66193.53936371562,
      65332.537632314314,
      65261.56919374489,
      65061.05440696283,
      65157.14339731592,
      65024.32273160712,
      64712.05683762485,
      64891.12538732561,
      64929.8778592748,
      64847.288474602756,
      65109.53716520833,
      65549.55854853842,
      65253.70367080749,
      65630.12784164319,
      65449.830692163836,
      65361.649165981915,
      65164.66134280387,
      65056.970856360174,
      65735.07855462219,
      65027.784214333275,
      65273.56962532144,
      65193.58026880355,
      65040.88104363001,
      65330.30933969824,
      65161.477708954255,
      65265.1121661448,
      65419.41141574062,
      64947.21819057796,
      65142.210102887424,
      65746.73956969603,
      65310.31990091317,
      65046.09775664769,
      65250.130412877836,
      64995.99929978834,
      64916.50713646828,
      64666.70495576598,
      65243.879252899154,
      64305.540117112476,
      64037.55678720265,
      63960.6487081776,
      64074.852385746606,
      64461.78770291081,
      63673.617395471614,
      63601.268441021675,
      63091.01059319875,
      63664.04689332009,
      64075.04998841115,
      64103.870010127954,
      64313.115969074905,
      64341.15804940664,
      64111.22781164685,
      64432.04794734522,
      64528.481713868576,
      64158.79882792767,
      64044.893804904685,
      64037.439352859146,
      63920.034836012834,
      63816.78934774921,
      63988.0515277715,
      64141.89793482077,
      64018.83642142079,
      63691.40314718218,
      63838.35372805033,
      63744.656477209624,
      63798.504488807695,
      63708.81601422374,
      64847.3634081264,
      64991.705536404064,
      64939.679887828795,
      64809.98545746471,
      64318.50974136553,
      64173.623907350535,
      64553.83791077381,
      64471.931312580025,
      64521.64887531047,
      64660.33535267343,
      65219.4830332113,
      64924.80152409708,
      64877.70494048529,
      64859.405867484864,
      64992.664375403896,
      64941.4746189243,
      64985.69935792312,
      64872.392807380726,
      64552.2586412053,
      64464.31405204806,
      64649.88259211724,
      64637.48558875219,
      64846.234779693914,
      64882.72708946906,
      64418.04901512429,
      64382.234299135795,
      63874.891513550705
    ]), priceChangePercentage24HInCurrency: -0.16440754209480166,
    currentHoldings: 1.5
    )
}


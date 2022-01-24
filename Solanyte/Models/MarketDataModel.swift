//
//  MarketDataModel.swift
//  CryptoTrackerTutorial
//
//  Created by Фёдор Ткаченко on 03.12.21.
//

/*
 JSON Response:
 {
 "data": {
 "active_cryptocurrencies": 11378,
 "upcoming_icos": 0,
 "ongoing_icos": 50,
 "ended_icos": 3375,
 "markets": 683,
 "total_market_cap": {
 "btc": 48647454.17220938,
 "eth": 601552402.8427286,
 "ltc": 13456599170.552662,
 "bch": 4935439895.832989,
 "bnb": 4426010921.067124,
 "eos": 678708262639.1667,
 "xrp": 2839151999979.8438,
 "xlm": 7691112373598.11,
 "link": 108387840666.1538,
 "dot": 75894762462.72327,
 "yfi": 94975269.79439056,
 "usd": 2767363939747.3755,
 "aed": 10164527750692.127,
 "ars": 279617496572408.66,
 "aud": 3919179554565.3906,
 "bdt": 237181697391481.1,
 "bhd": 1043478851304.7832,
 "bmd": 2767363939747.3755,
 "brl": 15652763915999.098,
 "cad": 3548231022625.893,
 "chf": 2544189874826.4487,
 "clp": 2314927609238077,
 "cny": 17630875660130.562,
 "czk": 62207574001581.125,
 "dkk": 18195500924757.22,
 "eur": 2446861685065.533,
 "gbp": 2084990106848.4104,
 "hkd": 21566274734746.797,
 "huf": 890575003272430,
 "idr": 39911199475430640,
 "ils": 8741322289030.957,
 "inr": 207948022989709.22,
 "jpy": 313661331022787.06,
 "krw": 3270885982928340.5,
 "kwd": 837589741551.5183,
 "lkr": 558921212817147.06,
 "mmk": 4939531800023171,
 "mxn": 58772328913887.26,
 "myr": 11708716829071.146,
 "ngn": 1137192863760389.5,
 "nok": 25179549879412.496,
 "nzd": 4074085518456.693,
 "php": 139731132029786.17,
 "pkr": 489641598757079.1,
 "pln": 11239825752576.094,
 "rub": 203460056055151.84,
 "sar": 10381851608244.416,
 "sek": 25225698440471.746,
 "sgd": 3790187186605.8853,
 "thb": 93675269360448.61,
 "try": 38018322540643.43,
 "twd": 76676739127914.38,
 "uah": 75657098349586.47,
 "vef": 277096151286.90466,
 "vnd": 63181838282948130,
 "zar": 43962476380295.93,
 "xdr": 1977204048759.189,
 "xag": 123653652467.86215,
 "xau": 1560959303.853907,
 "bits": 48647454172209.38,
 "sats": 4864745417220938
 },
 "total_volume": {
 "btc": 2348251.467450262,
 "eth": 29037414.94309555,
 "ltc": 649560789.7029885,
 "bch": 238237625.69107172,
 "bnb": 213647082.19991797,
 "eos": 32761789919.594837,
 "xrp": 137048134660.16206,
 "xlm": 371256137139.1161,
 "link": 5231967637.958338,
 "dot": 3663500800.966681,
 "yfi": 4584532.129403169,
 "usd": 133582867655.85902,
 "aed": 490649872899.971,
 "ars": 13497359889102.424,
 "aud": 189181927334.3748,
 "bdt": 11448949969309.244,
 "bhd": 50369557575.52411,
 "bmd": 133582867655.85902,
 "brl": 755571416035.0695,
 "cad": 171275945422.3128,
 "chf": 122810077293.75229,
 "clp": 111743404622802.64,
 "cny": 851056449835.4795,
 "czk": 3002809282036.049,
 "dkk": 878311362323.3043,
 "eur": 118111967838.29573,
 "gbp": 100644137732.14511,
 "hkd": 1041021306357.1844,
 "huf": 42988766707214.25,
 "idr": 1926545475619565.5,
 "ils": 421950608556.18005,
 "inr": 10037817157098.482,
 "jpy": 15140682968718.043,
 "krw": 157888278841563.3,
 "kwd": 40431125804.79586,
 "lkr": 26979573351172.914,
 "mmk": 238435145174521.9,
 "mxn": 2836987257934.39,
 "myr": 565189113051.9396,
 "ngn": 54893207805822.17,
 "nok": 1215436983500.88,
 "nzd": 196659361934.2793,
 "php": 6744933345862.064,
 "pkr": 23635391047099.14,
 "pln": 542555366287.8006,
 "rub": 9821179408643.332,
 "sar": 501140269079.8527,
 "sek": 1217664611401.9102,
 "sgd": 182955362707.19983,
 "thb": 4521780070150.825,
 "try": 1835174794142.9575,
 "twd": 3701247439157.5835,
 "uah": 3652028564404.0415,
 "vef": 13375652538.38116,
 "vnd": 3049837797039232.5,
 "zar": 2122103847558.6248,
 "xdr": 95441218619.81702,
 "xag": 5968860566.379244,
 "xau": 75348752.32996397,
 "bits": 2348251467450.262,
 "sats": 234825146745026.22
 },
 "market_cap_percentage": {
 "btc": 38.83027728811244,
 "eth": 19.70915568506191,
 "bnb": 3.7981719807898378,
 "usdt": 2.704567683052078,
 "sol": 2.608501667940678,
 "ada": 1.915407721103721,
 "xrp": 1.6635066271506842,
 "usdc": 1.413262459732746,
 "dot": 1.3984575919603635,
 "doge": 1.00149956424824
 },
 "market_cap_change_percentage_24h_usd": 1.200520649093969,
 "updated_at": 1638535585
 }
 }
 
 
 URL: https://api.coingecko.com/api/v3/global
 
 */


import Foundation

// MARK: - Welcome
struct GlobalData: Codable {
  let data: MarketDataModel?
}

// MARK: - DataClass
struct MarketDataModel: Codable {
  let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
  let marketCapChangePercentage24HUsd: Double
  
  enum CodingKeys: String, CodingKey {
    case totalMarketCap = "total_market_cap"
    case totalVolume = "total_volume"
    case marketCapPercentage = "market_cap_percentage"
    case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
  }
  
  private func getValueByKey(
    _ object: Dictionary<String, Double>,
    key: String,
    callback: (_ value: Double) -> String = { "\($0)" }
  ) -> String {
    if let item = object.first(where: { $0.key == key }) {
      return callback(item.value)
    }
    
    return ""
  }
  
  var marketCap: String {
    getValueByKey(totalMarketCap, key: "usd") { $0.formattedWithAbbreviations() }
  }
  
  var volume: String {
    getValueByKey(totalVolume, key: "usd") { $0.formattedWithAbbreviations() }
  }
  
  var btcDominance: String {
    getValueByKey(marketCapPercentage, key: "btc") { $0.asPercentString() }
  }
}

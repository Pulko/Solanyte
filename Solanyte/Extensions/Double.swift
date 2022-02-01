//
//  Double.swift
//  CryptoTrackerTutorial
//
//  Created by Фёдор Ткаченко on 14.11.21.
//

import Foundation

extension Double {
  /// Converts Double into a Currency with 2-6 decimal places
  /// ```
  /// Converts 1234.56 to $1,234.56
  /// Converts 12.3456 to $12.3456
  /// Converts 0.123456 to $0.123456
  /// ```
  private var currencyFormatter6: NumberFormatter {
    let formatter = NumberFormatter()
    
    formatter.usesGroupingSeparator = true
    formatter.numberStyle = .currency
    formatter.locale = .current // <- default value
    formatter.currencyCode = "usd" // <- change currency
    formatter.currencySymbol = "$" // <- change currency symbol
    
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 6
    
    return formatter
  }
  
  /// Converts Double into a Currency as a String with 2-6 decimal places
  /// ```
  /// Converts 1234.56 to "$1,234.56"
  /// Converts 12.3456 to "$12.3456"
  /// Converts 0.123456 to "$0.123456"
  /// ```
  func asCurrencyWith6Decimals() -> String {
    let number = NSNumber(value: self)
    
    return currencyFormatter6.string(from: number) ?? "$0.00"
  }
  
  /// Converts Double into a Floar number as a String with 4 decimal places
  /// ```
  /// Converts 1234.56 to "1,234.5600"
  /// Converts 12.34562 to "12.3456"
  /// Converts 0.123456 to "0.1234"
  /// ```
  func asFloatWith4Decimals() -> String {
    let number = NSNumber(value: self)
    
    return holdingsFormatter.string(from: number) ?? "$0.0000"
  }
  
  /// Converts Double into a Float with 4 decimal places
  /// ```
  /// Converts 12.3456234234 to 12.3456
  /// ```
  private var holdingsFormatter: NumberFormatter {
    let formatter = NumberFormatter()
    
    formatter.minimumFractionDigits = 4
    formatter.maximumFractionDigits = 4
    
    return formatter
  }
  
  /// Converts Double into a Currency with 2-6 decimal places
  /// ```
  /// Converts 12.3456 to $12.34
  /// ```
  private var currencyFormatter2: NumberFormatter {
    let formatter = NumberFormatter()
    
    formatter.usesGroupingSeparator = true
    formatter.numberStyle = .currency
    formatter.locale = .current // <- default value
    formatter.currencyCode = "usd" // <- change currency
    formatter.currencySymbol = "$" // <- change currency symbol
    
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    
    return formatter
  }
  
  /// Converts Double into a Currency as a String with 2 decimal places
  /// ```
  /// Converts 0.123456 to "$0.12"
  /// ```
  func asCurrencyWith2Decimals() -> String {
    let number = NSNumber(value: self)
    
    return currencyFormatter2.string(from: number) ?? "$0.00"
  }
  
  /// Converts Double into a String representation
  /// ```
  /// Converts 1.23456 to "1.23"
  /// ```
  func asNumberString() -> String {
    return String(format: "%.2f", self)
  }
  
  /// Converts Double into a String representation with Percent symbol
  /// ```
  /// Converts 1.23456 to "1.23%"
  /// ```
  func asPercentString() -> String {
    return self.asNumberString() + "%"
  }
  
  func formattedWithAbbreviations() -> String {
    let num = abs(Double(self))
    let sign = num < 0 ? "-" : ""
    
    switch num {
    case 1_000_000_000_000...:
      return "\(sign)\((num / 1_000_000_000_000).asNumberString()) Tr"
    case 1_000_000_000...:
      return "\(sign)\((num / 1_000_000_000).asNumberString()) Bn"
    case 1_000_000...:
      return "\(sign)\((num / 1_000_000).asNumberString()) M"
    case 1_000...:
      return "\(sign)\((num / 1_000).asNumberString()) K"
    case 0:
      return self.asNumberString()
    default:
      return "\(sign)\(self)"
    }
  }
}

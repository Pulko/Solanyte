//
//  WalletRowView.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 01.05.22.
//

import SwiftUI

struct WalletRowView: View {
  var current: Bool = false
  var key: String
  
  var onLoadDisabled: Bool = false
  var onRemoveDisabled: Bool = false
  
  var onLoad: (() -> Void)? = nil
  var onRemove: (() -> Void)? = nil
  
  init(
    current: Bool = false,
    key: String,
    onLoadDisabled: Bool = false,
    onRemoveDisabled: Bool = false,
    onRemove: (() -> Void)? = nil,
    onLoad: (() -> Void)? = nil
  ) {
    self.current = current
    self.key = key
    self.onLoadDisabled = onLoadDisabled
    self.onRemoveDisabled = onRemoveDisabled
    self.onLoad = onLoad
    self.onRemove = onRemove
  }
  
  var body: some View {
    HStack {
      Text(key)
        .foregroundColor(.theme.accent)
        .frame(width: 150)
        .lineLimit(1)
        .truncationMode(.middle)
        .padding(.horizontal)
      
      Spacer()
      
      if (current) {
        CircleButtonView("checkmark", color: .theme.green.opacity(0.8))
          .disabled(true)
      } else {
        if let onLoad = onLoad {
          CircleButtonView(
            "square.and.arrow.down",
            color: onLoadDisabled ? .theme.accent.opacity(0.3) : .theme.accent,
            action: onLoad
          )
            .disabled(onLoadDisabled)
        }
      }
      
      if let onRemove = onRemove {
        CircleButtonView(
          "trash",
          color: onRemoveDisabled ? .theme.red.opacity(0.3) : .theme.red,
          action: onRemove
        )
          .disabled(onRemoveDisabled)
      }
    }
  }
}

struct WalletRowView_Previews: PreviewProvider {
  static var previews: some View {
    WalletRowView(current: false, key: "wallet-key-for-solana", onRemove: {}, onLoad: {})
  }
}

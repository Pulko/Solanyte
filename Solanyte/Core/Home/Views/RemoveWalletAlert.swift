//
//  RemoveWalletAlert.swift
//  Solanyte
//
//  Created by Фёдор Ткаченко on 12.03.22.
//

import SwiftUI

struct RemoveWalletAlert: View {
  @EnvironmentObject private var vm: HomeViewModel
  
  @Binding var showRemoveWalletSheet: Bool
  
  private var title: Text {
    Text("Stop tracking this wallet")
  }
  
  private var message: Text {
    Text("Are you sure?")
  }
  
  private func cancelHandler() -> Void {
    withAnimation {
      showRemoveWalletSheet = false
    }
  }
  
  private func destructiveHandler() -> Void {
    withAnimation {
      vm.removeData()
    }
  }
  
  var body: some View {
    HStack {
      if #available(iOS 15.0, *) {
        Spacer(minLength: 0)
          .alert(
            title,
            isPresented: $showRemoveWalletSheet,
            actions: {
              HStack {
                Button("Yes", role: .destructive, action: destructiveHandler)
                Button("Cancel", role: .cancel, action: cancelHandler).foregroundColor(.theme.red)
              }
            }, message: { message })
      } else {
        Spacer(minLength: 0)
          .alert(
            isPresented: $showRemoveWalletSheet
          ) {
            Alert(
              title: title,
              message: message,
              primaryButton: .cancel(cancelHandler),
              secondaryButton: .destructive(Text("Yes"), action: destructiveHandler)
            )
          }
      }
    }
  }
}

struct RemoveWalletAlert_Previews: PreviewProvider {
  static var previews: some View {
    RemoveWalletAlert(showRemoveWalletSheet: .constant(false))
  }
}

//
//  FactBody.swift
//  RxCatFact
//
//  Created by Kevin Tan on 7/6/20.
//  Copyright © 2020 Kevin Tan. All rights reserved.
//

import SwiftUI

struct FactBody: View {
  private enum Constant {
    static let cornerRadius: CGFloat = 20
    static let bodyHeight: CGFloat = 180
    static let textPadding: CGFloat = 35
    static let fontSize: CGFloat = 20
  }
  
  typealias LoadingState = CatFactViewModel.LoadingState
  let loadingState: LoadingState
  
  var body: some View {
    ZStack {
      Rectangle()
        .foregroundColor(.white)
        .cornerRadius(Constant.cornerRadius)
        .frame(height: Constant.bodyHeight)
        .dropShadow()
      view(for: loadingState)
    }
  }
  
  private func view(for loadingState: LoadingState) -> AnyView {
    switch loadingState {
    case .loading:
      return AnyView(
        ActivityIndicator(style: .medium)
      )
    case .done(let fact, let exclamation):
      return AnyView(
        (
          Text(fact + " ")
            .font(.lato(size: Constant.fontSize))
            .foregroundColor(.offBlack) +
          Text(exclamation)
            .font(.latoItalic(size: Constant.fontSize))
            .foregroundColor(.offBlack)
        )
          .padding(.horizontal, Constant.textPadding)
          .transition(.opacity)
          .id((fact + exclamation).hashValue)
      )
    }
  }
}

struct FactBody_Previews: PreviewProvider {
  static var previews: some View {
    FactBody(loadingState: .done(fact: "Hello, world!", exclamation: "Me-wow!"))
  }
}

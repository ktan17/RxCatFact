//
//  ActivityIndicator.swift
//  RxCatFact
//
//  Created by Kevin Tan on 7/6/20.
//  Copyright © 2020 Kevin Tan. All rights reserved.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
  let style: UIActivityIndicatorView.Style
  
  func makeUIView(context: Context) -> UIActivityIndicatorView {
    return UIActivityIndicatorView(style: style)
  }
  
  func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
    uiView.startAnimating()
  }
}

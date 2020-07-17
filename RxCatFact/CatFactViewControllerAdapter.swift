//
//  CatFactViewControllerAdapter.swift
//  RxCatFact
//
//  Created by Kevin Tan on 7/12/20.
//  Copyright © 2020 Kevin Tan. All rights reserved.
//

import SwiftUI

struct CatFactViewControllerAdapter: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> CatFactViewController {
    return CatFactViewController()
  }
  
  func updateUIViewController(
    _ uiViewController: CatFactViewController,
    context: Context)
  {}
}

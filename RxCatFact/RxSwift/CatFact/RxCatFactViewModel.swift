//
//  RxCatFactViewModel.swift
//  RxCatFact
//
//  Created by Kevin Tan on 7/14/20.
//  Copyright © 2020 Kevin Tan. All rights reserved.
//

import UIKit
import RxSwift

class RxCatFactViewModel {
  private enum Constant {
    enum API {
      static let scheme = "https"
      static let host = "catfact.ninja"
      static let path = "/fact"
      static let queryParams = ["max_length": "150"]
    }
    
    static let colors = [
      UIColor(integerRed: 255, green: 45, blue: 85),
      UIColor(integerRed: 255, green: 149, blue: 0),
      UIColor(integerRed: 255, green: 204, blue: 0),
      UIColor(integerRed: 52, green: 199, blue: 89),
      UIColor(integerRed: 90, green: 200, blue: 250),
      UIColor(integerRed: 88, green: 86, blue: 214),
      UIColor(integerRed: 175, green: 82, blue: 222),
    ]
    static let catEmojis = ["😺", "😸", "😹", "😻", "😼", "😽", "🙀", "🐱"]
    static let exclamations = [
      "Me-wow!",
      "Nyan~",
      "Mrow~",
      "(ﾉΦωΦ)ﾉ",
      "A-meow-zing!",
      ":3",
      "Meow meow!",
      "Fur real?!",
      "Purr-fect!"
    ]
  }
  
  typealias Outputs = (
    loadingState: LoadingState,
    hasHistory: Bool,
    catEmoji: String,
    backgroundColors: (UIColor, UIColor)
  )
  
  enum LoadingState {
    case loading
    case done(fact: String, exclamation: String)
  }
  
  func callAsFunction() {
    
  }
}

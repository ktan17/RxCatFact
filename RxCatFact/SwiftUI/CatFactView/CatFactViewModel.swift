//
//  CatFactViewModel.swift
//  RxCatFact
//
//  Created by Kevin Tan on 7/6/20.
//  Copyright © 2020 Kevin Tan. All rights reserved.
//

import SwiftUI
import Combine

final class CatFactViewModel: ObservableObject {
  private enum Constant {
    enum API {
      static let scheme = "https"
      static let host = "catfact.ninja"
      static let path = "/fact"
      static let queryParams = ["max_length": "150"]
    }
    
    static let colors = [
      Color(integerRed: 255, green: 45, blue: 85),
      Color(integerRed: 255, green: 149, blue: 0),
      Color(integerRed: 255, green: 204, blue: 0),
      Color(integerRed: 52, green: 199, blue: 89),
      Color(integerRed: 90, green: 200, blue: 250),
      Color(integerRed: 88, green: 86, blue: 214),
      Color(integerRed: 175, green: 82, blue: 222),
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
  
  struct Outputs {
    var loadingState = LoadingState.done(fact: "", exclamation: "")
    var hasHistory = false
    var catEmoji = Constant.catEmojis.randomElement() ?? ""
    var backgroundColors = Constant.colors.chooseTwo(maxDistance: 2)
  }
  
  enum LoadingState {
    case loading
    case done(fact: String, exclamation: String)
  }
  
  @Published var outputs = Outputs()
  private var factStack = Stack<(String, String)>(maxCapacity: 25)
  
  func fetchFact() {
    var components = URLComponents()
    components.scheme = Constant.API.scheme
    components.host = Constant.API.host
    components.path = Constant.API.path
    components.queryItems = Constant.API.queryParams.map {
      URLQueryItem(name: $0.key, value: $0.value)
    }
    
    if let url = components.url {
      outputs.loadingState = .loading
      
      let request = URLRequest(url: url)
      let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard
          let data = data,
          let json = try? JSONSerialization.jsonObject(with: data, options: []),
          let factDict = json as? [String: Any],
          let fact = factDict["fact"] as? String
        else { return }
        
        DispatchQueue.main.async { [weak self] in
          guard let self = self else { return }
          let exclamation = Constant.exclamations.randomElement() ?? ""
          
          self.factStack.push((fact, exclamation))
          withAnimation {
            self.outputs.loadingState = .done(fact: fact, exclamation: exclamation)
            self.outputs.hasHistory = self.factStack.count > 1
            self.outputs.catEmoji = Constant.catEmojis.randomElement() ?? ""
            self.outputs.backgroundColors = Constant.colors.chooseTwo(maxDistance: 2)
          }
        }
      }
      task.resume()
    }
  }
  
  func fetchLastFact() {
    guard factStack.count > 1 else { return }
    
    factStack.pop()
    if let (lastFact, lastExclamation) = factStack.top() {
      withAnimation {
        outputs.loadingState = .done(fact: lastFact, exclamation: lastExclamation)
      }
    }
    
    if factStack.count <= 1 {
      outputs.hasHistory = false
    }
  }
}

//
//  RxCatFactViewModel.swift
//  RxCatFact
//
//  Created by Kevin Tan on 7/14/20.
//  Copyright © 2020 Kevin Tan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action

struct RxStack<T> {
  private var stack: Stack<T>
  let countRelay = BehaviorRelay<Int>(value: 0)
  
  init(maxCapacity: Int) {
    self.stack = Stack<T>(maxCapacity: maxCapacity)
  }
  
  var count: Int {
    stack.count
  }
  
  mutating func push(_ element: T) {
    stack.push(element)
    countRelay.accept(stack.count)
  }
  
  @discardableResult
  mutating func pop() -> T? {
    let element = stack.pop()
    countRelay.accept(stack.count)
    return element
  }
  
  func top() -> T? { stack.top() }
}

class RxCatFactViewModel {
  private enum Constant {
    enum API {
      static let scheme = "https"
      static let host = "catfact.ninja"
      static let path = "/fact"
      static let queryParams = ["max_length": "150"]
    }
    
    static let defaultEmoji = "🐱"
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
    generateAction: CocoaAction,
    backAction: CocoaAction,
    loadingState: Driver<LoadingState>,
    hasHistory: Driver<Bool>,
    catEmoji: Driver<String>,
    backgroundColors: Driver<[UIColor]>
  )
     
  enum LoadingState {
    case loading
    case done(fact: String, exclamation: String)
  }
  
  private let disposeBag = DisposeBag()
  private var factStack = RxStack<(String, String)>(maxCapacity: 25)
  
  func callAsFunction() -> Outputs {
    let observable = apiObservable()
    
    // Action for the Generate button
    let generateAction = CocoaAction {
      .just(())
    }
    // Observable that makes an API call and shares its results
    let apiCall = generateAction.elements.flatMapLatest {
      observable
    }.share()
    // Observable that only emits "done" API call events (not loading)
    let apiCallDoneOnly = apiCall
      .filter({
        switch $0 {
        case .done: return true
        default: return false
        }
      })
    
    let defaultEmoji = Constant.defaultEmoji
    let defaultColors = Constant.colors.chooseTwo(maxDistance: 2)
    
    // Drives the isEnabled state of the back button
    let hasHistoryDriver = factStack.countRelay
      .map({ $0 > 1 })
      .asDriver(onErrorJustReturn: false)
      .startWith(false)
    // Drives the cat emoji
    let catEmojiDriver = apiCallDoneOnly
      .map({ _ in Constant.catEmojis.randomElement() ?? "" })
      .asDriver(onErrorJustReturn: defaultEmoji)
      .startWith(defaultEmoji)
    // Drives the background colors
    let backgroundColorsDriver = apiCallDoneOnly
      .map({ _ in Constant.colors.chooseTwo(maxDistance: 2) })
      .asDriver(onErrorJustReturn: defaultColors)
      .startWith(defaultColors)
    
    // A combination of the API observable and another last fact observable will drive
    // the fact body's text
    let backAction = CocoaAction {
      .just(())
    }
    let lastFactObservable = backAction.elements.flatMapLatest {
      Observable<LoadingState>.create { [weak self] observer in
        self?.factStack.pop()
        if let (lastFact, exclamation) = self?.factStack.top() {
          observer.onNext(.done(fact: lastFact, exclamation: exclamation))
        }
        return Disposables.create()
      }
    }
    let loadingStateDriver = Observable
      .of(apiCall, lastFactObservable)
      .merge()
      .asDriver(onErrorJustReturn: .loading)
    
    return (
      generateAction,
      backAction,
      loadingStateDriver,
      hasHistoryDriver,
      catEmojiDriver,
      backgroundColorsDriver
    )
  }
  
  private func apiObservable() -> Observable<LoadingState> {
    Observable<LoadingState>.create { observer in
      observer.onNext(.loading)
      
      var components = URLComponents()
      components.scheme = Constant.API.scheme
      components.host = Constant.API.host
      components.path = Constant.API.path
      components.queryItems = Constant.API.queryParams.map {
        URLQueryItem(name: $0.key, value: $0.value)
      }
      
      if let url = components.url {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
          if let error = error {
            observer.onError(error)
          } else if let data = data {
            do {
              let json = try JSONSerialization.jsonObject(with: data, options: [])
              if
                let factDict = json as? [String: Any],
                let fact = factDict["fact"] as? String
              {
                let exclamation = Constant.exclamations.randomElement() ?? ""
                self?.factStack.push((fact, exclamation))
                observer.onNext(.done(fact: fact, exclamation: exclamation))
              }
            } catch {
              observer.onError(error)
            }
          }
          observer.onCompleted()
        }
        task.resume()
        
        return Disposables.create {
          task.cancel()
        }
      }
      return Disposables.create()
    }
  }
}

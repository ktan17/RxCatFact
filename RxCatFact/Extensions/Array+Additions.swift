//
//  Array+Additions.swift
//  RxCatFact
//
//  Created by Kevin Tan on 7/6/20.
//  Copyright © 2020 Kevin Tan. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
  func chooseTwo(maxDistance: Int) -> Array<Element> {
    guard
      let first = randomElement(),
      let index = firstIndex(of: first)
    else { return [] }
    
    let distance = (Int(arc4random()) % (maxDistance * 2))
    let adjustment = distance - maxDistance + (distance < maxDistance ? 0 : 1)
    let secondIndex = abs((index + adjustment) % count)
    
    return [first, self[secondIndex]]
  }
}

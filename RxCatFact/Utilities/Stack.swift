//
//  Stack.swift
//  RxCatFact
//
//  Created by Kevin Tan on 7/7/20.
//  Copyright © 2020 Kevin Tan. All rights reserved.
//

import Foundation

struct Stack<Element> {
  private let maxCapacity: Int
  private var array = [Element]()
  private var head = -1
  private var tail = 0
  
  init(maxCapacity: Int) {
    self.maxCapacity = maxCapacity
  }
  
  var isEmpty: Bool {
    head < 0
  }
  
  var count: Int {
    guard !isEmpty else { return 0 }
    
    let distance = head - tail
    return (distance < 0 ? maxCapacity + distance : distance) + 1
  }
  
  mutating func push(_ element: Element) {
    if array.count < maxCapacity {
      array.append(element)
      head += 1
    } else if count < maxCapacity {
      head = (head + 1) % maxCapacity
      array[head] = element
    } else {
      array[tail] = element
      tail = (tail + 1) % maxCapacity
      head = (head + 1) % maxCapacity
    }
  }
  
  @discardableResult
  mutating func pop() -> Element? {
    guard !isEmpty else { return nil }
    
    let element = array[head]
    if count == 1 {
      array.removeAll()
      tail = 0
      head = -1
    } else if count < maxCapacity {
      let _ = array.popLast()
      head -= 1
    } else {
      head = head == 0 ? maxCapacity - 1 : head - 1
    }
    return element
  }
  
  func top() -> Element? {
    isEmpty ? nil : array[head]
  }
  
  func printOut() {
    print("head is \(head), tail is \(tail), array is \(array)")
    for i in 0 ..< count {
      print(array[(tail + i) % maxCapacity], terminator: " ")
    }
    print("")
  }
}

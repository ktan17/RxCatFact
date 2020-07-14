//
//  Color+IntegerInit.swift
//  RxCatFact
//
//  Created by Kevin Tan on 7/6/20.
//  Copyright © 2020 Kevin Tan. All rights reserved.
//

import SwiftUI

extension Color {
  static let offBlack = Color(integerRed: 64, green: 64, blue: 64)
  static let ctaBlue = Color(integerRed: 75, green: 158, blue: 255)
  
  init(integerRed: Int, green: Int, blue: Int) {
    self.init(
      red: Double(integerRed) / 255,
      green: Double(green) / 255,
      blue: Double(blue) / 255
    )
  }
}

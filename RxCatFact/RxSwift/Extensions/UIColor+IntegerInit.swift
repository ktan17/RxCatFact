//
//  UIColor+IntegerInit.swift
//  RxCatFact
//
//  Created by Kevin Tan on 7/11/20.
//  Copyright © 2020 Kevin Tan. All rights reserved.
//

import UIKit

extension UIColor {
  static let offBlack = UIColor(integerRed: 64, green: 64, blue: 64)
  static let ctaBlue = UIColor(integerRed: 75, green: 158, blue: 255)
  
  convenience init(integerRed: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
    self.init(
      red: CGFloat(integerRed) / 255,
      green: CGFloat(green) / 255,
      blue: CGFloat(blue) / 255,
      alpha: alpha
    )
  }
}

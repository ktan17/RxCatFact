//
//  UIFont+Additions.swift
//  RxCatFact
//
//  Created by Kevin Tan on 7/14/20.
//  Copyright © 2020 Kevin Tan. All rights reserved.
//

import UIKit

extension UIFont {
  enum Style: String {
    case varelaRound = "VarelaRound-Regular"
    case lato = "Lato-Regular"
    case latoItalic = "Lato-Italic"
  }
  
  static func varelaRound(size: CGFloat) -> UIFont? {
    fontForStyle(.varelaRound, size: size)
  }
  
  static func lato(size: CGFloat) -> UIFont? {
    fontForStyle(.lato, size: size)
  }
  
  static func latoItalic(size: CGFloat) -> UIFont? {
    fontForStyle(.latoItalic, size: size)
  }
  
  private static func fontForStyle(_ style: Style, size: CGFloat) -> UIFont? {
    UIFont(name: style.rawValue, size: size)
  }
}

//
//  Font+Additions.swift
//  RxCatFact
//
//  Created by Kevin Tan on 7/6/20.
//  Copyright © 2020 Kevin Tan. All rights reserved.
//

import SwiftUI

extension Font {
  enum Style: String {
    case varelaRound = "VarelaRound-Regular"
    case lato = "Lato-Regular"
    case latoItalic = "Lato-Italic"
  }
  
  static func varelaRound(size: CGFloat) -> Font {
    fontForStyle(.varelaRound, size: size)
  }
  
  static func lato(size: CGFloat) -> Font {
    fontForStyle(.lato, size: size)
  }
  
  static func latoItalic(size: CGFloat) -> Font {
    fontForStyle(.latoItalic, size: size)
  }
  
  private static func fontForStyle(_ style: Style, size: CGFloat) -> Font {
    .custom(style.rawValue, size: size)
  }
}

//
//  UIView+DropShadow.swift
//  RxCatFact
//
//  Created by Kevin Tan on 7/12/20.
//  Copyright © 2020 Kevin Tan. All rights reserved.
//

import UIKit

extension UIView {
  func addDropShadow() {
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.35
    layer.shadowOffset = CGSize(width: 0, height: 4)
    layer.shadowRadius = 4
  }
}

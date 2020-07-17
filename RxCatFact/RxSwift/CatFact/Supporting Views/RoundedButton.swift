//
//  RoundedButton.swift
//  RxCatFact
//
//  Created by Kevin Tan on 7/11/20.
//  Copyright © 2020 Kevin Tan. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
  override var frame: CGRect {
    didSet {
      layer.cornerRadius = frame.height / 2
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .white
    imageView?.contentMode = .scaleAspectFit
    addDropShadow()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

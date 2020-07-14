//
//  GradientView.swift
//  RxCatFact
//
//  Created by Kevin Tan on 7/11/20.
//  Copyright © 2020 Kevin Tan. All rights reserved.
//

import UIKit

class GradientView: UIView {
  /// The colors for the gradient. The start color is at the bottom and the end color at the top.
  var colors: (startColor: UIColor, endColor: UIColor)
    = (.black, UIColor.black.withAlphaComponent(0.1)) {
    didSet {
      setNeedsDisplay()
    }
  }
  
  override var frame: CGRect {
    didSet {
      if !frame.size.equalTo(oldValue.size) {
        setNeedsDisplay()
      }
    }
  }
  
  override var bounds: CGRect {
    didSet {
      if !bounds.size.equalTo(oldValue.size) {
        setNeedsDisplay()
      }
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  private func commonInit() {
    backgroundColor = .clear
  }
  
  override func draw(_ rect: CGRect) {
    let startPoint = CGPoint(x: 0, y: bounds.maxY)
    let endPoint = CGPoint.zero
    let colors = [self.colors.startColor.cgColor, self.colors.endColor.cgColor] as CFArray
    let colorSpace = self.colors.startColor.cgColor.colorSpace
    let options = CGGradientDrawingOptions()
    
    if
      let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: nil),
      let context = UIGraphicsGetCurrentContext()
    {
      context.drawLinearGradient(
        gradient,
        start: startPoint,
        end: endPoint,
        options: options
      )
    }
  }
}

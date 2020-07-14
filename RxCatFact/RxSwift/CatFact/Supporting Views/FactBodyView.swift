//
//  FactBodyView.swift
//  RxCatFact
//
//  Created by Kevin Tan on 7/14/20.
//  Copyright © 2020 Kevin Tan. All rights reserved.
//

import UIKit

class FactBodyView: UIView {
  private enum Constant {
    static let cornerRadius: CGFloat = 20
    static let textPadding: CGFloat = 35
    static let fontSize: CGFloat = 20
  }
  
  private let label = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .white
    layer.cornerRadius = Constant.cornerRadius
    addDropShadow()
    
    label.font = .latoItalic(size: Constant.fontSize)
    label.numberOfLines = 0
    
    addSubview(label)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    label.preferredMaxLayoutWidth = bounds.width - Constant.textPadding * 2
    var labelFrame = CGRect.zero
    labelFrame.size = label.intrinsicContentSize
    labelFrame.origin.x = (bounds.width - labelFrame.width) / 2
    labelFrame.origin.y = (bounds.width - labelFrame.height) / 2
    
    label.frame = labelFrame
  }
  
  func setFact(to factString: NSAttributedString) {
    label.attributedText = factString
    setNeedsLayout()
  }
}

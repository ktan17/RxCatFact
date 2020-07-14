//
//  CatIconView.swift
//  RxCatFact
//
//  Created by Kevin Tan on 7/12/20.
//  Copyright © 2020 Kevin Tan. All rights reserved.
//

import UIKit

class CatIconView: UIView {
  private enum Constant {
    static let emojiSize: CGFloat = 88
  }
  
  override var frame: CGRect {
    didSet {
      layer.cornerRadius = frame.height / 2
    }
  }
  
  private let label = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .white
    addDropShadow()
    
    label.font = .systemFont(ofSize: Constant.emojiSize)
    addSubview(label)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    var labelFrame = CGRect.zero
    labelFrame.size = label.intrinsicContentSize
    labelFrame.origin.x = (bounds.width - labelFrame.width) / 2
    labelFrame.origin.y = (bounds.height - labelFrame.height) / 2
    
    label.frame = labelFrame
  }
  
  func setEmoji(to emoji: String) {
    label.text = emoji
    setNeedsLayout()
  }
}

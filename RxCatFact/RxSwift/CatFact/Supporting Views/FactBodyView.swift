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
  private let activityIndicator = UIActivityIndicatorView(style: .medium)
  
  var body: String {
    label.text ?? ""
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .white
    layer.cornerRadius = Constant.cornerRadius
    addDropShadow()
    
    label.font = .lato(size: Constant.fontSize)
    label.numberOfLines = 0
    
    addSubview(label)
    addSubview(activityIndicator)
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
    labelFrame.origin.y = (bounds.height - labelFrame.height) / 2
    
    var activityIndicatorFrame = CGRect.zero
    activityIndicatorFrame.size = activityIndicator.intrinsicContentSize
    activityIndicatorFrame.origin.x = (bounds.width - activityIndicatorFrame.width) / 2
    activityIndicatorFrame.origin.y = (bounds.height - activityIndicatorFrame.height) / 2
    
    label.frame = labelFrame
    activityIndicator.frame = activityIndicatorFrame
  }
  
  func setIsLoading() {
    label.alpha = 0
    activityIndicator.isHidden = false
    activityIndicator.startAnimating()
    
    setNeedsLayout()
  }
  
  func setFact(to factString: NSAttributedString) {
    label.attributedText = factString
    activityIndicator.isHidden = true
    
    UIView.transition(
      with: label, duration: 0.5,
      options: [.curveEaseInOut, .transitionCrossDissolve],
      animations: {
        self.label.alpha = 1.0
      },
      completion: nil
    )
    
    setNeedsLayout()
  }
}

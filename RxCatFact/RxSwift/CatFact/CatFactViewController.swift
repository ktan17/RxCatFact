//
//  CatFactViewController.swift
//  RxCatFact
//
//  Created by Kevin Tan on 7/11/20.
//  Copyright © 2020 Kevin Tan. All rights reserved.
//

import UIKit

class CatFactViewController: UIViewController {
  private enum Constant {
    static let iconBottomPadding: CGFloat = 36
    static let horizontalPadding: CGFloat = 20
    static let bodyHeight: CGFloat = 180
    static let bodyBottomPadding: CGFloat = 130
    static let circleButtonSide: CGFloat = 46
    static let buttonText = "Generate!"
    static let buttonFontSize: CGFloat = 28
    static let buttonWidth: CGFloat = 194
    static let buttonHeight: CGFloat = 54
    static let buttonCornerRadius: CGFloat = 20
    static let buttonHorizontalPadding: CGFloat = 18
    static let backImageName = "back"
    static let shareImageName = "share"
  }
  
  let gradientView = GradientView()
  let catIconView = CatIconView()
  let factBodyView = FactBodyView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    catIconView.setEmoji(to: "🐱")
    
    view.addSubview(gradientView)
    view.addSubview(catIconView)
    view.addSubview(factBodyView)
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    var gradientViewFrame = CGRect.zero
    gradientViewFrame.size = view.bounds.size
    
    var factBodyViewFrame = CGRect.zero
    factBodyViewFrame.size.width = view.bounds.width - Constant.horizontalPadding * 2
    factBodyViewFrame.size.height = Constant.bodyHeight
    factBodyViewFrame.origin.x = (view.bounds.width - factBodyViewFrame.width) / 2
    factBodyViewFrame.origin.y = (view.bounds.height - factBodyViewFrame.height) / 2
    
    var catIconViewFrame = CGRect.zero
    catIconViewFrame.size.width = view.bounds.width / 3
    catIconViewFrame.size.height = catIconViewFrame.width
    catIconViewFrame.origin.x = (view.bounds.width - catIconViewFrame.width) / 2
    catIconViewFrame.origin.y = factBodyViewFrame.minY - Constant.iconBottomPadding - catIconViewFrame.height
    
    gradientView.frame = gradientViewFrame
    catIconView.frame = catIconViewFrame
    factBodyView.frame = factBodyViewFrame
  }
}

//
//  CatFactViewController.swift
//  RxCatFact
//
//  Created by Kevin Tan on 7/11/20.
//  Copyright © 2020 Kevin Tan. All rights reserved.
//

import UIKit
import RxSwift

class CatFactViewController: UIViewController {
  private enum Constant {
    static let iconBottomPadding: CGFloat = 36
    static let horizontalPadding: CGFloat = 20
    static let bodyHeight: CGFloat = 180
    static let circleButtonSide: CGFloat = 46
    static let textFontSize: CGFloat = 20
    static let buttonText = "Generate!"
    static let buttonFontSize: CGFloat = 28
    static let buttonWidth: CGFloat = 194
    static let buttonHeight: CGFloat = 54
    static let buttonCornerRadius: CGFloat = 20
    static let buttonHorizontalPadding: CGFloat = 25
    static let buttonPadding: CGFloat = 25
    static let backImageName = "back"
    static let shareImageName = "share"
  }
  
  private let viewModel = RxCatFactViewModel()
  private let disposeBag = DisposeBag()
  
  let gradientView = GradientView()
  let catIconView = CatIconView()
  let factBodyView = FactBodyView()
  var backButton = RoundedButton()
  var generateButton = RoundedButton()
  let shareButton = RoundedButton()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let outputs = viewModel()
    
    generateButton.rx.action = outputs.generateAction
    backButton.rx.action = outputs.backAction
    
    outputs.backgroundColors.drive(onNext: { [weak self] (colors) in
      guard let self = self else { return }
      UIView.transition(
        with: self.gradientView,
        duration: 0.5,
        options: [.curveEaseInOut, .transitionCrossDissolve],
        animations: {
          self.gradientView.colors = (colors[0], colors[1])
        },
        completion: nil
      )
    }).disposed(by: disposeBag)
    outputs.catEmoji.drive(onNext: { [weak self] (emoji) in
      self?.catIconView.setEmoji(to: emoji)
    }).disposed(by: disposeBag)
    outputs.hasHistory.drive(onNext: { [weak self] (hasHistory) in
      self?.backButton.isEnabled = hasHistory
    }).disposed(by: disposeBag)
    outputs.loadingState.drive(onNext: { [weak self] (loadingState) in
      switch loadingState {
      case .loading:
        self?.factBodyView.setIsLoading()
      case .done(let fact, let exclamation):
        let attrString = NSMutableAttributedString(string: fact + " " + exclamation)
        attrString.addAttributes(
          [.font : UIFont.latoItalic(size: Constant.textFontSize) as Any],
          range: NSRange(location: fact.count + 1, length: exclamation.count)
        )
        self?.shareButton.isEnabled = true
        self?.factBodyView.setFact(to: attrString)
      }
      
    }).disposed(by: disposeBag)
    
    backButton.setImage(
      UIImage(named: Constant.backImageName)?.withRenderingMode(.alwaysTemplate),
      for: .normal
    )
    backButton.tintColor = .ctaBlue
    backButton.isEnabled = false
    
    generateButton.setTitle(Constant.buttonText, for: .normal)
    generateButton.setTitleColor(.ctaBlue, for: .normal)
    generateButton.setTitleColor(.ctaBlueHighlighted, for: .highlighted)
    generateButton.titleLabel?.font = .varelaRound(size: Constant.buttonFontSize)
    
    shareButton.setImage(
      UIImage(named: Constant.shareImageName)?.withRenderingMode(.alwaysTemplate),
      for: .normal
    )
    shareButton.tintColor = .ctaBlue
    shareButton.isEnabled = false
    shareButton.addTarget(self, action: #selector(tappedShareButton), for: .touchUpInside)
    
    view.addSubview(gradientView)
    view.addSubview(catIconView)
    view.addSubview(factBodyView)
    view.addSubview(backButton)
    view.addSubview(generateButton)
    view.addSubview(shareButton)
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
    
    var generateButtonFrame = CGRect.zero
    generateButtonFrame.size.width = Constant.buttonWidth
    generateButtonFrame.size.height = Constant.buttonHeight
    generateButtonFrame.origin.x = (view.bounds.width - generateButtonFrame.width) / 2
    generateButtonFrame.origin.y = view.bounds.height - view.safeAreaInsets.bottom - generateButtonFrame.height - Constant.buttonPadding
    
    var backButtonFrame = CGRect.zero
    backButtonFrame.size.width = Constant.circleButtonSide
    backButtonFrame.size.height = backButtonFrame.width
    backButtonFrame.origin.x = generateButtonFrame.minX - Constant.buttonHorizontalPadding - backButtonFrame.width
    backButtonFrame.origin.y = generateButtonFrame.midY - backButtonFrame.height / 2
    
    var shareButtonFrame = CGRect.zero
    shareButtonFrame.size.width = Constant.circleButtonSide
    shareButtonFrame.size.height = shareButtonFrame.width
    shareButtonFrame.origin.x = generateButtonFrame.maxX + Constant.buttonHorizontalPadding
    shareButtonFrame.origin.y = generateButtonFrame.midY - shareButtonFrame.height / 2
    
    gradientView.frame = gradientViewFrame
    catIconView.frame = catIconViewFrame
    factBodyView.frame = factBodyViewFrame
    backButton.frame = backButtonFrame
    generateButton.frame = generateButtonFrame
    generateButton.layer.cornerRadius = Constant.buttonCornerRadius
    shareButton.frame = shareButtonFrame
  }
  
  @objc func tappedShareButton() {
    let activityController = UIActivityViewController(
      activityItems: [factBodyView.body],
      applicationActivities: nil
    )
    present(activityController, animated: true, completion: nil)
  }
}

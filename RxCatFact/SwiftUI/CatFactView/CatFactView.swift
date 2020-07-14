//
//  CatFactView.swift
//  RxCatFact
//
//  Created by Kevin Tan on 7/5/20.
//  Copyright © 2020 Kevin Tan. All rights reserved.
//

import SwiftUI
import Combine

struct CatFactView: View {
  private enum Constant {
    static let stackOffset: CGFloat = 22
    static let iconBottomPadding: CGFloat = 36
    static let horizontalPadding: CGFloat = 20
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
  
  @ObservedObject private var viewModel = CatFactViewModel()
  @State private var isSharePresented = false
  @State private var isInitialLoad = true
  
  var body: some View {
    let outputs = self.viewModel.outputs
    return GeometryReader { screenGeometry in
      ZStack {
        GradientBackground(colors: outputs.backgroundColors)
          .edgesIgnoringSafeArea(.top)
          .transition(.opacity)
          .id(outputs.backgroundColors.hashValue)
        VStack {
          CatIcon(catEmoji: outputs.catEmoji)
            .frame(
              width: screenGeometry.size.width / 3,
              height: screenGeometry.size.width / 3
          )
            .padding(.bottom, Constant.iconBottomPadding)
          FactBody(loadingState: outputs.loadingState)
            .padding(.horizontal, Constant.horizontalPadding)
            .padding(.bottom, Constant.bodyBottomPadding)
          HStack {
            CircleIconButton(imageName: Constant.backImageName, action: {
              self.viewModel.fetchLastFact()
            })
              .frame(width: Constant.circleButtonSide, height: Constant.circleButtonSide)
              .disabled(!outputs.hasHistory)
              .opacity(outputs.hasHistory ? 1 : 0.7)
            Spacer()
            Button(action: {
              self.isInitialLoad = false
              self.viewModel.fetchFact()
            }) {
              Text(Constant.buttonText)
                .font(.varelaRound(size: Constant.buttonFontSize))
                .foregroundColor(.ctaBlue)
            }
              .frame(
                width: Constant.buttonWidth,
                height: Constant.buttonHeight
              )
              .background(Color.white)
              .cornerRadius(Constant.buttonCornerRadius)
              .dropShadow()
            Spacer()
            CircleIconButton(imageName: Constant.shareImageName, action: {
              if case .done = self.viewModel.outputs.loadingState {
                self.isSharePresented = true
              }
            })
              .frame(width: Constant.circleButtonSide, height: Constant.circleButtonSide)
              .disabled(self.isInitialLoad)
              .opacity(!self.isInitialLoad ? 1 : 0.7)
              .sheet(isPresented: self.$isSharePresented, content: {
                self.activityViewController()
              })
          }
          .padding(.horizontal, Constant.horizontalPadding)
        }
        .position(
          x: screenGeometry.size.width / 2,
          y: screenGeometry.size.height / 2 + Constant.stackOffset
        )
      }
    }
  }
  
  private func activityViewController() -> ActivityViewController {
    let items: [Any]
    switch viewModel.outputs.loadingState {
    case .loading:
      items = []
    case .done(let fact, let exclamation):
      items = [fact + " " + exclamation]
    }
    return ActivityViewController(activityItems: items)
  }
}

struct CatFactView_Previews: PreviewProvider {
  static var previews: some View {
    CatFactView()
  }
}

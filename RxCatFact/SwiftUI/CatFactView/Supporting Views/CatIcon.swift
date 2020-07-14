//
//  CatIcon.swift
//  RxCatFact
//
//  Created by Kevin Tan on 7/6/20.
//  Copyright © 2020 Kevin Tan. All rights reserved.
//

import SwiftUI

struct CatIcon: View {
  private enum Constant {
    static let emojiSize: CGFloat = 88
  }
  
  let catEmoji: String
  
  var body: some View {
    ZStack {
      Circle()
        .foregroundColor(.white)
        .dropShadow()
      Text(catEmoji)
        .font(.system(size: Constant.emojiSize))
    }
  }
}

struct CatIcon_Previews: PreviewProvider {
  static var previews: some View {
    CatIcon(catEmoji: "🐱")
  }
}

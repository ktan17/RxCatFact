//
//  CircleIconButton.swift
//  RxCatFact
//
//  Created by Kevin Tan on 7/6/20.
//  Copyright © 2020 Kevin Tan. All rights reserved.
//

import SwiftUI

struct CircleIconButton: View {
  let imageName: String
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      ZStack {
        Circle()
          .foregroundColor(.white)
          .dropShadow()
        Image(imageName)
          .renderingMode(.template)
          .foregroundColor(.ctaBlue)
      }
    }
  }
}

struct CircleIconButton_Previews: PreviewProvider {
  static var previews: some View {
    CircleIconButton(imageName: "back") { }
  }
}

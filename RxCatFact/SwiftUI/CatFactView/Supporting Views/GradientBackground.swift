//
//  GradientBackground.swift
//  RxCatFact
//
//  Created by Kevin Tan on 7/6/20.
//  Copyright © 2020 Kevin Tan. All rights reserved.
//

import SwiftUI

struct GradientBackground: View {
  let colors: [Color]
  
  var body: some View {
    LinearGradient(
      gradient: Gradient(colors: colors),
      startPoint: .top,
      endPoint: .bottom
    )
  }
}

struct GradientBackground_Previews: PreviewProvider {
  static var previews: some View {
    GradientBackground(colors: [.red, .blue])
  }
}

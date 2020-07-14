//
//  View+DropShadow.swift
//  RxCatFact
//
//  Created by Kevin Tan on 7/6/20.
//  Copyright © 2020 Kevin Tan. All rights reserved.
//

import SwiftUI

extension View {
  func dropShadow() -> some View {
    shadow(radius: 4.0, y: 4.0)
  }
}

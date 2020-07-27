//
//  ContentView.swift
//  RxCatFact
//
//  Created by Kevin Tan on 6/25/20.
//  Copyright © 2020 Kevin Tan. All rights reserved.
//

import SwiftUI

struct MainView: View {
  var body: some View {
    TabView {
      CatFactViewControllerAdapter()
        .tabItem {
          Image("rxswift")
          Text("RxSwift")
        }
      CatFactView()
        .tabItem {
          Image("swiftui")
          Text("SwiftUI")
        }
    }
    .edgesIgnoringSafeArea(.top)
  }
}

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}

//
//  ActivityViewController.swift
//  RxCatFact
//
//  Created by Kevin Tan on 7/9/20.
//  Copyright © 2020 Kevin Tan. All rights reserved.
//

import UIKit
import SwiftUI

struct ActivityViewController: UIViewControllerRepresentable {
  let activityItems: [Any]
  let applicationActivities: [UIActivity]? = nil
  
  func makeUIViewController(context: Context) -> UIActivityViewController {
    let controller = UIActivityViewController(
      activityItems: activityItems,
      applicationActivities: applicationActivities
    )
    return controller
  }
  
  func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

//
//  AppearanceController.swift
//  Line
//
//  Created by 장석우 on 8/6/24.
//

import Foundation
import Combine

protocol AppearanceControllable {
  var appearance: AppearanceType { get set }
  
  func changeAppearance(_ willBeAppearance: AppearanceType)
}

class AppearanceController: AppearanceControllable, ObservableObjectSettable {
  
  var objectWillChange: ObservableObjectPublisher?
  
  var appearance: AppearanceType = .automatic {
    didSet {
      objectWillChange?.send()
    }
  }
  
  func changeAppearance(_ willBeAppearance: AppearanceType) {
    appearance = willBeAppearance
  }
}


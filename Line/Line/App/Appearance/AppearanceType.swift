//
//  AppearanceType.swift
//  Line
//
//  Created by 장석우 on 8/6/24.
//

import SwiftUI

enum AppearanceType: Int, CaseIterable, SettingItemable {
  case automatic
  case light
  case dark
  
  var label: String {
    switch self {
    case .automatic:
      return "시스템 몯,"
    case .light:
      return "라이트모드"
    case .dark:
      return "다크모드"
    }
  }
  
  var colorSchems: ColorScheme? {
    switch self {
    case .automatic:
      return nil
    case .light:
      return .light
    case .dark:
      return .dark
    }
  }
}

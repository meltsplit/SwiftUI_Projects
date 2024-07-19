//
//  MainTabType.swift
//  Line
//
//  Created by 장석우 on 7/19/24.
//

import Foundation

enum MainTabType: CaseIterable {
  case home
  case chat
  case phone
  
  var title: String {
    switch self {
      
    case .home:
      return "홈"
    case .chat:
      return "채팅"
    case .phone:
      return "전화"
    }
  }
  
  func imageName(isSelected: Bool) -> String {
    switch self {
    case .home:
      return isSelected ? "house" : "house.fill"
    case .chat:
      return isSelected ? "bubble" : "bubble.fill"
    case .phone:
      return isSelected ? "phone" : "phone.fill"
    }
  }
}

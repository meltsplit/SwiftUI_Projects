//
//  ChatItemDirection.swift
//  Line
//
//  Created by 장석우 on 7/25/24.
//

import SwiftUI

enum ChatItemDirection {
  case left
  case right
  
  var color: Color {
    switch self {
    case .left: return .white
    case .right: return .yellow
    }
  }
  
  var alignment: Alignment {
    switch self {
    case .left: return .topLeading
    case .right: return .topTrailing
    }
  }
  
  var image: Image {
    switch self {
    case .left: return Image(.tailLeft)
    case .right: return Image(.tailRight)
    }
  }
}

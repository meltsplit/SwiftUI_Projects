//
//  MyProfileMenuType.swift
//  Line
//
//  Created by 장석우 on 7/24/24.
//

import Foundation

enum MyProfileMenuType: Hashable, CaseIterable {
    case studio
    case decorate
    case keep
    case story
    
    var description: String {
        switch self {
        case .studio:
            return "스튜디오"
        case .decorate:
            return "꾸미기"
        case .keep:
            return "Keep"
        case .story:
            return "스토리"
        }
    }
    
    var imageName: String {
        switch self {
        case .studio:
            return "face.smiling.fill"
        case .decorate:
            return "paintpalette.fill"
        case .keep:
            return "bookmark.fill"
        case .story:
            return "play.circle.fill"
        }
    }
}


let menus: [[String]] =
[
  ["face.smiling.fill", "스튜디오"],
  ["bookmark.fill","Keep"],
  ["play.circle.fill","스토리"]
]

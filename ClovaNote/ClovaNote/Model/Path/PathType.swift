//
//  PathType.swift
//  ClovaNote
//
//  Created by 장석우 on 6/24/24.
//

import Foundation


enum PathType: Hashable {
  case home
  case todo
  case memo(isCreateModel: Bool, memo: Memo?)
  case voice
  case timer
  
  var title: String {
    switch self {
      
    case .home:
      "홈"
    case .todo:
      "To do 리스트"
    case .memo:
      "메모"
    case .voice:
      "음성 메모"
    case .timer:
      "타이머"
    }
  }
}

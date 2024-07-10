//
//  Tab.swift
//  ClovaNote
//
//  Created by 장석우 on 7/10/24.
//

import Foundation

enum Tab: CaseIterable {
  case todoList
  case memo
  case voiceRecorder
  case timer
  case setting
  
  var title: String {
    switch self {
    case .todoList:
      "To do 리스트"
    case .memo:
      "메모"
    case .voiceRecorder:
      "음성 메모"
    case .timer:
      "타이머"
    case .setting:
      "설정"
    }
  }
}

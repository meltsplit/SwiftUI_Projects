//
//  Momo.swift
//  ClovaNote
//
//  Created by 장석우 on 6/27/24.
//

import Foundation

struct Memo: Hashable {
  var id: UUID
  var title: String
  var content: String
  var date: Date
  
  init(
    id: UUID = UUID(),
    title: String = "",
    content: String = "",
    date: Date = Date.now
  ) {
    self.id = id
    self.title = title
    self.content = content
    self.date = date
  }
}

extension Memo {
  static func mock() -> Memo {
    return .init(title: "장볼 것", content: "뭐 자", date: Date.now)
  }
  
  static func mock2() -> Memo {
    return .init(title: "장볼 것dlqslek", content: "뭐 자", date: Date.now)
  }
}

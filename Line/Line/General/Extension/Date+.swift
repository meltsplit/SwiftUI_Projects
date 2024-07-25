//
//  Date+.swift
//  Line
//
//  Created by 장석우 on 7/25/24.
//

import Foundation

extension Date {
  var toChatDateKey: String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "yyyy.MM.dd E"
    return formatter.string(from: self)
  }
  
  var toChatTime: String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "a h:mm"
    return formatter.string(from: self)
  }
}

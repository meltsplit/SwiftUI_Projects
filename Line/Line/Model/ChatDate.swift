//
//  ChatDate.swift
//  Line
//
//  Created by 장석우 on 7/25/24.
//

import Foundation

struct ChatDate: Hashable, Identifiable {
  var id: String { dateStr }
  var dateStr: String
  var chats: [Chat]
}

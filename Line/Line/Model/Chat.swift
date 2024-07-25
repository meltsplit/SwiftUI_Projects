//
//  Chat.swift
//  Line
//
//  Created by 장석우 on 7/25/24.
//

import Foundation

struct Chat: Hashable, Identifiable {
  var id: String { chatID }
  var chatID: String
  var userID: String
  var message: String?
  var photoURL: String?
  var date: Date
}

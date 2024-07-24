//
//  ChatRoom.swift
//  Line
//
//  Created by 장석우 on 7/24/24.
//

import Foundation

struct ChatRoom {
  var chatRoomID: String
  var lastMessage: String?
  var otherUserID: String
  var otherUserName: String
}

extension ChatRoom {
  func toObject() -> ChatRoomObject {
    return .init(chatRoomID: chatRoomID, lastMessage: lastMessage, otherUserID: otherUserID, otherUserName: otherUserName)
  }
}

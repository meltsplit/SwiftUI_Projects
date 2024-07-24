//
//  ChatRoomObject.swift
//  Line
//
//  Created by 장석우 on 7/24/24.
//

import Foundation

struct ChatRoomObject: Codable {
  var chatRoomID: String
  var lastMessage: String?
  var otherUserID: String
  var otherUserName: String
}

extension ChatRoomObject {

  func toModel() -> ChatRoom {
    return .init(chatRoomID: chatRoomID, lastMessage: lastMessage, otherUserID: otherUserID, otherUserName: otherUserName)
  }
}

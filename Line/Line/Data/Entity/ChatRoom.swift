//
//  ChatRoom.swift
//  Line
//
//  Created by 장석우 on 7/24/24.
//

import Foundation

struct ChatRoom: Hashable {
  var chatRoomID: String
  var lastMessage: String?
  var otherUserID: String
  var otherUserName: String
}

extension ChatRoom {
  func toObject() -> ChatRoomObject {
    return .init(chatRoomID: chatRoomID, lastMessage: lastMessage, otherUserID: otherUserID, otherUserName: otherUserName)
  }
  
  static var stub1: ChatRoom {
    return .init(chatRoomID: "cr_1", otherUserID: "user_1", otherUserName: "곰돌이")
  }
  
  static var stub2: ChatRoom {
    return .init(chatRoomID: "cr_2", otherUserID: "user_2", otherUserName: "이유진")
  }
}

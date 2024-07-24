//
//  UploadSourceType.swift
//  Line
//
//  Created by 장석우 on 7/22/24.
//

import Foundation

enum UploadSourceType {
  case chat(chatRoomID: String)
  case profile(userID: String)
  
  var path: String {
    switch self {
    case let .chat(chatRoomID): //Chat/chatRoomID
      return "\(DBKey.Chats)/\(chatRoomID)"
    case let .profile(userID): //User/userID
      return "\(DBKey.Users)/\(userID)"
    }
  }
}

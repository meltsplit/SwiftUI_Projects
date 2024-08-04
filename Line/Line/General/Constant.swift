//
//  Constant.swift
//  Line
//
//  Created by 장석우 on 7/19/24.
//

import Foundation

typealias DBKey = Constant.DBKey

enum Constant {
  
}

extension Constant {
  struct DBKey {
    static let Users = "Users"
    static let ChatRooms = "ChatRooms"
    static let Chats = "Chats"
    
    static let description = "description"
    static let profileURL = "profileURL"
    static let lastMessage = "lastMessage"
    static let chatRoomID = "chatRoomID"
    static let otherUserID = "otherUserID"
    static let otherUserName = "otherUserName"
    static let fcmToken = "fcmToken"
  }
  
}

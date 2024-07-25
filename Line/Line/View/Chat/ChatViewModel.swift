//
//  ChatViewModel.swift
//  Line
//
//  Created by 장석우 on 7/25/24.
//

import Foundation
import Combine

class ChatViewModel: ObservableObject {
  
  enum Action {
    
  }
  
  @Published var myUser: User?
  @Published var otherUser: User?
  @Published var chatDateList: [ChatDate] = []
  @Published var message: String = ""
  
  private let chatRoomID: String
  private let myUserID: String
  private let otherUserID: String
  
  private var container: DIContainer
  private var subscriptions = Set<AnyCancellable>()
  
  init(
    chatRoomID: String,
    myUserID: String,
    otherUserID: String,
    container: DIContainer
  ) {
    self.chatRoomID = chatRoomID
    self.myUserID = myUserID
    self.otherUserID = otherUserID
    self.container = container
//    
//    udpateChatDateList(.init(chatID: "c1", userID: "user_1", message: "hi", date: Date()))
//    udpateChatDateList(.init(chatID: "c2", userID: "user_2", message: "hello", date: Date()))
//    udpateChatDateList(.init(chatID: "c3", userID: "user_1", message: "mmememem", date: Date()))
//    
  }
  
  func udpateChatDateList(_ chat: Chat) {
    let key = chat.date.toChatDateKey
    
    if let index = chatDateList.firstIndex(where: { $0.dateStr == key }) {
      chatDateList[index].chats.append(chat)
    } else {
      let newChatDate = ChatDate(dateStr: key, chats: [chat])
      chatDateList.append(newChatDate)
    }
    
  }
  
  func getDirection(id: String) -> ChatItemDirection {
    return myUserID == id ? .right : .left
  }
  
  func send(action: Action) {
    
  }
  
  
}

/*
 Chats/
 chatRoomID/
 chatID1/ Chat
 chatID2/ Chat
 
 Chat
 Chat
 
 */

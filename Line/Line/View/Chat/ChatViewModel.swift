//
//  ChatViewModel.swift
//  Line
//
//  Created by 장석우 on 7/25/24.
//

import SwiftUI
import Combine
import PhotosUI

class ChatViewModel: ObservableObject {
  
  enum Action {
    case load
    case addChat(String)
    case uploadImage(PhotosPickerItem?)
  }
  
  @Published var myUser: User?
  @Published var otherUser: User?
  @Published var chatDateList: [ChatDate] = []
  @Published var message: String = ""
  @Published var imageSelection: PhotosPickerItem? {
    didSet {
      send(action: .uploadImage(imageSelection))
    }
  }
  
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
    
    bind()
  }
  
  private func bind() {
    container.service.chatService.observeChat(chatRoomID: chatRoomID)
      .sink(receiveValue: { [weak self] chat in
        guard let chat else { return }
        self?.udpateChatDateList(chat)
      })
      .store(in: &subscriptions)

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
    switch action {
    case .load:
      Publishers.Zip(
        container.service.userService.getUser(userID: self.myUserID),
        container.service.userService.getUser(userID: self.otherUserID)
      )
      .sink { completion in
        //TODO:
      } receiveValue: { (myUser, otherUser) in
        self.myUser = myUser
        self.otherUser = otherUser
      }
      .store(in: &subscriptions)
    
    case let .addChat(message):
      let chat: Chat = .init(chatID: UUID().uuidString, userID: myUserID, message: message, date: Date())
      container.service.chatService.addChat(chat, to: chatRoomID)
        .flatMap { chat in
          self.container.service.chatRoomService.updateChatRoomLastMessage(
            chatRoomID: self.chatRoomID,
            myUserID: self.myUserID,
            myUserName: self.myUser?.name ?? "",
            otherUserID: self.otherUserID,
            lastMessage: chat.lastMessage)
          
        }
        .sink { completion in
          //TODO:
        } receiveValue: { [weak self] chat in
          self?.message = ""
        }
        .store(in: &subscriptions)
        
    case let .uploadImage(imageSelection):
      guard let imageSelection else { return }
      let chatRoomID = chatRoomID
      container.service.photoService.loadTransferable(from: imageSelection)
        .map { (UploadSourceType.chat(chatRoomID: chatRoomID), $0 )}
        .flatMap{ param in
          self.container.service.uploadService.uploadImage(source: param.0, data: param.1)
        }
        .flatMap { url in
          let chat = Chat(chatID: UUID().uuidString, userID: self.myUserID, photoURL: url.absoluteString, date: Date())
          return self.container.service.chatService.addChat(chat, to: chatRoomID)
        }
        .flatMap { chat in
          self.container.service.chatRoomService.updateChatRoomLastMessage(
            chatRoomID: self.chatRoomID,
            myUserID: self.myUserID,
            myUserName: self.myUser?.name ?? "",
            otherUserID: self.otherUserID,
            lastMessage: chat.lastMessage)
          
        }
        .sink { completion in
          //TODO:
        } receiveValue: { url in
          
        }
        .store(in: &subscriptions)
      

      
    }
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

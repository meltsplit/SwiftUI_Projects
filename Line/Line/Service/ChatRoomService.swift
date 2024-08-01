//
//  ChatRoomService.swift
//  Line
//
//  Created by 장석우 on 7/24/24.
//

import Foundation
import Combine

protocol ChatRoomServiceType {
  func createChatRoomIfNeeded(myUserID: String, otherUserID: String, otherUserName: String) -> AnyPublisher<ChatRoom, ServiceError>
  func loadChatRooms(myUserID: String) -> AnyPublisher<[ChatRoom], ServiceError>
  func updateChatRoomLastMessage(
    chatRoomID: String,
    myUserID: String,
    myUserName: String,
    otherUserID: String,
    lastMessage: String
  ) -> AnyPublisher<Void, ServiceError>
}

class ChatRoomService: ChatRoomServiceType {
  
  private var dbRepository: ChatRoomDBRepositoryType
  
  init(dbRepository: ChatRoomDBRepositoryType) {
    self.dbRepository = dbRepository
  }
  
  func createChatRoomIfNeeded(myUserID: String, otherUserID: String, otherUserName: String) -> AnyPublisher<ChatRoom, ServiceError> {
    dbRepository.getChatRoom(myUserID: myUserID, otherUserID: otherUserID)
      .mapError { ServiceError.error($0) }
      .flatMap { object in
        if let object {
          return Just(object.toModel()).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
        }
        else {
          let newChatRoom = ChatRoom(chatRoomID: UUID().uuidString, otherUserID: otherUserID, otherUserName: otherUserName)
          return self.addChatRoom(newChatRoom, to: myUserID)
        }
      }
      .eraseToAnyPublisher()
  }
  
  func addChatRoom(_ chatRoom: ChatRoom, to myUserID: String) -> AnyPublisher<ChatRoom, ServiceError> {
    dbRepository.addChatRoom(chatRoom.toObject(), myUserID: myUserID)
      .map { chatRoom }
      .mapError { .error($0) }
      .eraseToAnyPublisher()
  }
  
  func loadChatRooms(myUserID: String) -> AnyPublisher<[ChatRoom], ServiceError> {
    dbRepository.loadChatRooms(myUserID: myUserID)
      .map { $0.map { $0.toModel()} }
      .mapError { .error($0) }
      .eraseToAnyPublisher()
  }
  
  func updateChatRoomLastMessage(
    chatRoomID: String,
    myUserID: String,
    myUserName: String,
    otherUserID: String,
    lastMessage: String
  ) -> AnyPublisher<Void, ServiceError> {
    dbRepository.updateChatRoomLastMessage(chatRoomID: chatRoomID, myUserID: myUserID, myUserName: myUserName, otherUserID: otherUserID, lastMessage: lastMessage)
      .mapError { .error($0) }
      .eraseToAnyPublisher()
  }
  
}

class StubChatRoomService: ChatRoomServiceType {
  func createChatRoomIfNeeded(myUserID: String, otherUserID: String, otherUserName: String) -> AnyPublisher<ChatRoom, ServiceError> {
    Just(.stub1).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
  }
  
  func loadChatRooms(myUserID: String) -> AnyPublisher<[ChatRoom], ServiceError> {
    Just([.stub1, .stub2]).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
  }
  
  func updateChatRoomLastMessage(
    chatRoomID: String,
    myUserID: String,
    myUserName: String,
    otherUserID: String,
    lastMessage: String
  ) -> AnyPublisher<Void, ServiceError> {
    Empty().eraseToAnyPublisher()
  }
  
  
  
}

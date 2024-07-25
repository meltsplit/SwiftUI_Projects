//
//  ChatRoomDBRepository.swift
//  Line
//
//  Created by 장석우 on 7/24/24.
//

import Foundation
import Combine
import FirebaseDatabase

protocol ChatRoomDBRepositoryType {
  func getChatRoom(myUserID: String, otherUserID: String) -> AnyPublisher<ChatRoomObject?, DBError>
  func addChatRoom(_ object: ChatRoomObject, myUserID: String) -> AnyPublisher<Void, DBError>
  func loadChatRooms(myUserID: String) -> AnyPublisher<[ChatRoomObject], DBError>
}

class ChatRoomDBRepository: ChatRoomDBRepositoryType {
  
  var db: DatabaseReference = Database.database().reference()
  
  
  func getChatRoom(myUserID: String, otherUserID: String) -> AnyPublisher<ChatRoomObject?, DBError> {
    Future<Any?, DBError> { [weak self] promise in
      self?.db.child(DBKey.ChatRooms).child(myUserID).child(otherUserID).getData { error, snapshot in
        if let error { promise(.failure(.error(error))) }
        else if snapshot?.value is NSNull { promise(.success(nil))}
        else { promise(.success(snapshot?.value))}
      }
    }
    .flatMap { value in
      guard let value
      else { return Just<ChatRoomObject?>(nil).setFailureType(to: DBError.self).eraseToAnyPublisher() }
      return Just(value)
          .tryMap { try JSONSerialization.data(withJSONObject: $0) }
          .decode(type: ChatRoomObject?.self, decoder: JSONDecoder())
          .mapError { DBError.error($0) }
          .eraseToAnyPublisher()
    }
    .eraseToAnyPublisher()
  }
  
  func addChatRoom(_ object: ChatRoomObject, myUserID: String) -> AnyPublisher<Void, DBError> {
    Just(object)
      .tryCompactMap { try JSONEncoder().encode($0) }
      .tryCompactMap { try JSONSerialization.jsonObject(with: $0, options: .fragmentsAllowed) }
      .flatMap { value in
        Future<Void, Error> { [weak self] promise in
          self?.db.child(DBKey.ChatRooms).child(myUserID).child(object.otherUserID).setValue(value) { error, _ in
            if let error {
              promise(.failure(error))
            } else {
              promise(.success(()))
            }
          }
        }
        .eraseToAnyPublisher()
      }
      .mapError { DBError.error($0) }
      .eraseToAnyPublisher()
  }
  
  func loadChatRooms(myUserID: String) -> AnyPublisher<[ChatRoomObject], DBError> {
    Future<Any?, DBError> { [weak self] promise in
      self?.db.child(DBKey.ChatRooms).child(myUserID).getData { error, snapshot in
        if let error { promise(.failure(.error(error)))}
        else if snapshot?.value is NSNull { promise(.success(nil))}
        else { promise(.success(snapshot?.value))}
      }
    }
    .flatMap { value in
      guard let dic = value as? [String: [String: Any]]
      else { return Just<[ChatRoomObject]>([]).setFailureType(to: DBError.self).eraseToAnyPublisher() }
      return Just(dic)
        .tryMap { try JSONSerialization.data(withJSONObject: $0) }
        .decode(type: [String: ChatRoomObject].self, decoder: JSONDecoder())
        .map { $0.values.map { $0 as ChatRoomObject} }
        .mapError { DBError.error($0)}
        .eraseToAnyPublisher()
    }
    .eraseToAnyPublisher()
  }
  
}


class StubChatRoomDBRepository: ChatRoomDBRepositoryType {

  func getChatRoom(myUserID: String, otherUserID: String) -> AnyPublisher<ChatRoomObject?, DBError> {
    Empty().eraseToAnyPublisher()
  }
  
  func addChatRoom(_ object: ChatRoomObject, myUserID: String) -> AnyPublisher<Void, DBError> {
    Empty().eraseToAnyPublisher()
  }
  
  func loadChatRooms(myUserID: String) -> AnyPublisher<[ChatRoomObject], DBError> {
    Empty().eraseToAnyPublisher()
  }
  
}

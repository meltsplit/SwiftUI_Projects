//
//  ChatDBRepository.swift
//  Line
//
//  Created by 장석우 on 7/28/24.
//

import Foundation
import Combine
import FirebaseDatabase



protocol ChatDBRepositoryType {
  func addChat(_ object: ChatObject, to chatRoomID: String) -> AnyPublisher<Void, DBError>
  func childByAutoID(chatRoomID: String) -> String
  func observeChat(chatRoomID: String) -> AnyPublisher<ChatObject?, DBError>
  func removeObserverHandlers()
}

class ChatDBRepository: ChatDBRepositoryType {
  
  var db: DatabaseReference = Database.database().reference()
  
  var observedHandler = Set<UInt>()
  
  func addChat(_ object: ChatObject, to chatRoomID: String) -> AnyPublisher<Void, DBError> {
    Just(object)
      .tryCompactMap { try JSONEncoder().encode($0) } //ChatObject -> Data
      .tryCompactMap { try JSONSerialization.jsonObject(with: $0, options: .fragmentsAllowed) }
      .flatMap { value in
        Future { [weak self] promise in
          self?.db.child(DBKey.Chats).child(chatRoomID).child(object.chatID).setValue(value) { error, _ in
            if let error { promise (.failure(error))}
            else { promise(.success(())) }
          }
        }
      }
      .mapError { .error($0) }
      .eraseToAnyPublisher()
  }
  
  func childByAutoID(chatRoomID: String) -> String {
    let ref = db.child(DBKey.Chats).child(chatRoomID).childByAutoId()
    return ref.key ?? ""
  }
  
  func observeChat(chatRoomID: String) -> AnyPublisher<ChatObject?, DBError> {
    let subject = PassthroughSubject<Any?, DBError>()
    
    let handler = db.child(DBKey.Chats).child(chatRoomID).observe(.childAdded) { snapshot in
      subject.send(snapshot.value)
    }
    
    observedHandler.insert(handler)
    
    return subject
      .flatMap { value in
        if let value {
          return Just(value)
            .tryMap { try JSONSerialization.data(withJSONObject: $0)}
            .decode(type: ChatObject?.self, decoder: JSONDecoder())
            .mapError { DBError.error($0) }
            .eraseToAnyPublisher()
        } else {
          return Just(nil).setFailureType(to: DBError.self).eraseToAnyPublisher()
        }
        
      }
      .eraseToAnyPublisher()
  }
  
  func removeObserverHandlers() {
    observedHandler.forEach {
      db.removeObserver(withHandle: $0)
    }
  }
  
  
}

class StubDBRepository: ChatDBRepositoryType {
  
  func addChat(_ object: ChatObject, to chatRoomID: String) -> AnyPublisher<Void, DBError> {
    Empty().eraseToAnyPublisher()
  }
  
  func childByAutoID(chatRoomID: String) -> String {
    ""
  }
  
  func observeChat(chatRoomID: String) -> AnyPublisher<ChatObject?, DBError> {
    Empty().eraseToAnyPublisher()
  }
  
  func removeObserverHandlers() {
    
  }
}

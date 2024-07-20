//
//  UserDBRepository.swift
//  Line
//
//  Created by 장석우 on 7/19/24.
//

import Foundation
import Combine
import FirebaseDatabase

protocol UserDBRepositoryType {
  func addUser(_ object: UserObject) -> AnyPublisher<Void, DBError>
  func getUser(userID: String) -> AnyPublisher<UserObject, DBError>
}

class UserDBRepository: UserDBRepositoryType {
  
  var db: DatabaseReference = Database.database().reference()
  
  func addUser(_ object: UserObject) -> AnyPublisher<Void, DBError> {
    // 파베에 데이터 쓰려면 Dictionary 형태
    // oject -> data
    // data -> JSONSerialization
    Just(object)
      .compactMap { try? JSONEncoder().encode($0) }
      .compactMap { try? JSONSerialization.jsonObject(with: $0,options: .fragmentsAllowed) }
      .flatMap { value in
        Future<Void,Error> { [weak self] promise in
          self?.db.child(DBKey.Users).child(object.id).setValue(value) { error , _ in
            if let error {
              promise(.failure(error))
            } else {
              promise(.success(()))
            }
          }
        }
      }
      .mapError { DBError.error($0)}
      .eraseToAnyPublisher()
  }
  
  func getUser(userID: String) -> AnyPublisher<UserObject, DBError> {
    Future<Any?, DBError> { [weak self] promise in
      self?.db.child(DBKey.Users).child(userID).getData { error, snapshot in
        if let error { promise(.failure(.error(error))) }
        else if snapshot?.value is NSNull  {
          // 값이 없을 때 snapshow.value 에 NSNull이 들어옴
          // 주의할점 : NSNull != nil
          promise(.success(nil))
        } else {
          //snapshot.value 는 Dictionary 형태
          promise(.success(snapshot?.value))
        }
      }
    }
    .flatMap { value in
      if let value {
        return Just(value)
          .tryMap { try JSONSerialization.data(withJSONObject: $0) }
          .decode(type: UserObject.self, decoder: JSONDecoder())
          .mapError { DBError.error($0)}
          .eraseToAnyPublisher()
      } else {
        return Fail(error: DBError.emptyValue).eraseToAnyPublisher()
      }
    }.eraseToAnyPublisher()
  }
  
  
}

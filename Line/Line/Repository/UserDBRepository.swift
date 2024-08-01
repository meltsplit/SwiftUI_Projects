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
  func getUser(userID: String) async throws -> UserObject
  func updateUser(userID: String, key: String, value: Any) async throws
  func loadUsers() -> AnyPublisher<[UserObject], DBError>
  func addUserAfterContact(users: [UserObject]) -> AnyPublisher<Void, DBError>
}

class UserDBRepository: UserDBRepositoryType {
  
  var db: DatabaseReference = Database.database().reference()
  
  func addUser(_ object: UserObject) -> AnyPublisher<Void, DBError> {
    // 파베에 데이터 쓰려면 Dictionary 형태
    // object -> data
    // data -> JSONSerialization
    Just(object)
      .compactMap { try? JSONEncoder().encode($0) }
      .compactMap { try? JSONSerialization.jsonObject(with: $0, options: .fragmentsAllowed) }
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
    .flatMap { value -> AnyPublisher<UserObject, DBError> in
      guard let value else { return Fail(error: DBError.emptyValue).eraseToAnyPublisher() }
      return Just(value)
          .tryMap { try JSONSerialization.data(withJSONObject: $0) }
          .decode(type: UserObject.self, decoder: JSONDecoder())
          .mapError { DBError.error($0)}
          .eraseToAnyPublisher()
    }.eraseToAnyPublisher()
  }
  
  func getUser(userID: String) async throws -> UserObject {
    guard let value = try await self.db
                                    .child(DBKey.Users)
                                    .child(userID)
                                    .getData()
                                    .value
    else { throw DBError.emptyValue }
    
    let data = try JSONSerialization.data(withJSONObject: value)
    let object = try JSONDecoder().decode(UserObject.self, from: data)
    return object
  }
  
  func updateUser(userID: String, key: String, value: Any) async throws {
    try await self.db.child(DBKey.Users)
                     .child(userID)
                     .child(key)
                     .setValue(value)
                                    
  }
  
  func loadUsers() -> AnyPublisher<[UserObject], DBError> {
    Future<Any?, DBError> { [weak self] promise in
      self?.db.child(DBKey.Users).getData { error, snapshot in
        if let error { promise(.failure(.error(error)))}
        else if snapshot?.value is NSNull { promise(.failure(.emptyValue))}
        else { promise(.success(snapshot?.value)) }
      }
    }
    .flatMap { value -> AnyPublisher<[UserObject], DBError> in
      guard let dic = value as? [String: [String: Any]]
      else { return Fail(error: DBError.emptyValue).eraseToAnyPublisher() }
      return Just(dic)
        .tryMap { try JSONSerialization.data(withJSONObject: $0) }
        .decode(type: [String: UserObject].self, decoder: JSONDecoder())
        .map { Array($0.values) }
        .mapError { DBError.error($0) }
        .eraseToAnyPublisher()
      
    }
    .eraseToAnyPublisher()
  }
  
  func addUserAfterContact(users: [UserObject]) -> AnyPublisher<Void, DBError> {
    Publishers.Zip(users.publisher, users.publisher)
      .tryCompactMap { (origin, converted) -> (UserObject, Data) in
        let converted = try JSONEncoder().encode(converted)
        return (origin, converted)
      }
      .tryCompactMap { (origin, converted) -> (UserObject, Any) in
        let converted = try JSONSerialization.jsonObject(with: converted)
        return (origin, converted)
      }
      .flatMap { (origin, converted) -> Future<Void, Error> in
        Future<Void,Error> { [weak self] promise in
          self?.db.child(DBKey.Users).child(origin.id).setValue(converted) { error, _ in
            if let error { promise(.failure(error))}
            else { promise(.success(()))}
          }
        }
      }
      .last()
      .mapError { DBError.error($0) }
      .eraseToAnyPublisher()
  }
  
}

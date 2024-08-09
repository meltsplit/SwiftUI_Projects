//
//  UserDBRepository.swift
//  Line
//
//  Created by 장석우 on 7/19/24.
//

import Foundation
import Combine


protocol UserDBRepositoryType {
  func addUser(_ object: UserObject) -> AnyPublisher<Void, DBError>
  func getUser(userID: String) -> AnyPublisher<UserObject, DBError>
  func getUser(userID: String) async throws -> UserObject
  func updateUser(userID: String, key: String, value: Any) -> AnyPublisher<Void, DBError>
  func updateUser(userID: String, key: String, value: Any) async throws
  func loadUsers() -> AnyPublisher<[UserObject], DBError>
  func addUserAfterContact(users: [UserObject]) -> AnyPublisher<Void, DBError>
  func filterUsers(with queryString: String, userID: String) -> AnyPublisher<[UserObject], DBError>
}

class UserDBRepository: UserDBRepositoryType {
  
  //TODO: Delete
  
  private let reference: DBReferenceType
  
  init(reference: DBReferenceType) {
    self.reference = reference
  }
  
  func addUser(_ object: UserObject) -> AnyPublisher<Void, DBError> {
    // 파베에 데이터 쓰려면 Dictionary 형태
    // object -> data
    // data -> JSONSerialization
    Just(object)
      .compactMap { try? JSONEncoder().encode($0) }
      .compactMap { try? JSONSerialization.jsonObject(with: $0, options: .fragmentsAllowed) }
      .flatMap { [weak self] value -> AnyPublisher<Void, DBError> in
        guard let self else { return Empty().eraseToAnyPublisher() }
        return self.reference.setValue(key: DBKey.Users, path: object.id, value: value)
      }
      .mapError { DBError.error($0)}
      .eraseToAnyPublisher()
  }
  
  func getUser(userID: String) -> AnyPublisher<UserObject, DBError> {
    reference.fetch(key: DBKey.Users, path: userID)
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
    guard let value = try await self.reference.fetch(key: DBKey.Users, path: userID)
    else { throw DBError.emptyValue }
    
    let data = try JSONSerialization.data(withJSONObject: value)
    let object = try JSONDecoder().decode(UserObject.self, from: data)
    return object
  }
  
  func updateUser(userID: String, key: String, value: Any) -> AnyPublisher<Void, DBError> {
    reference.setValue(key: DBKey.Users, path: userID + "/" + key, value: value)
  }
  
  func updateUser(userID: String, key: String, value: Any) async throws {
    try await reference.setValue(key: DBKey.Users, path: userID + "/" + key, value: value)
  }
  
  func loadUsers() -> AnyPublisher<[UserObject], DBError> {
    reference.fetch(key: DBKey.Users, path: nil)
    .flatMap { value -> AnyPublisher<[UserObject], DBError> in
      
      guard let value
      else { return Just([]).setFailureType(to: DBError.self).eraseToAnyPublisher() }
      
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
      .compactMap { (origin, converted) -> (UserObject, Data)? in
        let converted = try? JSONEncoder().encode(converted)
        guard let converted else { return nil}
        return (origin, converted)
      }
      .compactMap { (origin, converted) -> (UserObject, Any)? in
        let converted = try? JSONSerialization.jsonObject(with: converted)
        guard let converted else { return nil}
        return (origin, converted)
      }
      .flatMap { [weak self] (origin, converted) -> AnyPublisher<Void, DBError> in
        guard let self else { return Empty().eraseToAnyPublisher() }
        return self.reference.setValue(key: DBKey.Users, path: origin.id, value: converted)
      }
      .last()
      .eraseToAnyPublisher()
  }
  
  func filterUsers(with queryString: String, userID: String) -> AnyPublisher<[UserObject], DBError> {
    
    reference.filter(key: DBKey.Users, path: nil, orderedName: "name", queryString: queryString)
      .flatMap { value -> AnyPublisher<[UserObject], DBError> in
      
      guard let value
      else { return Just([]).setFailureType(to: DBError.self).eraseToAnyPublisher() }
      
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
  
}

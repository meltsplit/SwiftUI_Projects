//
//  UserService.swift
//  Line
//
//  Created by 장석우 on 7/19/24.
//

import Foundation
import Combine

protocol UserServiceType {
  func addUser(_ user: User) -> AnyPublisher<User, ServiceError>
  func addUserAfterContact(users: [User]) -> AnyPublisher<Void, ServiceError>
  func getUser(userID: String) -> AnyPublisher<User, ServiceError>
  func getUser(userID: String) async throws -> User
  func loadUser(id: String) -> AnyPublisher<[User], ServiceError>
  func updateDescription(userID: String, description: String) async throws
  func updateProfile(userID: String, urlString: String) async throws
  func updateFCMToken(userID: String, fcmToken: String) -> AnyPublisher<Void,ServiceError>
  func filterUsers(with queryString: String, userID: String) -> AnyPublisher<[User], ServiceError>
}

class UserService: UserServiceType {
  
  private var dbRepository: UserDBRepositoryType
  
  init(dbRepository: UserDBRepositoryType) {
    self.dbRepository = dbRepository
  }
  
  func addUser(_ user: User) -> AnyPublisher<User, ServiceError> {
    dbRepository.addUser(user.toObject())
      .map { user }
      .mapError { .error($0) }
      .eraseToAnyPublisher()
  }
  
  func addUserAfterContact(users: [User]) -> AnyPublisher<Void, ServiceError> {
    dbRepository.addUserAfterContact(users: users.map { $0.toObject() })
      .mapError { .error($0) }
      .eraseToAnyPublisher()
  }
  
  func getUser(userID: String) -> AnyPublisher<User, ServiceError> {
    dbRepository.getUser(userID: userID)
      .map { $0.toModel() }
      .mapError { .error($0) }
      .eraseToAnyPublisher()
  }
  
  func getUser(userID: String) async throws -> User {
    let object = try await dbRepository.getUser(userID: userID)
    return object.toModel()
  }
  
  func updateDescription(userID: String, description: String) async throws {
    try await dbRepository.updateUser(userID: userID, key: DBKey.description, value: description)
  }
  
  func updateFCMToken(userID: String, fcmToken: String) -> AnyPublisher<Void, ServiceError> {
    dbRepository.updateUser(userID: userID, key: DBKey.fcmToken, value: fcmToken)
      .mapError { ServiceError.error($0)}
      .eraseToAnyPublisher()
  }
  
  func updateProfile(userID: String, urlString: String) async throws {
    try await dbRepository.updateUser(userID: userID, key: DBKey.profileURL, value: urlString)
  }

  
  func loadUser(id: String) -> AnyPublisher<[User], ServiceError> {
    dbRepository.loadUsers()
      .map {
        $0.map { $0.toModel() }
          .filter { $0.id != id}
      }
      .mapError { .error($0) }
      .eraseToAnyPublisher()
  }
  
  func filterUsers(with queryString: String, userID: String) -> AnyPublisher<[User], ServiceError> {
    dbRepository.filterUsers(with: queryString, userID: userID)
      .map { $0.map { $0.toModel() }.filter { $0.id != userID } }
      .mapError { ServiceError.error($0)}
      .eraseToAnyPublisher()
  }
  
  
}

class StubUserService: UserServiceType {

  func addUser(_ user: User) -> AnyPublisher<User, ServiceError> {
    Empty().eraseToAnyPublisher()
  }
  
  func addUserAfterContact(users: [User]) -> AnyPublisher<Void, ServiceError> {
    Empty().eraseToAnyPublisher()
  }
  
  func getUser(userID: String) -> AnyPublisher<User, ServiceError> {
    Just(.stub1).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
  }
  
  func getUser(userID: String) async throws -> User {
    .stub1
  }
  
  func loadUser(id: String) -> AnyPublisher<[User], ServiceError> {
    Just([.stub1, .stub2])
      .setFailureType(to: ServiceError.self)
      .eraseToAnyPublisher()
  }
  
  
  func updateDescription(userID: String, description: String) async throws {
    return
  }
  
  func updateProfile(userID: String, urlString: String) async throws {
    return
  }
  
  func updateFCMToken(userID: String, fcmToken: String) -> AnyPublisher<Void, ServiceError> {
    Empty().eraseToAnyPublisher()
  }
    
  func filterUsers(with queryString: String, userID: String) -> AnyPublisher<[User], ServiceError> {
    if queryString == "yujin" {
      return Just([.stub2]).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    } else {
      return Just([]).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
    
  }
  
}

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
  func getUser(userID: String) -> AnyPublisher<User, ServiceError>
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
  
  func getUser(userID: String) -> AnyPublisher<User, ServiceError> {
    dbRepository.getUser(userID: userID)
      .map { $0.toModel() }
      .mapError { .error($0) }
      .eraseToAnyPublisher()
  }
  
}

class StubUserService: UserServiceType {
  func addUser(_ user: User) -> AnyPublisher<User, ServiceError> {
    Empty().eraseToAnyPublisher()
  }
  
  func getUser(userID: String) -> AnyPublisher<User, ServiceError> {
    Empty().eraseToAnyPublisher()
  }
}

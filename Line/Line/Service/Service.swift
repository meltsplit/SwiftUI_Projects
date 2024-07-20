//
//  Service.swift
//  Line
//
//  Created by 장석우 on 7/16/24.
//

import Foundation

protocol ServiceType {
  var authService: AuthenticationServiceType { get set }
  var userService: UserServiceType { get set}
}

class Service: ServiceType {
  
  var authService: AuthenticationServiceType
  var userService: UserServiceType
  
  init(
    authService: AuthenticationServiceType = AuthenticationService(),
    userService: UserServiceType = UserService(dbRepository: UserDBRepository())
  ) {
    self.authService = authService
    self.userService = userService
  }
  
}


class StubService: ServiceType {
  
  var authService: AuthenticationServiceType
  var userService: UserServiceType
  
  init(
    authService: AuthenticationServiceType = StubAuthenticationService(),
    userService: UserServiceType = StubUserService()
  ) {
    self.authService = authService
    self.userService = userService
  }
  
}

//
//  Service.swift
//  Line
//
//  Created by 장석우 on 7/16/24.
//

import Foundation

protocol ServiceType {
  var authService: AuthenticationServiceType { get set }
  var userService: UserServiceType { get set }
  var contactService: ContactServiceType { get set }
}

class Service: ServiceType {
  
  var authService: AuthenticationServiceType
  var userService: UserServiceType
  var contactService: ContactServiceType
  
  init(
    authService: AuthenticationServiceType = AuthenticationService(),
    userService: UserServiceType = UserService(dbRepository: UserDBRepository()),
    contactService: ContactServiceType = ContactService()
  ) {
    self.authService = authService
    self.userService = userService
    self.contactService = contactService
  }
  
}


class StubService: ServiceType {
  
  var authService: AuthenticationServiceType
  var userService: UserServiceType
  var contactService: ContactServiceType
  
  init(
    authService: AuthenticationServiceType = StubAuthenticationService(),
    userService: UserServiceType = StubUserService(),
    contactService: ContactServiceType = StubContactService()
  ) {
    self.authService = authService
    self.userService = userService
    self.contactService = contactService
  }
  
}

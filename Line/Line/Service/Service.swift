//
//  Service.swift
//  Line
//
//  Created by 장석우 on 7/16/24.
//

import Foundation

protocol ServiceType {
  var authService: AuthenticationServiceType { get set }
}

class Service: ServiceType {
  
  var authService: AuthenticationServiceType
  
  init(
    authService: AuthenticationServiceType = AuthenticationService()
  ) {
    self.authService = authService
  }
  
}


class StubService: ServiceType {
  var authService: AuthenticationServiceType
  
  init(
    authService: AuthenticationServiceType = StubAuthenticationService()
  ) {
    self.authService = authService
  }
  
}

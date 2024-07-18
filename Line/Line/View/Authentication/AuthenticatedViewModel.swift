//
//  AuthenticatedViewModel.swift
//  Line
//
//  Created by 장석우 on 7/16/24.
//

import Foundation

enum AuthenticationState {
  case unauthenticated
  case authenticated
}

class AuthenticatedViewModel: ObservableObject {
  
  @Published var authenticated: AuthenticationState = .unauthenticated
  
  private var container: DIContainer
  
  init(container: DIContainer) {
    self.container = container
  }
  
  
  
}

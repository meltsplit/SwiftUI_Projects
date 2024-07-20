//
//  HomeViewModel.swift
//  Line
//
//  Created by 장석우 on 7/19/24.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
  
  @Published var myUser: User?
  @Published var friends: [User] = []
  
  private var userID: String
  private var container: DIContainer
  private var subscriptions = Set<AnyCancellable>()
  
  init(container: DIContainer, userID: String) {
    self.container = container
    self.userID = userID
  }
  
  enum Action {
    case getUser
  }
  
  func send(action: Action) {
    switch action {
    case .getUser:
      container.service.userService.getUser(userID: userID)
        .sink { completion in
          //TODO: 
        } receiveValue: { [weak self] user in
          self?.myUser = user
        }
        .store(in: &subscriptions)
      
    }
  }
  
  
}

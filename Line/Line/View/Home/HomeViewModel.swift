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
  @Published var phase: Phase = .notRequested
  @Published var modalDestination: HomeModalDestination?
  
  private var userID: String
  private var container: DIContainer
  private var subscriptions = Set<AnyCancellable>()
  
  
  init(container: DIContainer, userID: String) {
    self.container = container
    self.userID = userID
  }
  
  enum Action {
    case load
    case presentMyProfileView
    case presentOtherProfileView(String) // Associated Type이라고 부르더라
  }
  

  
  func send(action: Action) {
    switch action {
    case .load:
      phase = .loading
      container.service.userService.getUser(userID: userID)
        .handleEvents(receiveOutput: { [weak self] user in
          self?.myUser = user
        })
        .map { $0.id }
        .flatMap(container.service.userService.loadUser)
        .sink { [weak self] completion in
          if case .failure = completion { self?.phase = .fail }
          //TODO:
        } receiveValue: { [weak self] users in
          self?.phase = .success
          self?.friends = users
        }
        .store(in: &subscriptions)
      
    case .presentMyProfileView:
      modalDestination = .myProfile
    case let .presentOtherProfileView(userID):
      modalDestination = .otherProfile(userID)
    }
  }
  
  
}

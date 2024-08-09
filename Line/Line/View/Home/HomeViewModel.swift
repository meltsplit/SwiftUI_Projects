//
//  HomeViewModel.swift
//  Line
//
//  Created by 장석우 on 7/19/24.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
  
  enum Action {
    case load
    case requestContacts
    case presentView(HomeModalDestination)
    case goToChat(User)
  }
  
  @Published var myUser: User?
  @Published var friends: [User] = []
  @Published var phase: Phase = .notRequested
  @Published var modalDestination: HomeModalDestination?
  
  
  var userID: String
  private var container: DIContainer
  private var subscriptions = Set<AnyCancellable>()
  
  
  init(
    container: DIContainer,
    userID: String
  ) {
    self.container = container
    self.userID = userID
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
      
    case .requestContacts:
      container.service.contactService.fetchContact()
        .flatMap(container.service.userService.addUserAfterContact)
        .map { self.userID }
        .flatMap(container.service.userService.loadUser)
        .sink { completion in
          //TODO:
        } receiveValue: { [weak self] users in
          self?.friends = users
        }
        .store(in: &subscriptions)
      
    case let .goToChat(otherUser):
      container.service.chatRoomService.createChatRoomIfNeeded(myUserID: userID, otherUserID: otherUser.id, otherUserName: otherUser.name)
        .sink { completion in
          //TODO:
          return
        } receiveValue: { [weak self] chatRoom in
          guard let self else { return }
          self.container.navigationRouter.push(to: .chat(chatRoomID: chatRoom.chatRoomID,
                                                         myUserID: self.userID,
                                                         otherUserID: otherUser.id
                                                        ))
        }
        .store(in: &subscriptions)
      
    case let .presentView(destination):
      self.modalDestination = destination
      
    }
  }
  
  
}

//
//  ChatListViewModel.swift
//  Line
//
//  Created by 장석우 on 7/25/24.
//

import Foundation
import Combine

class ChatListViewModel: ObservableObject {
  
  enum Action {
    case load
  }
  
  @Published var chatRooms: [ChatRoom] = []
  
  private var container: DIContainer
  var userID: String
  private var subscriptions = Set<AnyCancellable>()
  
  init(container: DIContainer, userID: String) {
    self.container = container
    self.userID = userID
  }
  
  func send(action: Action) {
    switch action {
    case .load:
      container.service.chatRoomService.loadChatRooms(myUserID: userID)
        .sink { completion in
          //TODO:
        } receiveValue: { [weak self] chatRooms in
          self?.chatRooms = chatRooms
        }
        .store(in: &subscriptions)

      
    }
  }
  
}

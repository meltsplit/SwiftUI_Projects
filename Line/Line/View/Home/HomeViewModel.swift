//
//  HomeViewModel.swift
//  Line
//
//  Created by 장석우 on 7/19/24.
//

import Foundation

class HomeViewModel: ObservableObject {
  
  @Published var myUser: User?
  @Published var friends: [User] = [.stub1, .stub2]
  
  var searchTextFieldText: String = ""
  
  enum Action {
    case searchTextFieldText
    case addFriendButtonDidTap
  }
  
  func send(action: Action) {
    
  }
  
  
}

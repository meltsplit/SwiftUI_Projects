//
//  SearchViewModel.swift
//  Line
//
//  Created by 장석우 on 8/6/24.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
  
  enum Action {
    case requestQuery(String)
    case clear
    case clearSearchText
  }
  
  private let userID: String
  private let container: DIContainer
  
  @Published var searchText: String = ""
  @Published var searchResults: [User] = []
  @Published var shoudBecomeFirstResponder: Bool = false
  
  
  private var subscription = Set<AnyCancellable>()
  
  init(container: DIContainer, userID: String) {
    self.container = container
    self.userID = userID
    
    bind()
  }
  
  func bind() {
    
    $searchText
      .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
      .removeDuplicates()
      .sink { text in
        if text.isEmpty {
          self.send(action: .clear)
        } else {
          self.send(action: .requestQuery(text))
        }
      }
      .store(in: &subscription)
  }
  
  func send(action: Action) {
    switch action {
    case .requestQuery(let query) :
      container.service.userService.filterUsers(with: query, userID: userID)
        .sink { completion in
          
        } receiveValue: { [weak self] users in
          self?.searchResults = users
        }
        .store(in: &subscription)
    case .clear:
      searchResults = []
    case .clearSearchText:
      searchText = ""
      shoudBecomeFirstResponder = false
      searchResults = []
    }
  
  }
  
}

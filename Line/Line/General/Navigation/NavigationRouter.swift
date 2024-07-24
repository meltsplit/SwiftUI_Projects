//
//  NavigationRouter.swift
//  Line
//
//  Created by 장석우 on 7/24/24.
//

import Foundation

class NavigationRouter: ObservableObject {
  @Published var destinations: [NavigationDestination] = []
  
  func push(to view: NavigationDestination) {
    destinations.append(view)
  }
  
  func pop() {
    _ = destinations.popLast()
  }
  
  func popToRootView() {
    destinations = []
  }
}

//
//  OtherProfileViewModel.swift
//  Line
//
//  Created by 장석우 on 7/24/24.
//

import Foundation
import SwiftUI
import PhotosUI

@MainActor
class OtherProfileViewModel: ObservableObject {
  
  private var container: DIContainer
  
  @Published var user: User?
  private var userID: String
  
  init(container: DIContainer, userID: String) {
    self.container = container
    self.userID = userID
  }
  
  
  func getUser() async {
    if let user = try? await container.service.userService.getUser(userID: userID) {
      self.user = user
    }
  }

}

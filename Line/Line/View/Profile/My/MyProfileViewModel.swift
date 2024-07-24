//
//  MyProfileViewModel.swift
//  Line
//
//  Created by 장석우 on 7/22/24.
//

import Foundation
import SwiftUI
import PhotosUI

@MainActor
class MyProfileViewModel: ObservableObject {
  
  private var container: DIContainer
  
  @Published var user: User?
  @Published var imageSelection: PhotosPickerItem? {
    didSet {
      Task {
        await updateProfileImage(imageSelection)
      }
    }
  }
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
  
  func updateDescription(_ description: String) async {
    do {
      try await container.service.userService.updateDescription(userID: userID, description: description)
      self.user?.description = description
    } catch {
      
    }
  }
  
  func updateProfileImage(_ imageSelection: PhotosPickerItem?) async {
    guard let imageSelection else { return }
    do {
      let data = try await container.service.photoService.loadTransferable(from: imageSelection)
      let url = try await container.service.uploadService.uploadImage(source: .profile(userID: userID), data: data)
      try await container.service.userService.updateProfile(userID: userID, urlString: url.absoluteString)
      user?.profileURL = url.absoluteString
    } catch {
      print(error.localizedDescription)
    }
    
  }
}

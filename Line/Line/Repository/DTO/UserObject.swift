//
//  UserObject.swift
//  Line
//
//  Created by 장석우 on 7/19/24.
//

import Foundation

struct UserObject: Codable {
  var id: String
  var name: String
  var phoneNumber: String?
  var profileURL: String?
  var description: String?
  var fcmToken: String?
}

extension UserObject {
  func toModel() -> User {
    .init(
      id: id,
      name: name,
      phoneNumber: phoneNumber,
      profileURL: profileURL,
      description: description,
      fcmToken: fcmToken
    )
  }
}

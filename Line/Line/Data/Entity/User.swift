//
//  User.swift
//  Line
//
//  Created by 장석우 on 7/18/24.
//

import Foundation

struct User {
  var id: String
  var name: String
  var phoneNumber: String?
  var profileURL: String?
  var description: String?
  var fcmToken: String?
}

extension User {
  func toObject() -> UserObject {
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

extension User {
  static var stub1: User {
    .init(id: "uid_1", name: "장석우")
  }
  
  static var stub2: User {
    .init(id: "uid_2", name: "이유진")
  }
  
}

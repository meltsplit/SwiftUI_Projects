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
}

extension User {
  static var stub1: User {
    .init(id: "uid_1", name: "장석우")
  }
  
  static var stub2: User {
    .init(id: "uid_1", name: "이유진")
  }
}

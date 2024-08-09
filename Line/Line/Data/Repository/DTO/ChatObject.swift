//
//  ChatObject.swift
//  Line
//
//  Created by 장석우 on 7/28/24.
//

import Foundation

struct ChatObject: Codable {
    var chatID: String
    var userID: String
    var message: String?
    var photoURL: String?
    var date: TimeInterval
}

extension ChatObject {
    func toModel() -> Chat {
        .init(chatID: chatID,
              userID: userID,
              message: message,
              photoURL: photoURL,
              date: Date(timeIntervalSince1970: date))
    }
}

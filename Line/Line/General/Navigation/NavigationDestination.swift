//
//  NavigationDestination.swift
//  Line
//
//  Created by 장석우 on 7/24/24.
//

import Foundation

enum NavigationDestination: Hashable {
  case chat(chatRoomID: String, myUserID: String, otherUserID: String)
  case search
}

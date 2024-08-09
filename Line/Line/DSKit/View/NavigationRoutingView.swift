//
//  NavigationRoutingView.swift
//  Line
//
//  Created by 장석우 on 7/25/24.
//

import SwiftUI

struct NavigationRoutingView: View {
  
  @EnvironmentObject var container: DIContainer
  @State var destination: NavigationDestination
  
    var body: some View {
      switch destination {
      case let .chat(chatRoomID, myUserID, otherUserID):
        ChatView(viewModel: .init(chatRoomID: chatRoomID, myUserID: myUserID, otherUserID: otherUserID, container: container))
      case let .search(userID):
          SearchView(viewModel: .init(container: container, userID: userID))
      }
    }
}

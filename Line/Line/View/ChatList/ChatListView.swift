//
//  ChatView.swift
//  Line
//
//  Created by 장석우 on 7/19/24.
//

import SwiftUI

struct ChatListView: View {
  
  @EnvironmentObject var navigationRouter: NavigationRouter
  @StateObject var viewModel: ChatListViewModel
  
    var body: some View {
      NavigationStack(path: $navigationRouter.destinations) {
        ScrollView {
          NavigationLink(value: NavigationDestination.search(userID: viewModel.userID)) {
            SearchButton()
              .padding(.horizontal, 30)
          }
          .padding(.top, 16)
          .padding(.bottom, 14)
          
          ForEach(viewModel.chatRooms, id: \.self) { chatRoom in
            ChatRoomCell(chatRoom: chatRoom, userID: viewModel.userID)
          }
          
        }
        .navigationTitle("대화")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: NavigationDestination.self) {
          NavigationRoutingView(destination: $0)
        }
        .onAppear(perform: {
          viewModel.send(action: .load)
        })
      }
    }
}

fileprivate struct ChatRoomCell: View {
  
  let chatRoom: ChatRoom
  let userID: String
  
  var body: some View {
    NavigationLink(value: NavigationDestination.chat(chatRoomID: chatRoom.chatRoomID, 
                                                     myUserID: userID,
                                                     otherUserID: chatRoom.otherUserID)
    ) {
      HStack(spacing: 8) {
        Image(systemName: "person")
          .resizable()
          .frame(width: 40, height: 40)
        
        VStack(alignment: .leading, content: {
          Text(chatRoom.otherUserName)
            .font(.system(size: 14, weight: .bold))
            .foregroundStyle(.black)
          
          if let lastMessage = chatRoom.lastMessage {
            Text(lastMessage)
              .font(.system(size: 12))
              .foregroundStyle(.gray)
          }
          
        })
        
        Spacer()
      }
      .padding(.horizontal, 30)
      .padding(.bottom, 16)
    }

  }
}

#Preview {
  ChatListView(viewModel: .init(container: DIContainer(service: StubService()), userID: ""))
    .environmentObject(NavigationRouter())
}

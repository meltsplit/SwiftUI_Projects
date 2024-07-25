//
//  ChatView.swift
//  Line
//
//  Created by 장석우 on 7/25/24.
//

import SwiftUI

struct ChatView: View {
  
  @EnvironmentObject var navigationRouter: NavigationRouter
  @StateObject var viewModel: ChatViewModel
  @FocusState private var isFocused: Bool
  
  var body: some View {
    ScrollView {
      if viewModel.chatDateList.isEmpty {
        Color.blue.opacity(0.2)
      } else {
        contentView
      }
      
    }
    .background(Color.blue.opacity(0.2))
    .navigationBarBackButtonHidden()
    .toolbarBackground(Color.blue.opacity(0.2), for: .navigationBar)
    .toolbar(.hidden, for: .tabBar)
    .toolbar {
      ToolbarItemGroup(placement: .topBarLeading) {
        Button {
          navigationRouter.pop()
        } label: {
          Image(systemName: "chevron.left")
            .foregroundStyle(.black)
        }
        
        Text(viewModel.otherUser?.name ?? "대화방 이름")
          .font(.system(size: 20, weight: .bold))
          .foregroundStyle(.black)
      }
      
      ToolbarItemGroup(placement: .topBarTrailing) {
        Image(systemName: "magnifyingglass")
        Image(systemName: "bookmark")
        Image(systemName: "gearshape")
      }
    }
    .keyboardToolbar(height: 40) {
      HStack(spacing: 13) {
        
        Button {
          
        } label: {
          Image(systemName: "plus")
        }
        
        Button {
          
        } label: {
          Image(systemName: "photo")
        }
        
        Button {
          
        } label: {
          Image(systemName: "camera")
        }
        
        TextField("", text: $viewModel.message)
          .font(.system(size: 16))
          .foregroundStyle(.black)
          .focused($isFocused)
          .padding(.horizontal, 14)
          .padding(.vertical, 6)
          .background(.gray.opacity(0.3))
          .clipShape(RoundedRectangle(cornerRadius: 8))
        
        
        Button {
          
        } label: {
          Image(systemName: "paperplane")
        }
      }
      .foregroundStyle(.black)
      .padding(.horizontal, 20)
    }
    
    
    
  }
  
  var contentView: some View {
    ForEach(viewModel.chatDateList) { chatDate in
      Section {
        ForEach(chatDate.chats) { chat in
          ChatItemView(message: chat.message ?? "", direction: viewModel.getDirection(id: chat.userID), date: chat.date)
          
        }
      } header: {
        headerView(dateStr: chatDate.dateStr)
      }
      
    }
  }
  
  func headerView(dateStr: String) -> some View {
      Text(dateStr)
        .font(.system(size: 10))
        .padding(.vertical, 3)
        .padding(.horizontal, 10)
        .foregroundStyle(.white)
        .background(.black.opacity(0.2))
        .clipShape(.capsule)
        .padding(.top)
  }
}



#Preview {
  NavigationStack {
    ChatView(viewModel: .init(chatRoomID: "cr_1", myUserID: "user_1", otherUserID: "user_2", container: DIContainer(service: StubService())))
      .environmentObject(NavigationRouter())
  }
  
}

//
//  ChatView.swift
//  Line
//
//  Created by 장석우 on 7/25/24.
//

import SwiftUI
import PhotosUI

struct ChatView: View {
  
  @EnvironmentObject var container: DIContainer
  @StateObject var viewModel: ChatViewModel
  @FocusState private var isFocused: Bool
  
  var body: some View {
    
    ScrollViewReader { proxy in
      ScrollView {
        if viewModel.chatDateList.isEmpty {
          Color.blue.opacity(0.2)
        } else {
          contentView
        }
      }
      .onChange(of: viewModel.chatDateList.last?.chats) { newValue in
        proxy.scrollTo(newValue?.last?.id, anchor: .bottom)
      }
    }
    .background(Color.blue.opacity(0.2))
    .navigationBarBackButtonHidden()
    .toolbarBackground(Color.blue.opacity(0.2), for: .navigationBar)
    .toolbar(.hidden, for: .tabBar)
    .toolbar {
      ToolbarItemGroup(placement: .topBarLeading) {
        Button {
          container.navigationRouter.pop()
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
        
        
        PhotosPicker(
          selection: $viewModel.imageSelection,
          matching: .images
        ) {
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
          viewModel.send(action: .addChat(viewModel.message))
          isFocused = false
        } label: {
          Image(systemName: "paperplane")
        }
        .disabled(viewModel.message.isEmpty)
        
      }
      .foregroundStyle(.black)
      .padding(.horizontal, 20)
    }
    .onAppear {
      viewModel.send(action: .load)
    }
    
  }
  
  var contentView: some View {
    ForEach(viewModel.chatDateList) { chatDate in
      Section {
        ForEach(chatDate.chats) { chat in
          
          if let message = chat.message {
            ChatItemView(
              message: message,
              direction: viewModel.getDirection(id: chat.userID), 
              date: chat.date)
            .id(chat.id)
          } else if let photoURL = chat.photoURL {
            ChatImageItemView(urlString: photoURL,
                              direction: viewModel.getDirection(id: chat.userID))
            .id(chat.id)
          }
          
        }
      } header: {
        headerView(dateStr: chatDate.dateStr)
      }
      
    }
    .padding(.bottom, 10)
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
  }
  
}

//
//  OtherProfileView.swift
//  Line
//
//  Created by 장석우 on 7/20/24.
//

import SwiftUI
import PhotosUI

struct OtherProfileView: View {
  
  @Environment(\.dismiss) var dismiss
  @StateObject var viewModel: OtherProfileViewModel
  
  var goToChat: (User) -> Void
  
  var body: some View {
    
    NavigationStack {
      ZStack {
        Image(.we)
          .resizable()
          .scaledToFill()
          .ignoresSafeArea()
        
        
        VStack {
          Spacer()
          
          profileView
          
          Spacer()
          
          menuView
            .padding(.bottom, 20)
          
        }
      }
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button {
            dismiss()
          } label: {
            Image(systemName: "xmark")
              .resizable()
              .scaledToFit()
              .frame(width: 18, height: 18)
              .foregroundStyle(.white)
          }
        }
      }
      .task {
        await viewModel.getUser()
      }
    }
  }
  
  var profileView: some View {
    VStack {
      URLImageView(urlString: viewModel.user?.profileURL)
        .frame(width: 80, height: 80)
        .clipShape(Circle())
      
      Text(viewModel.user?.name ?? "")
        .font(.system(size: 26, weight: .bold))
        .foregroundStyle(.white)
      
      Spacer()
        .frame(height: 20)
      
      Text(viewModel.user?.description ?? "상태메시지를 입력해주세요")
        .font(.system(size: 18))
        .foregroundStyle(.white)
      
    }
  }
  
  var menuView: some View {
    HStack(spacing: 30) {
      ForEach(OtherProfileMenuType.allCases, id: \.self) { menu in
        Button {
          if menu == .chat, let user = viewModel.user {
            dismiss()
            goToChat(user)
          }
        } label: {
          VStack {
            Image(systemName: menu.imageName)
              .resizable()
              .scaledToFit()
              .frame(width: 30, height: 30)
            Text(menu.description)
          }
          .foregroundStyle(.white)
        }
      }
      
    }
  }
}

#Preview {
  OtherProfileView(
    viewModel: OtherProfileViewModel(
      container: DIContainer(
        service: StubService()
      ),
      userID: "uid_1"), goToChat: { _ in }
  )
}

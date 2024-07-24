//
//  MyProfileView.swift
//  Line
//
//  Created by 장석우 on 7/20/24.
//

import SwiftUI
import PhotosUI

struct MyProfileView: View {
  
  @StateObject var viewModel: MyProfileViewModel
  @Environment(\.dismiss) var dismiss
  
  @State var isPresentedDescriptionView: Bool = false
  
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
        print("🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏")
        await viewModel.getUser()
      }
      .sheet(isPresented: $isPresentedDescriptionView) {
        MyProfileDescriptionView(description: viewModel.user?.description ?? "") { description in
          Task {
            await viewModel.updateDescription(description)
          }
          
        }
      }
    }
  }
  
  var profileView: some View {
    VStack {
      PhotosPicker(
        selection: $viewModel.imageSelection,
        matching: .images
      ) {
        
        URLImageView(urlString: viewModel.user?.profileURL)
          .frame(width: 80, height: 80)
          .clipShape(Circle())
        
      }
      
      
      
      Text(viewModel.user?.name ?? "")
        .font(.system(size: 26, weight: .bold))
        .foregroundStyle(.white)
      
      Spacer()
        .frame(height: 20)
      
      Button {
        isPresentedDescriptionView = true
      } label: {
        Text(viewModel.user?.description ?? "상태메시지를 입력해주세요")
          .font(.system(size: 18))
          .foregroundStyle(.white)
      }
      
    }
  }
  
  var menuView: some View {
    HStack(spacing: 30) {
      ForEach(MyProfileMenuType.allCases, id: \.self) { menu in
        Button {
          
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
  MyProfileView(
    viewModel: MyProfileViewModel(
      container: DIContainer(
        service: StubService()
      ),
      userID: "uid_1")
  )
}

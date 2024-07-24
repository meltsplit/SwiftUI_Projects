//
//  HomeView.swift
//  Line
//
//  Created by 장석우 on 7/19/24.
//

import SwiftUI

struct HomeView: View {
    
  @EnvironmentObject var container: DIContainer
  @EnvironmentObject var navigationRouter: NavigationRouter
  @StateObject var viewModel : HomeViewModel
  @State var searchTextFieldText: String = ""
  
  var body: some View {
    NavigationStack(path: $navigationRouter.destinations) {
      contentView
        .fullScreenCover(item: $viewModel.modalDestination) {
          switch $0 {
          case .myProfile:
              MyProfileView(viewModel: MyProfileViewModel(container: container, userID: viewModel.userID))
          case let .otherProfile(userID):
            OtherProfileView(viewModel: .init(container: container, userID: userID)) {
              otherUser in
              viewModel.send(action: .goToChat(otherUser))
            }
          }
        }
        .navigationDestination(for: NavigationDestination.self) {
          switch $0 {
          case .chat:
            ChatView()
          case .search:
            SearchView()
          }
        }
    }
  }
  
  @ViewBuilder
  var contentView: some View {
    switch viewModel.phase {
    case .notRequested: PlaceholderView()
        .onAppear {
          viewModel.send(action: .load)
        }
    case .loading: LoadingView()
    case .success: mainView
        .toolbar {
          Image(systemName: "bookmark")
          Image(systemName: "bell")
          Image(systemName: "person.badge.plus")
          Button {
            
          } label: {
            Image(systemName: "gearshape")
          }
          .foregroundStyle(.black)
          
        }
    case .fail: ErrorView()
    }
  }
  
  var mainView: some View {
    ScrollView {
      
      Group {
        profileView
          .padding(.bottom, 10)
        searchView
          
        
        HStack {
          Text("친구")
            .font(.system(size: 14, weight: .bold))
            .foregroundStyle(.black)
          Spacer()
        }
        .padding(.top, 20)
        
        if viewModel.friends.isEmpty {
          Spacer(minLength: 89)
          emptyView
        } else {
          Spacer(minLength: 20)
          friendsView
        }
        
      }
      .padding(.horizontal, 35)
      
    }
  }
  
  var profileView: some View {
    HStack {
      VStack(alignment: .leading, spacing: 8) {
        Text(viewModel.myUser?.name ?? "이름")
          .font(.system(size: 26, weight: .bold))
          .foregroundStyle(.black)
        
        Text(viewModel.myUser?.description ?? "상태메세지 입력")
          .font(.system(size: 14))
          .foregroundStyle(.gray)
      }
      
      Spacer()
      
      Image(systemName: "person")
        .resizable()
        .scaledToFit()
        .foregroundStyle(.white)
        .frame(width: 42, height: 42)
        .background(.blue.opacity(0.4))
        .clipShape(Circle())
    }
    .padding(.top, 24)
    .onTapGesture {
      viewModel.send(action: .presentMyProfileView)
    }
  }
  
  var searchView: some View {
    NavigationLink(value: NavigationDestination.search) {
      ZStack {
        RoundedRectangle(cornerRadius: 4)
          .fill(Color.gray.opacity(0.4))
          .frame(height: 36)
        HStack {
          Text("검색")
            .foregroundStyle(.black)
            .padding(.horizontal, 15)
          
          Spacer()
        }
      }
    }
  }
  
  var friendsView: some View {
    LazyVStack {
      ForEach(viewModel.friends, id: \.id) { user in
        Button {
          viewModel.send(action: .presentOtherProfileView(user.id))
        } label: {
          HStack(spacing: 8) {
            Image(systemName: "person")
              .resizable()
              .frame(width: 40, height: 40)
              .background(.blue.opacity(0.5))
              .clipShape(Circle())
            
            Text(user.name)
              .font(.system(size: 12))
              .foregroundStyle(.black)
            Spacer()
          }
          .padding(.vertical, 5)
        }
        
      }
      
    }
    
  }
  
  var emptyView: some View {
    VStack(spacing: 3) {
      Text("친구를 추가해보세요.")
        .font(.system(size: 17,weight: .bold))
      
      Text("QR코드나 검색을 이용하여 친구를 추가해보세요.")
        .font(.system(size: 13))
        .foregroundStyle(.gray)
        .padding()
        .padding(.bottom, 30)
      
      Button {
        viewModel.send(action: .requestContacts)
      } label: {
        Text("친구추가")
          .font(.system(size: 17, weight: .bold))
          .foregroundStyle(.black)
          .padding(.vertical, 9)
          .padding(.horizontal, 24)
          .overlay {
            RoundedRectangle(cornerRadius: 5)
              .stroke(.gray.opacity(0.5), lineWidth: 0.8)
          }
      }
      
    }
  }
}

#Preview {
  
  HomeView(viewModel: .init(container: .init(service: StubService()), navigationRouter: .init(), userID: ""))
        .environmentObject(DIContainer(service: StubService()))
        .environmentObject(NavigationRouter())
}

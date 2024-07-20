//
//  HomeView.swift
//  Line
//
//  Created by 장석우 on 7/19/24.
//

import SwiftUI

struct HomeView: View {
  
  @StateObject var viewModel : HomeViewModel
  @State var searchTextFieldText: String = ""
  
  var body: some View {
    NavigationStack {
      ScrollView {
        
        Group {
          profileView
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
            friendView
          }
          
        }
        .padding(.horizontal, 35)
        
      }
      
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
      .onAppear {
        viewModel.send(action: .getUser)
      }
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
  }
  
  var searchView: some View {
    TextField("검색",
              text: $searchTextFieldText)
    .frame(height: 36)
    .foregroundStyle(.black)
    .background(.gray.opacity(0.3))
    .padding(.top, 30)
  }
  
  var friendView: some View {
    ForEach(viewModel.friends, id: \.id) { user in
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
//        viewModel.send(action: .addFriendButtonDidTap)
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
  HomeView(viewModel: .init(container: .init(service: StubService()), userID: ""))
}

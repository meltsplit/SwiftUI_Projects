//
//  SearchView.swift
//  Line
//
//  Created by 장석우 on 7/24/24.
//

import SwiftUI

struct SearchView: View {
  
  @EnvironmentObject var navigationRouter: NavigationRouter
  @StateObject var viewModel: SearchViewModel
  
  var body: some View {
    VStack {
      topView
      friendsView
      Spacer()
    
    }
    .toolbar(.hidden, for: .navigationBar)
    .toolbar(.hidden, for: .tabBar)
    
  }
  
  
  var topView: some View {
    HStack(spacing: 0) {
      Button {
        navigationRouter.pop()
      } label : {
        Image(systemName: "chevron.left")
      }
      
      SearchBar(text: $viewModel.searchText, shouldBecomeFirstResponder: $viewModel.shoudBecomeFirstResponder)
      
      Button {
        viewModel.send(action: .clearSearchText)
      } label: {
        Image(systemName: "xmark")
      }
    }
    .tint(.black)
    .padding(.horizontal, 20)
  }
  
  var friendsView: some View {
    VStack {
      HStack {
        Text("친구")
          .font(.system(size: 16, weight: .semibold))
        Spacer()
      }
      .padding(.bottom, 20)
      .padding(.horizontal, 20)
      
      List {
        ForEach(viewModel.searchResults, id: \.id) { user in
          HStack(spacing: 8) {
            URLImageView(urlString: user.profileURL)
              .frame(width: 40, height: 40)
              .clipShape(Circle())
            
            Text(user.name)
              .font(.system(size: 12))
              .foregroundStyle(.black)
            Spacer()
          }
          .padding(.vertical, 5) 
          .listRowInsets(.none)
          .listRowSeparator(.hidden)
        }
      }
      .listStyle(.plain)
      
    }
  }
}

#Preview {
  
  SearchView(viewModel: SearchViewModel(container: DIContainer(service: StubService()), userID: ""))
    .environmentObject(NavigationRouter())
  
  
}

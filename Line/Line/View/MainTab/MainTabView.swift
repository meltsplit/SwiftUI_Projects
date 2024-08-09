//
//  MainTabView.swift
//  Line
//
//  Created by 장석우 on 7/16/24.
//

import SwiftUI

struct MainTabView: View {
  @EnvironmentObject private var authViewModel: AuthenticatedViewModel
  @EnvironmentObject private var container: DIContainer
  @State private var selectedTab: MainTabType = .home
  
    var body: some View {
      TabView(selection: $selectedTab) {
        ForEach(MainTabType.allCases, id: \.self) { tab in
          Group {
            switch tab {
            case .home:
              HomeView(viewModel: .init(container: container, userID: authViewModel.userId ?? ""))
            case .chat:
              ChatListView(
                viewModel: .init(container: container, userID: authViewModel.userId ?? "")
              )
            case .phone:
              PhoneView()
            }
            
          }
          .tabItem { Label(tab.title, systemImage: tab.imageName(isSelected: selectedTab == tab)) }
          .tag(tab)
        }
      }
      .tint(.black)
      
    }
    
}

#Preview {
    MainTabView()
    .environmentObject(DIContainer(service: StubService()))
    .environmentObject(AuthenticatedViewModel(container: DIContainer(service: StubService())))
}

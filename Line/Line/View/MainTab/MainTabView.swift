//
//  MainTabView.swift
//  Line
//
//  Created by 장석우 on 7/16/24.
//

import SwiftUI

struct MainTabView: View {
  
  @State private var selectedTab: MainTabType = .home
  
    var body: some View {
      TabView(selection: $selectedTab) {
        ForEach(MainTabType.allCases, id: \.self) { tab in
          Group {
            switch tab {
            case .home:
              HomeView(viewModel: .init())
            case .chat:
              ChatView()
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
}

//
//  ContentView.swift
//  Line
//
//  Created by 장석우 on 7/12/24.
//

import SwiftUI
import Combine

struct AuthenticatedView: View {
  
  @StateObject var authViewModel: AuthenticatedViewModel
  @StateObject var navigationRouter: NavigationRouter
  @StateObject var searchDataController: SearchDataController
  
    var body: some View {
      VStack {
        switch authViewModel.authenticated {
        case .unauthenticated:
          LoginIntroView()
            .environmentObject(authViewModel)
        case .authenticated:
          MainTabView()
            .environment(\.managedObjectContext, searchDataController.persistantContainer.viewContext)
            .environmentObject(authViewModel)
            .environmentObject(navigationRouter)
            .onAppear {
              authViewModel.send(action: .requestPushNotification)
            }
          
        }
      }
      .onAppear {
        authViewModel.send(action: .checkAuthorizationState)
        
      }
      
    }
}

#Preview {
  AuthenticatedView(authViewModel: .init(container: .init(service: StubService())), navigationRouter: .init(), searchDataController: .init())
}

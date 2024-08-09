//
//  ContentView.swift
//  Line
//
//  Created by 장석우 on 7/12/24.
//

import SwiftUI
import Combine

struct AuthenticatedView: View {
  
  @EnvironmentObject var container: DIContainer
  @StateObject var authViewModel: AuthenticatedViewModel
  
    var body: some View {
      VStack {
        switch authViewModel.authenticated {
        case .unauthenticated:
          LoginIntroView()
            .environmentObject(authViewModel)
          
        case .authenticated:
          MainTabView()
            .environment(\.managedObjectContext, container.searchDataController.persistantContainer.viewContext)
            .environmentObject(authViewModel)
            .onAppear {
              authViewModel.send(action: .requestPushNotification)
            }
          
        }
      }
      .onAppear {
        authViewModel.send(action: .checkAuthorizationState)
        
      }
      .preferredColorScheme(container.appearanceController.appearance.colorSchems)
      
    }
}

#Preview {
  AuthenticatedView(authViewModel: .init(container: .init(service: StubService())))
}

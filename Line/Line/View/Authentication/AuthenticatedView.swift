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
  
    var body: some View {
      VStack {
        switch authViewModel.authenticated {
        case .unauthenticated:
          LoginIntroView()
            .environmentObject(authViewModel)
        case .authenticated:
          MainTabView()
            .environmentObject(authViewModel)
        }
      }
      .onAppear {
        authViewModel.send(action: .checkAuthorizationState)
//        authViewModel.send(action: .logout)
        
      }
      
    }
}

#Preview {
  AuthenticatedView(authViewModel: .init(container: .init(service: StubService())))
}

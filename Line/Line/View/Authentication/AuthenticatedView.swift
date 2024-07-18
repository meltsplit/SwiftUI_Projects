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
      switch authViewModel.authenticated {
      case .unauthenticated:
        LoginIntroView()
      case .authenticated:
        MainTabView()
      }
    }
}

#Preview {
  AuthenticatedView(authViewModel: .init(container: .init(service: StubService())))
}

//
//  AuthenticatedViewModel.swift
//  Line
//
//  Created by 장석우 on 7/16/24.
//

import Foundation
import Combine
import AuthenticationServices

enum AuthenticationState {
  case unauthenticated
  case authenticated
}

class AuthenticatedViewModel: ObservableObject {
  
  enum Action {
    case checkAuthorizationState
    case googleLogin
    case appleLogin(ASAuthorizationAppleIDRequest)
    case appleLoginCompletion(Result<ASAuthorization, Error>)
    case logout
  }
  
  @Published var authenticated: AuthenticationState = .unauthenticated
  @Published var isLoading: Bool = false
  
  var userId: String?
  private var currentNonce: String?
  private var container: DIContainer
  private var subscriptions = Set<AnyCancellable>()
  
  
  init(container: DIContainer) {
    self.container = container
  }
  
  func send(action: Action) {
    switch action {
    case .checkAuthorizationState:
      if let userID = container.service.authService.checkAuthenticationState() {
        self.userId = userID
        self.authenticated = .authenticated
      }
      
      
    case .googleLogin:
      isLoading = true
      container.service.authService.signInWithGoogle()
        .sink { [weak self] completion in
          if case .failure = completion {
            self?.isLoading = false
          }
          //TODO: 실패
          
        } receiveValue: { [weak self] user in
          self?.userId = user.id
          self?.isLoading = false
          self?.authenticated = .authenticated
        }
        .store(in: &subscriptions)
      // Sink 시 Subscription이 return 됨,
      // Subscription뷰모델에서 관리할 것임
      // 뷰모델에선 구독이 하나만 이뤄지는게 아니기에 set으로 관리
      
    case let .appleLogin(request):
      let nonce = container.service.authService.handleSignInWithAppleRequest(request)
      self.currentNonce = nonce
      
    case let .appleLoginCompletion(result):
      isLoading = true
      if case let .success(authorization) = result {
        guard let nonce = currentNonce else { return }
        
        container.service.authService.handleSignInWithAppleCompletion(authorization, nonce: nonce)
          .sink { [weak self] completion in
            if case .failure = completion {
              self?.isLoading = false
            }
          } receiveValue: { [weak self] user in
            self?.isLoading = false
            self?.userId = user.id
            self?.authenticated = .authenticated
          }
          .store(in: &subscriptions)
      } else if case let .failure(error) = result {
        self.isLoading = false
        print(error.localizedDescription)
      }
      return
    case .logout:
      container.service.authService.logout()
        .sink { completion in
          
        } receiveValue: { [weak self] _ in
          self?.authenticated = .unauthenticated
          self?.userId = nil
        }
        .store(in: &subscriptions)

    }
  }
  
  
}

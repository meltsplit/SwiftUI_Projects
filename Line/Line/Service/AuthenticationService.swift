//
//  AuthenticationService.swift
//  Line
//
//  Created by 장석우 on 7/16/24.
//

import Foundation
import Combine
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices

enum AuthenticationError: Error {
  case clientIDNotFound
  case tokenFail
  case invalidated
}

protocol AuthenticationServiceType {
  func checkAuthenticationState() -> String?
  func signInWithGoogle() -> AnyPublisher<User, ServiceError>
  func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) -> String
  func handleSignInWithAppleCompletion(_ authorization: ASAuthorization, nonce: String) -> AnyPublisher<User, ServiceError>
  func logout() -> AnyPublisher<Void, ServiceError>

}

class AuthenticationService: AuthenticationServiceType {
  
  func checkAuthenticationState() -> String? {
    if let user = Auth.auth().currentUser {
      return user.uid
    } else {
      return nil
    }
  }
  
  
  func signInWithGoogle() -> AnyPublisher<User, ServiceError> {
    Future { [weak self] promise in
      self?.signInWithGoogle{ result in
        switch result {
        case let .success(user):
          promise(.success(user))
        case let .failure(error):
          promise(.failure(.error(error)))
        }
      }
    }.eraseToAnyPublisher()
  }
  
  func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) -> String {
    request.requestedScopes = [.fullName, .email]
    let nonce = randomNonceString()
    request.nonce = sha256(nonce)
    return nonce
  }
  
  func handleSignInWithAppleCompletion(
    _ authorization: ASAuthorization,
    nonce: String
  ) -> AnyPublisher<User, ServiceError> {
    Future { [weak self] promise in
      self?.handleSignInWithAppleCompletion(authorization, nonce: nonce){ result in
        switch result {
        case let .success(user):
          promise(.success(user))
        case let .failure(error):
          promise(.failure(.error(error)))
        }
      }
    }.eraseToAnyPublisher()
  }
  
  func logout() -> AnyPublisher<Void, ServiceError>{
    Future { promise in
      do {
        try Auth.auth().signOut()
        promise(.success(()))
      } catch {
        promise(.failure(.error(error)))
      }
    }.eraseToAnyPublisher()
  }
  
}

//MARK: - Google

extension AuthenticationService {
  private func signInWithGoogle(completion: @escaping (Result<User, Error>) -> Void ) {
    guard let clientID = FirebaseApp.app()?.options.clientID else {
      completion(.failure(AuthenticationError.clientIDNotFound))
      return
    }
    
    let config = GIDConfiguration(clientID: clientID)
    GIDSignIn.sharedInstance.configuration = config
    
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let window = windowScene.windows.first,
          let rootViewController = window.rootViewController else {
      return
    }
    
    GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] result, error in
      if let error {
        completion(.failure(error))
        return
      }
      
      guard let user = result?.user,
            let idToken = user.idToken?.tokenString else {
        completion(.failure(AuthenticationError.tokenFail))
        return
      }
      
      let accessToken = user.accessToken.tokenString
      let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
      self?.authenticatiedUserWithFirebase(credential: credential, completion: completion)
    }
    
  }
  
}

//MARK: - Apple

extension AuthenticationService {
  
  private func handleSignInWithAppleCompletion(_ authorization: ASAuthorization,
                               nonce: String,
                               completion: @escaping (Result<User, Error>) -> Void ) {
    guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
          let appleIDToken = appleIDCredential.identityToken else {
      completion(.failure(AuthenticationError.tokenFail))
      return
    }
    
    guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
      completion(.failure(AuthenticationError.tokenFail))
      return 
    }
    
    let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                              idToken: idTokenString,
                                              rawNonce: nonce)
    
    authenticatiedUserWithFirebase(credential: credential) { result in
      switch result {
        
      case var .success(user):
        user.name = [appleIDCredential.fullName?.givenName,appleIDCredential.fullName?.familyName]
          .compactMap{ $0 }
          .joined()
        completion(.success(user))
      case let .failure(error):
        completion(.failure(error))
      }
      
    }
    
  }
  
}

//MARK: - Firebase
extension AuthenticationService {
  private func authenticatiedUserWithFirebase(credential: AuthCredential, completion: @escaping (Result<User, Error>) -> Void) {
    Auth.auth().signIn(with: credential) { result , error in
      if let error {
        completion(.failure(error))
        return
      }
      
      guard let result else {
        completion(.failure(AuthenticationError.invalidated))
        return
      }
      
      let firebaseUser = result.user
      let user = User(id: firebaseUser.uid,
                      name: firebaseUser.displayName ?? "",
                      phoneNumber: firebaseUser.phoneNumber ?? "",
                      profileURL: firebaseUser.photoURL?.absoluteString)
      
      completion(.success(user))
    }
  }
  
}

class StubAuthenticationService: AuthenticationServiceType {
  
  func checkAuthenticationState() -> String? {
      return nil
  }

  
  func signInWithGoogle() -> AnyPublisher<User, ServiceError> {
    Empty().eraseToAnyPublisher()
  }
  
  func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) -> String {
    ""
  }
  
  func handleSignInWithAppleCompletion(_ authorization: ASAuthorization, nonce: String) -> AnyPublisher<User, ServiceError> {
    Empty().eraseToAnyPublisher()
  }
  
  func logout() -> AnyPublisher<Void, ServiceError>{
    Empty().eraseToAnyPublisher()
  }
}

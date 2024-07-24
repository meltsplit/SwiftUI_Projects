//
//  LoginView.swift
//  Line
//
//  Created by 장석우 on 7/16/24.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
  
  @Environment(\.dismiss) var dismiss
  @EnvironmentObject var authViewModel: AuthenticatedViewModel
  
  var body: some View {
    VStack(alignment: .leading) {
      
      Group {
        Text("로그인")
          .font(.system(size: 28, weight: .bold))
          .padding(.top, 80)
      
        Text("아래 제공되는 서비스로 로그인을 해주세요.")
          .font(.system(size: 14))
          .foregroundStyle(.gray)
          .padding(.top, 10)
      }
      .padding(.horizontal, 30)
      
      Spacer()
      
      Button {
        if authViewModel.isLoading {
          print("로딩중에 눌림")
        } else {
          print("구글 눌림")
        }
        authViewModel.send(action: .googleLogin)
        
      } label: {
          Text("Google로 로그인")
            
      }
      .buttonStyle(LoginButtonStyle(textColor: .black, borderColor: .gray))
      
      SignInWithAppleButton { request in
        authViewModel.send(action: .appleLogin(request))
      } onCompletion: { result in
        authViewModel.send(action: .appleLoginCompletion(result))
      }
      .frame(height: 40)
      .padding(.horizontal, 15)
      .cornerRadius(5)
    }
    .navigationBarBackButtonHidden()
    .toolbar {
      ToolbarItemGroup(placement: .topBarLeading) {
        Button {
          dismiss()
        } label: {
          Image(systemName: "chevron.left")
            .foregroundStyle(.black)
        }
      }
    }
    .overlay {
      if authViewModel.isLoading {
        Color.black.opacity(0.4)
                  .edgesIgnoringSafeArea(.all)
        
        ProgressView()
      }
    }
    
  }
}

#Preview {
  LoginView()
    .environmentObject(AuthenticatedViewModel(container: DIContainer(service: StubService())))
}

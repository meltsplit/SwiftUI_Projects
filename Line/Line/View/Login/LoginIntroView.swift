//
//  LoginIntroView.swift
//  Line
//
//  Created by 장석우 on 7/16/24.
//

import SwiftUI

struct LoginIntroView: View {
  
  @State private var isPresentedLoginView: Bool = false
  
  var body: some View {
    NavigationStack {
      VStack(spacing: 20) {
        
        Spacer()
        
        Text("환영합니다.")
          .font(.system(size: 26,weight: .bold))
          .foregroundStyle(.black)
        
        Text("무료 메시지와 영상통화, 음성통화를 부담없이 즐겨보세요!")
          .font(.system(size: 12, weight: .bold))
          .foregroundStyle(.gray)
        
        Spacer()
        
        Button {
          isPresentedLoginView.toggle()
        } label: {
          Text("로그인")
        }
        .buttonStyle(LoginButtonStyle(textColor: .green, borderColor: .green))
      }
      .navigationDestination(isPresented: $isPresentedLoginView) {
        LoginView()
        
      }
    }
    
    
  }
}

#Preview {
  LoginIntroView()
}

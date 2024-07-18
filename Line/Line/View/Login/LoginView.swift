//
//  LoginView.swift
//  Line
//
//  Created by 장석우 on 7/16/24.
//

import SwiftUI

struct LoginView: View {
  
  
  @Environment(\.dismiss) var dismiss
  
  
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
        //TODO: 구글 로그인
      } label: {
          Text("Google로 로그인")
            
      }
      .buttonStyle(LoginButtonStyle(textColor: .black, borderColor: .gray))
      
      Button {
        //TODO: Apple 로그인
      } label: {
          Text("Apple로 로그인")
      }
      .buttonStyle(LoginButtonStyle(textColor: .black, borderColor: .gray))
      
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
    
  }
}

#Preview {
  LoginView()
}

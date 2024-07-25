//
//  ChatItemView.swift
//  Line
//
//  Created by 장석우 on 7/25/24.
//

import SwiftUI

struct ChatItemView: View {
  
  let message: String
  let direction: ChatItemDirection
  let date: Date
  
  var body: some View {
    HStack(alignment: .bottom) {
      
      if direction == .right {
        Spacer()
        dateView
      }
      
      
      
      Text(message)
        .font(.system(size: 14))
        .foregroundStyle(.black)
        .padding(.vertical, 9)
        .padding(.horizontal, 20)
        .background(direction.color)
        .clipShape(RoundedRectangle(cornerRadius: 50))
        .overlay(alignment: direction.alignment) {
          direction.image
            .renderingMode(.template)
            .foregroundStyle(direction.color)
            .tint(direction.color)
            
        }
      
      if direction == .left {
        dateView
        Spacer()
      }
    }
    .padding(.horizontal, 30)
    
  }
  
  var dateView: some View {
    Text(date.toChatTime)
      .font(.system(size: 10))
      .foregroundStyle(.gray)
  }
}

#Preview {
  ChatItemView(message: "a", direction: .left, date: Date())
    .background(Color.blue.opacity(0.2))
}

//
//  LoginButtonStyle.swift
//  Line
//
//  Created by 장석우 on 7/18/24.
//

import SwiftUI

struct LoginButtonStyle: ButtonStyle {
  
  var textColor: Color
  var borderColor: Color
  
  init(textColor: Color, borderColor: Color? = nil) {
    self.textColor = textColor
    self.borderColor = borderColor ?? textColor
  }
  
  
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.system(size: 14))
      .foregroundStyle(textColor)
      .frame(maxWidth: .infinity, maxHeight: 40)
      .overlay {
        RoundedRectangle(cornerRadius: 5)
          .stroke(borderColor, lineWidth: 0.8)
      }
      .padding(.horizontal, 15)
      .opacity(configuration.isPressed ? 0.5 : 1)
    
    
  }
  
  
}

//
//  ChatImageItemView.swift
//  Line
//
//  Created by 장석우 on 7/28/24.
//

import SwiftUI

struct ChatImageItemView: View {
  
  let urlString: String
  let direction: ChatItemDirection
  
  var body: some View {
    HStack(alignment: .bottom) {
      
      if direction == .right {
        Spacer()
      }
      
      URLImageView(urlString: urlString)
        .frame(width: 146, height: 146)
        .clipShape(RoundedRectangle(cornerRadius: 10))
      
      if direction == .left {
        Spacer()
      }
    }
    .padding(.horizontal, 30)
    
  }

}

#Preview {
  ChatImageItemView(urlString: "", direction: .left)
}

//
//  SearchButton.swift
//  Line
//
//  Created by 장석우 on 7/25/24.
//

import SwiftUI

struct SearchButton: View {
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 4)
        .fill(Color.gray.opacity(0.4))
        .frame(height: 36)
      HStack {
        Text("검색")
          .foregroundStyle(.black)
          .padding(.horizontal, 15)
        
        Spacer()
      }
    }
  }
}
  


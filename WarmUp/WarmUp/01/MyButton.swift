//
//  MyButton.swift
//  WarmUp
//
//  Created by 장석우 on 6/21/24.
//

import SwiftUI

struct MyButton: View {
    
    var title: String
    var color: Color
    
    var body: some View {
        Button {
            
        } label: {
            Text(title)
                .padding()
                .background(color)
                .foregroundStyle(.white)
                .font(.headline)
                .clipShape(.buttonBorder)
        }
    }
}

#Preview {
    MyButton(title: "", color: .blue)
}

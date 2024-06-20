//
//  SimpleView.swift
//  WarmUp
//
//  Created by 장석우 on 6/21/24.
//

import SwiftUI

struct SimpleView: View {
    var body: some View {
        Image(systemName: "pencil")
            .resizable()
            .scaledToFit()
            .frame(width: 200, height: 200)
        
        Text("헤드라인 입니다.")
            .font(.headline)
            .bold()
        
        Text("서브 헤드")
            .font(.subheadline)
            .padding()
        
        Text("바디 입니다")
            .font(.body)
            .padding()
        
        Button {
            
        } label: {
            Text("클릭")
                .padding()
                .frame(width: 150)
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.buttonBorder)
                .bold()
                
        }
        
        
        
        

        
        
    }
}

#Preview {
    SimpleView()
}

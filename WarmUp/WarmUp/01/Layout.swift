//
//  Layout.swift
//  WarmUp
//
//  Created by 장석우 on 6/21/24.
//

import SwiftUI

struct Layout: View {
    var body: some View {
        VStack {
            
            Image(systemName: "pencil")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .padding()
            
            Text("1")
                .font(.headline)
                .padding()
            
            Text("2")
                .font(.subheadline)
                .padding()
            
            Text("3")
                .font(.body)
                .padding()
            
            HStack {
                MyButton(
                    title: "Button 1",
                    color: .blue
                )
                
                MyButton(
                    title: "Button 2",
                    color: .green
                )

            }
            
            Button { 
                
            } label: {
                VStack {
                    Image(systemName: "arrow.right.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                    Text("complex")
                        
                }
                .foregroundStyle(.white)
                .padding()
                .frame(width: 150)
                .background(.orange)
                .clipShape(.buttonBorder)
                
                
            }
        }
    }
}

#Preview {
    Layout()
}

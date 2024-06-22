//
//  OnboardingView.swift
//  WarmUp
//
//  Created by 장석우 on 6/23/24.
//

import SwiftUI

struct OnboardingView: View {
    
    @State var title: String
    @Binding var showModal: Bool
    var isLast: Bool
    
    var body: some View {
        ZStack {
            VStack {
                Text(title)
                    .font(.title)
                    .bold()
                    .padding(.vertical, 60)
                
                Spacer()
                
                Button {
                    showModal = false
                } label: {
                    Text("시작하기")
                        .padding()
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .background(.blue)
                        .clipShape(.buttonBorder)
                }
                .padding()
                
                .opacity(isLast ? 1 : 0)
            }
            
            
        }
    }
}

#Preview {
    OnboardingView(title: "타이틀 테스트",
                   showModal: .constant(true),
                   isLast: true)
}

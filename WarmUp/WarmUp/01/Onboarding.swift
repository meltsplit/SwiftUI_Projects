//
//  Onboarding.swift
//  WarmUp
//
//  Created by 장석우 on 6/21/24.
//

import SwiftUI

struct Onboarding: View {
    var body: some View {
        VStack {
            Text("What's New in Photos")
                .font(.title)
                .bold()
                .padding(.vertical, 60)
            
            
            OnboardingCell(
                systemName: "person.2",
                title: "Shared Library",
                description: "dddasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdf"
            )
            .padding(.vertical, 5)
            
            OnboardingCell(
                systemName: "person.2",
                title: "Shared Library",
                description: "dddasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdf"
            )
            .padding(.vertical, 5)
            
            OnboardingCell(
                systemName: "square.on.square",
                title: "Shared Library",
                description: "dddasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdf"
            )
            .padding(.vertical, 5)
            
            Spacer()
            
            Button { 
                
            } label: {
                Text("Continue")
                    .foregroundStyle(.white)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .clipShape(.buttonBorder)
                    
            }
            
            
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    Onboarding()
}

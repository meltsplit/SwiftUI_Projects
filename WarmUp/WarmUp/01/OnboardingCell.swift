//
//  OnboardingCell.swift
//  WarmUp
//
//  Created by 장석우 on 6/21/24.
//

import SwiftUI

struct OnboardingCell: View {
    
    var systemName: String
    var title: String
    var description: String
    
    var body: some View {
        
        HStack {
            Image(systemName: systemName)
                .resizable()
                .scaledToFit()
                .foregroundStyle(.blue)
                .frame(width: 30)
                .padding(.trailing, 4)
            VStack(alignment: .leading)  {
                Text(title)
                    .font(.headline)
                    .bold()
                    
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            
        }
    }
}

#Preview {
    OnboardingCell(
        systemName: "person",
        title: "This is Title",
        description: "This is caption"
    )
}

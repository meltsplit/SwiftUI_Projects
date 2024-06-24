//
//  ClovaNavigationBar.swift
//  ClovaNote
//
//  Created by 장석우 on 6/24/24.
//

import SwiftUI

struct ClovaNavigationBar: View {
    
    let isDisplayLeftButton: Bool
    let isDisplayReightButton: Bool
    let leftButtonAction: () -> Void
    let rightButtonAction: () -> Void
    let rightButtonType: NavigationType
    
    
    
    init(isDisplayLeftButton: Bool = true,
         isDisplayReightButton: Bool = true,
         leftButtonAction: @escaping () -> Void = {},
         rightButtonAction: @escaping () -> Void = {},
         rightButtonType: NavigationType = .edit) {
        self.isDisplayLeftButton = isDisplayLeftButton
        self.isDisplayReightButton = isDisplayReightButton
        self.leftButtonAction = leftButtonAction
        self.rightButtonAction = rightButtonAction
        self.rightButtonType = rightButtonType
    }
    
    
    var body: some View {
        HStack {
            if isDisplayLeftButton {
                Button(
                    action: leftButtonAction,
                    label: { Image(systemName: "arrow.left") }
                )
            }
            
            Spacer()
            
            if isDisplayReightButton {
                Button(
                    action: rightButtonAction ,
                    label: {
                        if rightButtonType == .close {
                            Image("xmark")
                        } else {
                            Text(rightButtonType.rawValue)
                                .foregroundStyle(.black)
                        }
                    }
                )
            }
        }
        .padding(.horizontal, 20)
        .frame(height: 20)
        
        
    }
}

#Preview {
    ClovaNavigationBar()
}

//
//  ButtonStyle.swift
//  ClovaNote
//
//  Created by 장석우 on 7/3/24.
//

import SwiftUI

struct NoAnimationButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

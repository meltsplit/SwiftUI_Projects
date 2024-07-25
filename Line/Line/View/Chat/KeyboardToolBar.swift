//
//  KeyboardToolBar.swift
//  Line
//
//  Created by 장석우 on 7/25/24.
//

import SwiftUI

struct KeyboardToolBar<ToolbarView: View>: ViewModifier {
  
  private let height: CGFloat
  private let toolbarView: ToolbarView
  
  init(height: CGFloat, @ViewBuilder toolbarView: () -> ToolbarView) {
    self.height = height
    self.toolbarView = toolbarView()
  }
  
  func body(content: Content) -> some View {
    ZStack(alignment: .bottom) {
      GeometryReader{ proxy in
        content
          .frame(width: proxy.size.width, height: proxy.size.height - height)
      }
      
      toolbarView
        .frame(height: height)
      
    }
  }

}

extension View {
  func `keyboardToolbar<ToolbarView>(height: CGFloat, view: @escaping () -> ToolbarView) -> some View where ToolbarView: View {
    modifier(KeyboardToolBar(height: height, toolbarView: view))
  }
}

//
//  SettingViewModel.swift
//  Line
//
//  Created by 장석우 on 8/6/24.
//

import Foundation

class SettingViewModel: ObservableObject {
  
  enum Action {
  
  }
  
  @Published var sectionItems: [SectionItem] = []
  
  init() {
    self.sectionItems = [
      .init(label: "모드설정", settings: AppearanceType.allCases.map { .init(item: $0) })
    ]
  }
}

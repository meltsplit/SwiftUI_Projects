//
//  SettingItem.swift
//  Line
//
//  Created by 장석우 on 8/6/24.
//

import Foundation

protocol SettingItemable {
  var label: String { get }
  
}

struct SectionItem: Identifiable {
  let id = UUID()
  let label: String
  let settings: [SettingItem]
}

struct SettingItem: Identifiable {
  let id = UUID()
  let item: SettingItemable
}

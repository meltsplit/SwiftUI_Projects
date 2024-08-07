//
//  SettingView.swift
//  Line
//
//  Created by 장석우 on 8/6/24.
//

import SwiftUI

//
//  SettingView.swift
//  LMessenger
//
//

import SwiftUI

struct SettingView: View {
  @AppStorage(AppStorageType.Appearance) var appearance: Int = UserDefaults.standard.integer(forKey: AppStorageType.Appearance)
  @Environment(\.dismiss) var dismiss
  @EnvironmentObject var container: DIContainer
  @StateObject var viewModel: SettingViewModel
  
  var body: some View {
    NavigationStack {
      List {
        ForEach(viewModel.sectionItems) { section in
          Section {
            ForEach(section.settings) { setting in
              Button {
                if let a = setting.item as? AppearanceType {
                  container.appearanceController.changeAppearance(a)
                  appearance = a.rawValue
                }
              } label: {
                Text(setting.item.label)
              }
            }
          } header: {
            Text(section.label)
          }
        }
      }
      .navigationTitle("설정")
      .toolbar {
        Button {
          dismiss()
        } label: {
          Image(systemName: "xmark")
        }
      }
    }
  }
}

struct SettingView_Previews: PreviewProvider {
  static var previews: some View {
    SettingView(viewModel: .init())
      .environmentObject(DIContainer(service: StubService()))
  }
}

//
//  SettingView.swift
//  ClovaNote
//
//  Created by 장석우 on 7/10/24.
//

import SwiftUI

struct SettingView: View {
  
  @EnvironmentObject private var homeViewModel: HomeViewModel
  
  var body: some View {
    VStack {
      SettingTitleView()
        .padding(.top, 50)
        .padding(.horizontal, 30)
      
      SettingCountView()
        .padding(.top, 50)
        .padding(.horizontal, 10)
      
      Divider()
        .padding(.top, 40)
      
      SettingListView()
      
      Divider()
      
      Spacer()
    }
    
  }
}

private struct SettingTitleView: View {
  
  fileprivate var body: some View {
    HStack {
      Text("설정")
      Spacer()
    }
    .font(.system(size: 30, weight: .bold))
    .foregroundStyle(.black)
  }
}

private struct SettingCountView: View {
  
  @EnvironmentObject private var homeViewModel: HomeViewModel
  
  private var settings: [Setting] {
    return [.init(title: "To do", numberOfData: homeViewModel.todosCount),
            .init(title: "메모", numberOfData: homeViewModel.memosCount),
            .init(title: "음성메모", numberOfData: homeViewModel.voiceRecordersCount),
    ]
  }
  
  fileprivate var body: some View {
    
    HStack() {
        ForEach(settings, id: \.self) { setting in
          HStack {
            Spacer()
            SettingCountCellView(setting: setting)
            Spacer()
          }
        }
      }
  }
}

private struct SettingCountCellView: View {
  
  private var setting: Setting
  
  
  fileprivate init(setting: Setting) {
    self.setting = setting
  }
  
  
  fileprivate var body: some View {
    VStack {
      Text(setting.title)
        .font(.system(size: 14))
      
      Spacer()
        .frame(height: 10)
      
      Text(String(setting.numberOfData))
        .font(.system(size: 30, weight: .bold))
    }
    .foregroundStyle(.black)
  }
}


private struct SettingListView: View {
  
  @EnvironmentObject private var homeViewModel: HomeViewModel
  
  private var tabs = Tab.allCases
  
  fileprivate var body: some View {
    
      VStack() {
        ForEach(tabs, id: \.self) { tab in
          HStack {
            Text(tab.title)
              .font(.system(size: 14))
              
            Spacer()
            
            Button(
              action: { homeViewModel.changeSelectedTab(tab) },
              label: { Image(systemName: "chevron.right")}
            )
          }
          .foregroundStyle(.black)
          .padding(.vertical, 10)
          .padding(.horizontal, 30)
          
        }
      }
    
    
    
  }
}



#Preview {
  SettingView()
    .environmentObject(HomeViewModel())
    .environmentObject(PathModel())
}

//
//  SettingView.swift
//  ClovaNote
//
//  Created by 장석우 on 7/10/24.
//

import SwiftUI

struct SettingView: View {
  
  @EnvironmentObject var todoListViewModel: TodoListViewModel
  @EnvironmentObject var memoListViewModel: MemoListViewModel
  @EnvironmentObject var voiceRecorderViewModel: VoiceRecorderViewModel
  
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
  
  @EnvironmentObject var todoListViewModel: TodoListViewModel
  @EnvironmentObject var memoListViewModel: MemoListViewModel
  @EnvironmentObject var voiceRecorderViewModel: VoiceRecorderViewModel
  
  private var settings: [Setting] {
    return [.init(title: "To do", numberOfData: todoListViewModel.todos.count),
            .init(title: "메모", numberOfData: memoListViewModel.memos.count),
            .init(title: "음성메모", numberOfData: voiceRecorderViewModel.recordedFiles.count),
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
  
  @EnvironmentObject var pathModel: PathModel
  
  private var paths: [PathType] {
    return [.todo, .memo(isCreateModel: false, memo: nil), .voice, .timer]
  }
  
  fileprivate var body: some View {
    
      VStack() {
        ForEach(paths, id: \.self) { path in
          HStack {
            Text(path.title)
              .font(.system(size: 14))
              
            Spacer()
            
            Button(
              action: { pathModel.paths.append(path)},
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
    .environmentObject(TodoListViewModel(todos: [.init(title: "", time: .init(), day: .init(), selected: false)]))
    .environmentObject(MemoListViewModel(memos: [.mock(),.mock2()]))
    .environmentObject(VoiceRecorderViewModel(recordedFiles: [URL(fileURLWithPath: ""), ]))
    .environmentObject(PathModel())
}

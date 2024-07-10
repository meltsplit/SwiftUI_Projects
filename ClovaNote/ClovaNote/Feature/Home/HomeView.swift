//
//  HomeView.swift
//  ClovaNote
//
//  Created by 장석우 on 6/24/24.
//

import SwiftUI

struct HomeView: View {
  
  @EnvironmentObject private var pathModel: PathModel
  @StateObject private var viewModel = HomeViewModel()
  
    var body: some View {
      ZStack {
        TabView(selection: $viewModel.selectedTab) {
          TodoListView()
            .tabItem { Image(systemName: "checkmark.square")}
            .tag(Tab.todoList)
          
          MemoListView()
            .tabItem { Image(systemName: "pencil") }
            .tag(Tab.memo)
          
          VoiceRecorderView()
            .tabItem { Image(systemName: "waveform") }
            .tag(Tab.voiceRecorder)
          
          TimerView()
            .tabItem { Image(systemName: "timer") }
            .tag(Tab.timer)
            
          
          SettingView()
            .tabItem { Image(systemName: "gearshape") }
            .tag(Tab.setting)
        }
        .tint(.key)
        
        SeperatorView()
        
                
      }
      .environmentObject(viewModel)
      
    }
}

private struct SeperatorView: View {
  fileprivate var body: some View {
    VStack {
      Spacer()
      Rectangle()
        .fill(
          LinearGradient(gradient: Gradient(colors: [.white, .gray.opacity(0.1)]),
                         startPoint: .top, 
                         endPoint: .bottom)
        )
        .frame(height: 10)
        .padding(.bottom, 60)
    }
  }
}

#Preview {
    HomeView()
    .environmentObject(PathModel())
    .environmentObject(TodoListViewModel())
    .environmentObject(MemoListViewModel())
}

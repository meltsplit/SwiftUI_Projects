//
//  TimerView.swift
//  ClovaNote
//
//  Created by 장석우 on 7/8/24.
//

import SwiftUI

struct TimerView: View {
  
  @StateObject private var viewModel = TimerViewModel()
  
    var body: some View {
      
      if viewModel.isDisplaySetTimeView {
        TimerPlayView(viewModel: viewModel)
//        SetTimerView(viewModel: viewModel)
      } else {
        
      }
      
    }
}

private struct SetTimerView: View {
  
  @ObservedObject private var viewModel: TimerViewModel
  
  fileprivate init(viewModel: TimerViewModel) {
    self.viewModel = viewModel
  }
  
  fileprivate var body: some View {
    VStack {
      
      // 타이틀
      HStack {
        Text("타이머")
          .font(.system(size: 30, weight: .bold))
          .foregroundStyle(.black)
        Spacer()
      }
      .padding(.horizontal, 30)
      
      Divider()
      TimerPickerView(viewModel: viewModel)
      Divider()
      
      Button(
        action: { viewModel.settingButtonDidTap() },
        label: {
          Text("설정하기")
            .font(.system(size: 18, weight: .bold))
            .foregroundStyle(.key)
      })
    }
  }
}

private struct TimerPickerView: View {
  
  @ObservedObject private var viewModel: TimerViewModel
  
  fileprivate init(viewModel: TimerViewModel) {
    self.viewModel = viewModel
  }
  
  fileprivate var body: some View {
    HStack {
      Picker(
        selection: $viewModel.time.hours,
        content: {
          ForEach(0..<24) { hour in
            Text("\(hour)시")
          }
        },
        label: { Text("hour")}
      )
      
      Picker(
        selection: $viewModel.time.minutes,
        content: {
          ForEach(0..<60) { minutes in
            Text("\(minutes)분")
          }
        },
        label: { Text("minutes")}
      )
      
      Picker(
        selection: $viewModel.time.seconds,
        content: {
          ForEach(0..<60) { seconds in
            Text("\(seconds)초")
          }
        },
        label: { Text("seconds")}
      )
      
      
    }
    .labelsHidden()
    .pickerStyle(.wheel)
    
  }
}

//MARK: 타이머 작동뷰

private struct TimerPlayView: View {
  
  @ObservedObject private var viewModel: TimerViewModel
  
  fileprivate init(viewModel: TimerViewModel) {
    self.viewModel = viewModel
  }
  
  fileprivate var body: some View {
    VStack {
      ZStack {
        
        VStack {
          Text(viewModel.timeRemaining.formattedTimeString)
            .font(.system(size: 20))
            .foregroundStyle(.black)
            .monospaced()
          
          HStack {
            Image(systemName: "bell.fill")
              .resizable()
              .scaledToFit()
              .frame(width: 16, height: 16)
            
            Text(viewModel.time.totalSeconds.formattedSettingTime)
              .font(.system(size: 16))
              .foregroundStyle(.black)
          }
          .padding(.top, 10)
        }
        
        Circle()
          .stroke(Color.orange, lineWidth: 2)
          .padding(.horizontal, 36)
      }
      
      HStack {
        
        Button(
          action: { viewModel.cancelButtonDidTap()},
          label: {
          Text("취소")
              .font(.system(size: 16))
              .frame(width: 80, height: 80)
              .foregroundStyle(.black)
              .background(
                Circle()
                  .fill(Color.gray2.opacity(0.3))
              )
        })
        
        Spacer()
        
        Button(
          action: { viewModel.pauseOrResumeButtonDidTap()},
          label: {
            Text(viewModel.isPaused ? "계속진행" : "일시정지")
              .font(.system(size: 14))
              .frame(width: 80, height: 80)
              .foregroundStyle(.black)
              .background(
                Circle()
                  .fill(Color.orange.opacity(0.3))
              )
        })
        
      }
      .padding(.horizontal, 30)
    }
    
  }
}


#Preview {
    TimerView()
}

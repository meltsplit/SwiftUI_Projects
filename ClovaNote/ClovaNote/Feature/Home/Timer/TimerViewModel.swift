//
//  TimerViewModel.swift
//  ClovaNote
//
//  Created by 장석우 on 7/8/24.
//

import Foundation

class TimerViewModel: ObservableObject {
  @Published var isDisplaySetTimeView: Bool
  @Published var time: Time
  @Published var timer: Timer?
  @Published var timeRemaining: Int
  @Published var isPaused: Bool
  
  init(
    isDisplaySetTimeView: Bool = true,
    time: Time = .init(0),
    timer: Timer? = nil,
    timeRemaining: Int = 0,
    isPaused: Bool = false
  ) {
    self.isDisplaySetTimeView = isDisplaySetTimeView
    self.time = time
    self.timeRemaining = timeRemaining
    self.isPaused = isPaused
  }
  
}

extension TimerViewModel {
  func settingButtonDidTap() {
    isDisplaySetTimeView = false
    timeRemaining = time.totalSeconds
    startTimer()
  }
  
  func cancelButtonDidTap() {
    stopTimer()
  }
  
  func pauseOrResumeButtonDidTap() {
    if isPaused {
      startTimer()
    } else {
      timer?.invalidate()
      timer = nil
    }
    isPaused.toggle()
  }
  
}

private extension TimerViewModel {
  
  func startTimer() {
    guard timer == nil else { return }
    timer = Timer.scheduledTimer(
      withTimeInterval: 1,
      repeats: true
    ) { [weak self] _ in
      if let timeRemaing = self?.timeRemaining,
         timeRemaing > 0 {
        self?.timeRemaining -= 1
      } else {
        self?.stopTimer()
      }
    }
  }
  
  func stopTimer() {
    timer?.invalidate()
    timer = nil
  }
  
  
  
}

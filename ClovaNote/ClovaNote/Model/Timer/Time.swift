//
//  Time.swift
//  ClovaNote
//
//  Created by 장석우 on 7/8/24.
//

import Foundation

struct Time {
  var hours: Int
  var minutes: Int
  var seconds: Int
  
  var totalSeconds: Int {
    return (hours * 3600) + (minutes * 60) + seconds
  }
  
  init(
    _ hours: Int,
    _ minutes: Int,
    _ seconds: Int
  ) {
    self.hours = hours
    self.minutes = minutes
    self.seconds = seconds
  }
  
  init(_ seconds: Int) {
    self.hours = seconds / 3600
    self.minutes = (seconds % 3600) / 60
    self.seconds = (seconds % 3600) % 60
  }
  
}

//
//  Int+.swift
//  ClovaNote
//
//  Created by 장석우 on 7/8/24.
//

import Foundation

extension Int {
  var formattedTimeString: String {
    let time = Time(self)
    let hours = String(format: "%02d", time.hours)
    let minutes = String(format: "%02d", time.minutes)
    let seconds = String(format: "%02d", time.seconds)
    return hours + " : " + minutes + " : " + seconds
  }
  
  var formattedSettingTime: String {
    let settingDate = Date().addingTimeInterval(TimeInterval(self))
    
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    formatter.dateFormat = "HH:mm"
    
    let formattedTime = formatter.string(from: settingDate)
    return formattedTime
  }
}

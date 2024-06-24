//
//  Date+.swift
//  ClovaNote
//
//  Created by 장석우 on 6/24/24.
//

import Foundation

extension Date {
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a hh:mm"
        return formatter.string(from: self)
    }
    
    var formattedDay: String {
        let now = Date()
        let calender = Calendar.current
        
        let nowStartofDay = calender.startOfDay(for: now)
        let dateStartofDay = calender.startOfDay(for: self)
        let diff = calender.dateComponents([.day],
                                           from: nowStartofDay,
                                           to: dateStartofDay).day!
        
        if diff == 0 {
            return "오늘"
        } else {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "M월 d일 E요일"
            return formatter.string(from: self)
        }
        
    }
}



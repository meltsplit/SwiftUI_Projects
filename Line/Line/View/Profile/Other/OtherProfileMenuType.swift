//
//  OtherProfileMenuType.swift
//  Line
//
//  Created by 장석우 on 7/24/24.
//

import Foundation

enum OtherProfileMenuType: Hashable, CaseIterable {
    case chat
    case phoneCall
    case videoCall
    
    var description: String {
        switch self {
        case .chat:
            return "대화"
        case .phoneCall:
            return "음성통화"
        case .videoCall:
            return "영상통화"
        }
    }
    
    var imageName: String {
        switch self {
        case .chat:
            return "bubble.fill"
        case .phoneCall:
            return "phone.fill"
        case .videoCall:
            return "video.fill"
        }
    }
}

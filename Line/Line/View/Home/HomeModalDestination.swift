//
//  HomeModalDestination.swift
//  Line
//
//  Created by 장석우 on 7/20/24.
//

import SwiftUI

enum HomeModalDestination: Hashable, Identifiable {
  case myProfile
  case otherProfile(String)
  
  var id: Int {
    hashValue
  }
}

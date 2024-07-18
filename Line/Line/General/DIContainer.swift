//
//  DIContainer.swift
//  Line
//
//  Created by 장석우 on 7/16/24.
//

import Foundation

class DIContainer: ObservableObject {
  //TODO: service
  var service: ServiceType
  
  init(service: ServiceType) {
    self.service = service
  }
}

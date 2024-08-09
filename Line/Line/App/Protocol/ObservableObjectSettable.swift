//
//  ObservableObjectSettable.swift
//  Line
//
//  Created by 장석우 on 8/7/24.
//

import Foundation
import Combine

protocol ObservableObjectSettable: AnyObject {
  var objectWillChange: ObservableObjectPublisher? { get set }
  func setObjectWillChange(_ objectWillChange: ObservableObjectPublisher?)
}

extension ObservableObjectSettable {
  func setObjectWillChange(_ objectWillChange: ObservableObjectPublisher?) {
    self.objectWillChange = objectWillChange
  }
}

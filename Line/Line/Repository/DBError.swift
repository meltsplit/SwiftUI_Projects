//
//  DBError.swift
//  Line
//
//  Created by 장석우 on 7/19/24.
//

import Foundation

enum DBError: Error {
  case error(Error)
  case emptyValue
  
}

//
//  PhotoImage.swift
//  Line
//
//  Created by 장석우 on 7/22/24.
//

import Foundation
import SwiftUI

struct PhotoImage: Transferable {
  
  var data: Data
  
  static var transferRepresentation : some TransferRepresentation {
    DataRepresentation(importedContentType: .image) { data in
      guard let image = UIImage(data: data) 
      else { throw PhotoServiceError.importFail }
      
      guard let data = image.jpegData(compressionQuality: 0.3)
      else { throw PhotoServiceError.importFail }
      
      return PhotoImage(data: data)
    }
  }
  
}

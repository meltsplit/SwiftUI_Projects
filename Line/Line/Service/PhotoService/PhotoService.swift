//
//  PhotoService.swift
//  Line
//
//  Created by 장석우 on 7/22/24.
//

import Foundation
import SwiftUI
import PhotosUI

enum PhotoServiceError : Error {
  case importFail
}

protocol PhotoServiceType {
  func loadTransferable(from imageSelection: PhotosPickerItem) async throws -> Data
}

class PhotoService: PhotoServiceType {

  func loadTransferable(
    from imageSelection: PhotosPickerItem
  ) async throws -> Data {
    
    guard let photoImage = try await imageSelection.loadTransferable(type: PhotoImage.self)
    else { throw PhotoServiceError.importFail }
    
    return photoImage.data
  }
  
}

class StubPhotoService: PhotoServiceType {

  func loadTransferable(
    from imageSelection: PhotosPickerItem
  ) async throws -> Data {
    return Data()
  }
}


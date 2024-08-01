//
//  PhotoService.swift
//  Line
//
//  Created by 장석우 on 7/22/24.
//

import Foundation
import SwiftUI
import PhotosUI
import Combine

enum PhotoServiceError : Error {
  case importFail
}

protocol PhotoServiceType {
  func loadTransferable(from imageSelection: PhotosPickerItem) async throws -> Data
  func loadTransferable(from imageSelection: PhotosPickerItem) -> AnyPublisher<Data, ServiceError>
}

class PhotoService: PhotoServiceType {

  func loadTransferable(
    from imageSelection: PhotosPickerItem
  ) async throws -> Data {
    
    guard let photoImage = try await imageSelection.loadTransferable(type: PhotoImage.self)
    else { throw PhotoServiceError.importFail }
    
    return photoImage.data
  }
  
  func loadTransferable(from imageSelection: PhotosPickerItem) -> AnyPublisher<Data, ServiceError> {
    Future { promise in
      imageSelection.loadTransferable(type: PhotoImage.self) { result in
        promise(result)
      }
    }
    .tryMap {
      guard let data = $0?.data else { throw PhotoServiceError.importFail }
      return data
    }
    .mapError { .error($0) }
    .eraseToAnyPublisher()
   
    
  }
  
}

class StubPhotoService: PhotoServiceType {

  func loadTransferable(
    from imageSelection: PhotosPickerItem
  ) async throws -> Data {
    return Data()
  }
  
  func loadTransferable(from imageSelection: PhotosPickerItem) -> AnyPublisher<Data, ServiceError> {
    Empty().eraseToAnyPublisher()
  }
}


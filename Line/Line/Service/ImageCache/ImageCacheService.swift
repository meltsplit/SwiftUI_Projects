//
//  ImageCacheService.swift
//  Line
//
//  Created by 장석우 on 7/24/24.
//

import UIKit
import Combine

protocol ImageCacheServiceType {
  func image(for key: String) -> AnyPublisher<UIImage?, Never>
}

class ImageCacheService: ImageCacheServiceType {
  
  let memoryStorage: MemoryStorageType
  let diskStorage: DiskStorageType
  
  init(
    memoryStorage: MemoryStorageType,
    diskStorage: DiskStorageType
  ) {
    self.memoryStorage = memoryStorage
    self.diskStorage = diskStorage
  }
  
  func image(for key: String) -> AnyPublisher<UIImage?, Never> {
    /*
     1. memory storage
     2. disk storage
     3. url session
     */
    imageWithMemoryCache(for: key)
      .flatMap { image -> AnyPublisher<UIImage?, Never> in
        if let image {
          return Just(image).eraseToAnyPublisher()
        } else {
          return self.imageWithDiskCache(for: key)
        }
      }
      .eraseToAnyPublisher()
    
  }
  
  private func imageWithMemoryCache(for key: String) -> AnyPublisher<UIImage?, Never>{
    Future { [weak self] promise in
      let image = self?.memoryStorage.value(for: key)
      promise(.success(image))
    }
    .eraseToAnyPublisher()
  }
  
  private func imageWithDiskCache(for key: String) -> AnyPublisher<UIImage?, Never>{
    Future<UIImage?, Never> { [weak self] promise in
      do {
        let image = try self?.diskStorage.value(for: key)
        promise(.success(image))
      } catch {
        promise(.success(nil))
      }
    }
    .flatMap { image -> AnyPublisher<UIImage?, Never> in
      if let image {
        return Just(image)
          .handleEvents(receiveOutput: { [weak self] image in
            guard let image else { return }
            self?.store(for: key, image: image, toDisk: false)
          })
          .eraseToAnyPublisher()
        
      } else {
        return self.remoteImage(for: key)
      }
    }.eraseToAnyPublisher()
  }
  
  private func remoteImage(for urlString: String) -> AnyPublisher<UIImage?, Never> {
    URLSession.shared.dataTaskPublisher(for: URL(string: urlString)!)
      .map { data, _ in
        UIImage(data: data)
      }
      .handleEvents(receiveOutput: { [weak self] image in
        guard let image else { return }
        self?.store(for: urlString, image: image, toDisk: true)
      })
      .replaceError(with: nil)
      .eraseToAnyPublisher()
  }
  
  private func store(for key: String, image: UIImage, toDisk: Bool) {
    
    memoryStorage.store(for: key, image: image)
    
    if toDisk {
      try? diskStorage.store(for: key, image: image)
    }
  }
  
}

class StubImageCacheService: ImageCacheServiceType {
  func image(for key: String) -> AnyPublisher<UIImage?, Never> {
    Empty().eraseToAnyPublisher()
  }
}

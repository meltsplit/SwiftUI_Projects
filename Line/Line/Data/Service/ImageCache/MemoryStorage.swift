//
//  MemoryStorage.swift
//  Line
//
//  Created by 장석우 on 7/24/24.
//

import UIKit

protocol MemoryStorageType {
  func value(for key: String) -> UIImage?
  func store(for key: String, image: UIImage)
}

class MemoryStorage: MemoryStorageType {
  
  var cache = NSCache<NSString, UIImage>()
  
  func value(for key: String) -> UIImage? {
    cache.object(forKey: NSString(string: key))
  }
  
  func store(for key: String, image: UIImage) {
    cache.setObject(image, forKey: NSString(string: key))
  }
  
  
}

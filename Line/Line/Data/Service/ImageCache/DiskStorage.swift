//
//  DiskCache.swift
//  Line
//
//  Created by 장석우 on 7/24/24.
//

import UIKit

protocol DiskStorageType {
  func value(for key: String) throws -> UIImage?
  func store(for key: String, image: UIImage) throws
}

class DiskStorage: DiskStorageType {
  
  let fileManager: FileManager
  let directoryURL: URL
  
  init(
    fileManager: FileManager = .default
  ) {
    self.fileManager = fileManager
    self.directoryURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathExtension("ImageCache")
  }
  
  private func createDirectory() {
    guard !fileManager.fileExists(atPath: directoryURL.path()) else { return }
    do {
      try fileManager.createDirectory(atPath: directoryURL.path(), withIntermediateDirectories: true)
    } catch {
      print(error.localizedDescription)
    }
  }
  
  private func cacheFileURL(for key: String) -> URL {
    let fileName = sha256(key)
    return directoryURL.appendingPathComponent(fileName, isDirectory: false)
  }
  
  func value(for key: String) throws -> UIImage? {
    let fileURL = cacheFileURL(for: key)
    guard fileManager.fileExists(atPath: fileURL.path()) else { return nil }
    let data = try Data(contentsOf: fileURL)
    return UIImage(data: data)
  }
  
  func store(for key: String, image: UIImage) throws {
    // 메모리 storage에도 없고
    // 디스크 storage도 없을 경우 해당 함수 호출됨
    let data = image.jpegData(compressionQuality: 0.5)
    let fileURL = cacheFileURL(for: key)
    try data?.write(to: fileURL)
  }
  
  
}

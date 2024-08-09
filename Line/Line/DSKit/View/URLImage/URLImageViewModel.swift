//
//  URLImageViewModel.swift
//  Line
//
//  Created by 장석우 on 7/24/24.
//

import UIKit
import Combine

class URLImageViewModel: ObservableObject {
  
  var loadingOrSuccess: Bool {
    return loading || loadedImage != nil
  }
  
  @Published var loadedImage: UIImage?
  
  private var loading: Bool = false
  
  private var urlString: String
  private var container: DIContainer
  private var subscriptions = Set<AnyCancellable>()
  
  init(urlString: String, container: DIContainer) {
    self.urlString = urlString
    self.container = container
  }
  
  
  func start() {
    guard !urlString.isEmpty else { return }
    
    loading = true
    
    container.service.imageCacheService.image(for: urlString)
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self]  image in
        self?.loading = false
        self?.loadedImage = image
      }
      .store(in: &subscriptions)
  }
  
}

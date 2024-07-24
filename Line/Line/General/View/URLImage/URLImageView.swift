//
//  URLImageView.swift
//  Line
//
//  Created by 장석우 on 7/24/24.
//

import SwiftUI

struct URLImageView: View {
  
  @EnvironmentObject var container: DIContainer
  
  let urlString: String?
  let placeholderName: String
  
  init(urlString: String?, placeholderName: String = "we") {
    self.urlString = urlString
    self.placeholderName = placeholderName
  }
  
  var body: some View {
    if let urlString, !urlString.isEmpty {
      URLInnerImageView(
        viewModel: .init(urlString: urlString,
                         container: container),
        placeholderName: placeholderName
      ).id(urlString)
    } else {
      Image(placeholderName)
        .resizable()
    }
  }
}

struct URLInnerImageView: View {
  
  @StateObject var viewModel: URLImageViewModel
  
  let placeholderName: String
  var placeholderImage: UIImage {
    UIImage(named: placeholderName) ?? UIImage()
    
  }
  
  var body: some View {
    Image(uiImage: viewModel.loadedImage ?? placeholderImage)
      .resizable()
      .aspectRatio(contentMode: .fill)
      .onAppear(perform: {
        if !viewModel.loadingOrSuccess {
          viewModel.start()
        }
      })
  }
}

#Preview {
  URLImageView(urlString: "")
}



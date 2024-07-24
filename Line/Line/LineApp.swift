//
//  LineApp.swift
//  Line
//
//  Created by 장석우 on 7/12/24.
//

import SwiftUI

@main
struct LineApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  
  @StateObject var container = DIContainer(service: Service())
  
  var body: some Scene {
    WindowGroup {
      AuthenticatedView(authViewModel: .init(container: container), navigationRouter: .init())
      
        .environmentObject(container)
    }
  }
}

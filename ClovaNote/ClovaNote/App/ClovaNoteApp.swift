//
//  ClovaNoteApp.swift
//  ClovaNote
//
//  Created by 장석우 on 6/24/24.
//

import SwiftUI

@main
struct ClovaNoteApp: App {
  
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
    var body: some Scene {
        WindowGroup {
            OnboardingView()
                
        }
    }
}

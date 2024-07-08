//
//  AppDelegate.swift
//  ClovaNote
//
//  Created by 장석우 on 6/24/24.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
  
  var notificationDelegate = NotificationDelegate()
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
  ) -> Bool {
    UNUserNotificationCenter.current().delegate = notificationDelegate
    return true
  }
}

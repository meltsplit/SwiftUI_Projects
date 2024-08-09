//
//  PushNotificationService.swift
//  Line
//
//  Created by 장석우 on 8/1/24.
//

import Foundation
import Combine
import FirebaseMessaging

protocol PushNotificationServiceType {
  var fcmToken: AnyPublisher<String?, Never> { get }
  func requestAuthorization(completion: @escaping (Bool) -> Void)
}

class PushNotificationService: NSObject, PushNotificationServiceType {
    
  
  var fcmToken: AnyPublisher<String?, Never> {
    _fcmToken.eraseToAnyPublisher()
  }
  private let _fcmToken = CurrentValueSubject<String?, Never>(nil)
  
  override init() {
    super.init()
    
    Messaging.messaging().delegate = self
  }
  
  func requestAuthorization(completion: @escaping (Bool) -> Void) {
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
      if let error { completion(false) }
      else {
        completion(granted)
      }
    }
  }
}

extension PushNotificationService: MessagingDelegate {
  
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print(messaging)
    _fcmToken.send(fcmToken)
  }
}

class StubPushNotificationService: PushNotificationServiceType {
  var fcmToken: AnyPublisher<String?, Never> {
    Empty().eraseToAnyPublisher()
  }
  
  func requestAuthorization(completion: @escaping (Bool) -> Void) {
    completion(true)
  }
  
    
}

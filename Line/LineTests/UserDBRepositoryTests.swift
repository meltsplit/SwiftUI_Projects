//
//  UserDBRepositoryTests.swift
//  LineTests
//
//  Created by 장석우 on 8/7/24.
//

import XCTest
import Combine
@testable import Line

final class UserDBRepositoryTests: XCTestCase {
  
  private var subscriptions = Set<AnyCancellable>()
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    subscriptions = Set<AnyCancellable>()
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
}

//
//  SearchDataController.swift
//  Line
//
//  Created by 장석우 on 8/6/24.
//

import Foundation
import CoreData

protocol DataControllable {
  var persistantContainer : NSPersistentContainer { get set }
}

class SearchDataController: DataControllable {

  var persistantContainer: NSPersistentContainer = NSPersistentContainer(name: "Search")
  
  init() {
    persistantContainer.loadPersistentStores { description, error in
      if let error { print(error) }
      
    }
  }
}

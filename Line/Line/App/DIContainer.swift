//
//  DIContainer.swift
//  Line
//
//  Created by 장석우 on 7/16/24.
//

import Foundation

typealias NavigationRoutableType = NavigationRoutable & ObservableObjectSettable

class DIContainer: ObservableObject {
  //TODO: service
  var service: ServiceType
  var searchDataController: DataControllable
  var navigationRouter: NavigationRoutable & ObservableObjectSettable
  var appearanceController: AppearanceControllable & ObservableObjectSettable
  
  init(service: ServiceType,
       searchDataController: DataControllable = SearchDataController(),
       navigationRouter: NavigationRoutable & ObservableObjectSettable = NavigationRouter(),
       appearanceController: AppearanceControllable & ObservableObjectSettable = AppearanceController()
  ) {
    self.service = service
    self.searchDataController = searchDataController
    self.navigationRouter = navigationRouter
    self.appearanceController = appearanceController
    
    navigationRouter.setObjectWillChange(objectWillChange)
    appearanceController.setObjectWillChange(objectWillChange)
  }
}

//
//  DBReference.swift
//  Line
//
//  Created by 장석우 on 8/7/24.
//

import Foundation
import Combine

import FirebaseDatabase

typealias DBReferenceType = DBReferenceType_Default & DBReferenceType_Combine & DBReferenceType_Concurrency

protocol DBReferenceType_Default {
  func childByAutoId(key: String, path: String?) -> String?
  func removeObservedHandlers()
}

protocol DBReferenceType_Combine {
  func setValue(key: String, path: String?, value: Any) -> AnyPublisher<Void, DBError>
  func setValues(_ values: [String: Any]) -> AnyPublisher<Void, DBError>
  func fetch(key: String, path: String?) -> AnyPublisher<Any?, DBError>
  func filter(key: String, path: String?, orderedName: String, queryString: String) -> AnyPublisher<Any?, DBError>
  func observeChildAdded(key: String, path: String?) -> AnyPublisher<Any?, DBError>
}

protocol DBReferenceType_Concurrency {
  func setValue(key: String, path: String?, value: Any) async throws
  func fetch(key: String, path: String?) async throws -> Any?
  func childByAutoId(key: String, path: String?) -> String?
  func removeObservedHandlers()
}

class DBReference: DBReferenceType_Default {
  
  var db: DatabaseReference = Database.database().reference()
  var observedHandlers: [UInt] = []
  private func getPath(key: String, path: String?) -> String {
    if let path {
      return key + "/" + path
    } else {
      return key
    }
  }
  func childByAutoId(key: String, path: String?) -> String? {
    db.child(getPath(key: key, path: path)).childByAutoId().key
  }
  
  func observeChildAdded(key: String, path: String?) -> AnyPublisher<Any?, DBError> {
    let subject = PassthroughSubject<Any?, DBError>()
    
    let handler = db.child(getPath(key: key, path: path)).observe(.childAdded) { snapshot in
      subject.send(snapshot.value)
    }
    
    observedHandlers.append(handler)
    
    return subject.eraseToAnyPublisher()
  }
  
  func removeObservedHandlers() {
    observedHandlers.forEach {
                db.removeObserver(withHandle: $0)
            }
  }
}

//MARK: - Combine

extension DBReference: DBReferenceType_Combine {
  
  func setValue(key: String, path: String?, value: Any) -> AnyPublisher<Void, DBError> {
    
    let path = getPath(key: key, path: path)
    
    return Future<Void,DBError> { [weak self] promise in
      self?.db.child(path).setValue(value) { error , _ in
        if let error { promise(.failure(.error(error))) }
        else { promise(.success(())) }
      }
    }
    .eraseToAnyPublisher()
  }
  
  
  func setValues(_ values: [String : Any]) -> AnyPublisher<Void, DBError> {
    Future<Void, DBError> { [weak self] promise in
      self?.db.updateChildValues(values) { error, _ in
        if let error { promise(.failure(.error(error))) }
        else { promise(.success(())) }
      }
    }
    .eraseToAnyPublisher()
  }
  
  func fetch(key: String, path: String?) -> AnyPublisher<Any?, DBError>
  {
    let path = getPath(key: key, path: path)
    
    return Future<Any?, DBError> { [weak self] promise in
      self?.db.child(path).getData(completion: { error, snapshot in
        if let error { promise(.failure(.error(error)))}
        else if snapshot?.value is NSNull { promise(.success(nil)) }
        else { promise(.success(snapshot?.value))}
      })
    }
    .eraseToAnyPublisher()
  }
  
  func filter(key: String, path: String?, orderedName: String, queryString: String) -> AnyPublisher<Any?, DBError> {
    let path = getPath(key: key, path: path)
    
    return Future<Any?, DBError> { [weak self] promise in
      self?.db.child(path)
        .queryOrdered(byChild: orderedName)
        .queryStarting(atValue: queryString)
        .queryEnding(atValue: queryString + "\u{f8ff}")
        .observeSingleEvent(of: .value, with: { snapshot in
          promise(.success(snapshot.value))
        })
    }
    .eraseToAnyPublisher()
  }
  
}

//MARK: - Swift Concurrency

extension DBReference: DBReferenceType_Concurrency {
  func setValue(key: String, path: String?, value: Any) async throws {
    let path = getPath(key: key, path: path)
    try await db.child(path).setValue(value)
  }
  
  func fetch(key: String, path: String?) async throws -> Any? {
    let path = getPath(key: key, path: path)
    return try await db.child(path).getData().value
  }
}

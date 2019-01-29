//
//  AilLazyInitializer.swift
//  Pods
//
//  Created by Bathilde ROCCHIA on 18/10/2016.
//
//

import Foundation

public class AilLazyInitializer {
  public static let sharedInstance = AilLazyInitializer()
  
  fileprivate init() {  }
  
  fileprivate var initializableTable: [String: () -> AilLazyInitializable] = [:]
  fileprivate var initializedTable: [String: AilLazyInitializable] = [:]
  
  public func register<T: AilLazyInitializable>(initializable: @escaping () -> AilLazyInitializable, defaultValue: () -> T) {
    initializableTable[T.identifier] = initializable
  }
  
  public func get<T: AilLazyInitializable>() -> T {
    // first we check if a class was already created
    var initialized = initializedTable.first { $0.key == T.identifier }?.value
    
    // if not, we instantiate a new one
    if initialized == nil {
      initialized = (initializableTable.first { $0.key == T.identifier })?.value()
      initializedTable[T.identifier] = initialized!
    }
    
    return initialized as! T
  }
}

public protocol AilLazyInitializable {
  static var identifier: String { get }
}

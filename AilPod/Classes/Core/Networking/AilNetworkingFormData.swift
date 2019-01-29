//
//  AilNetworkingFormData.swift
//  AilPod
//
//  Created by Jeremy KERBIDI on 29/11/2018.
//

import Foundation

// MARK: - AilDataFormParameter
/**
 We need to have the extension here, because in an other file, the compiler does not found explicitely the extension
 */

protocol AilDataFormParameter {
  func toData() -> Data?
}

extension Data: AilDataFormParameter {
  func toData() -> Data? { return self }
}

extension Double: AilDataFormParameter {
  func toData() -> Data? { return String(self).data(using: .utf8) }
}

extension Float: AilDataFormParameter {
  func toData() -> Data? { return String(self).data(using: .utf8) }
}

extension Int: AilDataFormParameter {
  func toData() -> Data? { return String(self).data(using: .utf8) }
}

extension String: AilDataFormParameter {
  func toData() -> Data? { return self.data(using: .utf8) }
}

// MARK: - AilDataFormFileParameter

public protocol AilDataFormFileParameter {
  var mimType: String { get }
  var fileName: String { get }
  var data: Data { get }
}


// MARK: - AilNetworkingFormData

public protocol AilNetworkingFormData {
  
  func performBackgroundFetchFormDataWithCompletion(_ method: AilMethod,
                                                                       _ configuration: AilNetworkingConfiguration,
                                                                       params: [String : Any]?,
                                                                       result: @escaping (Any?, Error?) -> Void)
}

public extension AilNetworkingFormData {
  
  // without method
  func performBackgroundFetchFormDataWithCompletion(_ configuration: AilNetworkingConfiguration, params: [String : Any]?, result: @escaping (Any?, Error?) -> Void) {
    self.performBackgroundFetchFormDataWithCompletion(.POST, configuration, params: params, result: result)
  }
  
  // without parameters
  func performBackgroundFetchFormDataWithCompletion(_ method: AilMethod, _ configuration: AilNetworkingConfiguration, result: @escaping (Any?, Error?) -> Void) {
    self.performBackgroundFetchFormDataWithCompletion(configuration, params: nil, result: result)
  }
}

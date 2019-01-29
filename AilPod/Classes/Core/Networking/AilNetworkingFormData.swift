//
//  AilNetworkingFormData.swift
//  AilPod
//
//  Created by Jeremy KERBIDI on 29/11/2018.
//

import Foundation
import Alamofire

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

extension Array: AilDataFormArrayParameter  {
  func setFormDataParameters(_ formDataParameters: MultipartFormData, key: String) {
    self.forEach { (element) in
      if let element = element as? AilDataFormParameter, let data = element.toData() {
        formDataParameters.append(data, withName: key)
      } else if let element = element as? AilDataFormFileParameter {
        formDataParameters.append(element.data, withName: key, fileName: element.fileName, mimeType: element.mimType)
      }
    }
  }
}

// MARK: - AilNetworkingFormData

public protocol AilNetworkingFormData {
  
  func performBackgroundFetchFormDataWithCompletion(_ method: AilMethod,
                                                                       _ configuration: AilNetworkingConfigutation,
                                                                       params: [String : Any]?,
                                                                       result: @escaping (Any?, Error?) -> Void)
}

public extension AilNetworkingFormData {
  
  // without method
  func performBackgroundFetchFormDataWithCompletion(_ configuration: AilNetworkingConfigutation, params: [String : Any]?, result: @escaping (Any?, Error?) -> Void) {
    self.performBackgroundFetchFormDataWithCompletion(.POST, configuration, params: params, result: result)
  }
  
  // without parameters
  func performBackgroundFetchFormDataWithCompletion(_ method: AilMethod, _ configuration: AilNetworkingConfigutation, result: @escaping (Any?, Error?) -> Void) {
    self.performBackgroundFetchFormDataWithCompletion(configuration, params: nil, result: result)
  }
}

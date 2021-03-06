//
//  IAilNetworking.swift
//  AFNetworking
//
//  Created by Bathilde ROCCHIA on 05/09/2018.
//

import Foundation

public enum AilMethod {
  case GET
  case PUT
  case POST
  case DELETE
}

public enum AilParameterEncoding {
  case URL
  case json
}

public class AilNetworkingConfiguration {
  
  let headers: [String : String]?
  var url: String
  
  public required init(headers: [String : String]? = ["Content-Type" :" application/json"], url: String) {
    self.headers = headers
    self.url = url
  }
}

public protocol AilNetworkingCancellableTask {
  func cancelTask()
}

public protocol AilNetworking {
  
  init(debugMode: Bool, timeoutInterval: Double)

  // with all parameters
  @discardableResult func performBackgroundFetchWithCompletion(_ method: AilMethod,
                                                               _ configuration: AilNetworkingConfiguration,
                                                               params: [String: Any]?,
                                                               encoding: AilParameterEncoding?,
                                                               result: @escaping (Any?, Error?) -> Void)
    -> AilNetworkingCancellableTask?

}

public extension AilNetworking {
  
  // without method
  @discardableResult func performBackgroundFetchWithCompletion(_ configuration: AilNetworkingConfiguration, params: [String: Any]?, encoding: AilParameterEncoding, result: @escaping (Any?, Error?) -> Void) -> AilNetworkingCancellableTask?
  {
    return self.performBackgroundFetchWithCompletion(.GET, configuration, params: params, encoding: encoding, result: result)
  }
  
  // without parameters
  @discardableResult func performBackgroundFetchWithCompletion(_ method: AilMethod, _ configuration: AilNetworkingConfiguration, result: @escaping (Any?, Error?) -> Void) -> AilNetworkingCancellableTask?
  {
    return self.performBackgroundFetchWithCompletion(method, configuration, params: nil, encoding: nil, result: result)
  }
  
  // without header
  @discardableResult func performBackgroundFetchWithCompletion(_ method: AilMethod, url: String, params: [String: Any]?, encoding: AilParameterEncoding, result: @escaping (Any?, Error?) -> Void) -> AilNetworkingCancellableTask?
  {
    let configuration = AilNetworkingConfiguration(headers: nil, url: url)
    return self.performBackgroundFetchWithCompletion(method, configuration, params: params, encoding: encoding, result: result)
  }
  
  // without header + parameters
  @discardableResult func performBackgroundFetchWithCompletion(_ method: AilMethod, url: String, result: @escaping (Any?, Error?) -> Void) -> AilNetworkingCancellableTask?
  {
    let configuration = AilNetworkingConfiguration(headers: nil, url: url)
    return self.performBackgroundFetchWithCompletion(method, configuration, params: nil, encoding: nil, result: result)
  }
}




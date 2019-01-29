//
//  WebServiceManager.swift
//  AilPod
//
//  Created by Bathilde ROCCHIA on 02/08/2016.
//  Copyright © 2016 Bathilde ROCCHIA. All rights reserved.
//

import Foundation
import AFNetworking

open class AilNetworkingAFNetworkingCancellableTask: AilNetworkingCancellableTask {
  var currentTask: URLSessionDataTask
  
  init(task: URLSessionDataTask) {
    self.currentTask = task
  }
  
  open func cancelTask() {
    currentTask.cancel()
  }
}

open class AilNetworkingAFNetworking: AilNetworking {
  
  var reachability: AFNetworkReachabilityManager?
  private var debugMode: Bool
  private var timeoutInterval: Double
  
  public required init(debugMode: Bool = false, timeoutInterval: Double = 30) {
    self.debugMode = debugMode
    self.timeoutInterval = timeoutInterval
  }
  
  public func performBackgroundFetchWithCompletion(_ method: AilMethod, _ configuration: AilNetworkingConfiguration, params: [String : Any]?, encoding: AilParameterEncoding?, result: @escaping (Any?, Error?) -> Void) -> AilNetworkingCancellableTask? {
    if (self.networkIsReachable() == true) {
      let currentTask = self.baseRequest(method, url: configuration.url, headers: configuration.headers, postParams: params, encoding: encoding, result: result)
      return currentTask != nil ? AilNetworkingAFNetworkingCancellableTask(task: currentTask!) : nil
    }
    else {
      result(nil, AilError.noNetwork)
      return nil
    }
  }
  
  func baseRequest(_ method: AilMethod = .GET, url: String, headers: [String: String]?, postParams params: [String: Any]?, encoding: AilParameterEncoding?, result: @escaping (Any?, Error?) -> Void) -> URLSessionDataTask? {
    
    let manager = AFHTTPSessionManager()
    if encoding == .json {
      manager.requestSerializer = AFJSONRequestSerializer()
    }
    
    manager.requestSerializer.timeoutInterval = self.timeoutInterval
    
    if headers != nil {
      for h in headers! {
        manager.requestSerializer.setValue(h.value, forHTTPHeaderField: h.key)
      }
    }
    
    if debugMode {
      print("AilPod: Request: \(method)\nurl: \(url), \nheaders: \(headers ?? [:])\nparams: \(params)\nencoding: \(encoding)")
    }
    
    switch method {
    case .GET:
      return manager.get(url, parameters: params, progress: nil, success: { self.successResponse(task: $0, response: $1, result: result) }, failure: { self.errorResponse(task: $0, response: $1, result: result) })
    case .POST:
      return manager.post(url, parameters: params, progress: nil, success: { self.successResponse(task: $0, response: $1, result: result) }, failure: { self.errorResponse(task: $0, response: $1, result: result) })
    case .PUT:
      return manager.put(url, parameters: params, success: { self.successResponse(task: $0, response: $1, result: result) }, failure: { self.errorResponse(task: $0, response: $1, result: result) })
    case .DELETE:
      return manager.delete(url, parameters: params, success: { self.successResponse(task: $0, response: $1, result: result) }, failure: { self.errorResponse(task: $0, response: $1, result: result) })
    }
  }
  
  // MARK: Handling response
  
  func successResponse(task: URLSessionDataTask, response: Any?, result: @escaping (Any?, Error?) -> Void) {
    if debugMode {
      print("AilPod: SuccessReponse: \(response ?? "nil")")
    }
    if let httpResponse = task.response as? HTTPURLResponse {
      self.handleResult(response, statusCode: httpResponse.statusCode, result: result)
    }
    else if let error = task.error {
      self.handleResult(response, error: error, result: result)
    }
  }
  
  func errorResponse(task: URLSessionDataTask?, response: Any?, result: @escaping (Any?, Error?) -> Void) {
    if debugMode {
      print("AilPod: ErrorReponse: \(response ?? "nil")")
    }
    if let httpResponse = task?.response as? HTTPURLResponse {
      self.handleResult(response, statusCode: httpResponse.statusCode, result: result)
    }
    else if let error = task?.error {
      self.handleResult(response, error: error, result: result)
    }
  }
  
  func handleResult(_ response: Any?, error: Error, result: (Any?, Error?) -> Void) {
    result(response, error)
  }
  
  func handleResult(_ response: Any?, statusCode: Int, result: (Any?, Error?) -> Void) {
    
    if (statusCode >= 200 && statusCode < 300) {
      result(response, nil)
    }
    else {
      if statusCode == NSURLErrorNotConnectedToInternet {
        result(nil, AilError.noNetwork)
      }
      else {
        if let errorType = AilError.getAilErrorFrom(statusCode) {
          result(response, errorType)
        }
        else {
          result(response, AilError.unknown)
        }
      }
    }
  }
  
  // MARK: Reachability
  
  public func networkIsReachable() -> Bool {
    
    guard let actualReachability = reachability else {
      return true
    }
    
    return actualReachability.isReachable
  }
  
  public func startReachability() {
    let reach = AFNetworkReachabilityManager.shared()
    reach.startMonitoring()
    reach.setReachabilityStatusChange { (_) in
      self.reachability = reach
    }
  }
  
}


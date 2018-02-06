//
//  WebServiceManager.swift
//  AilPod
//
//  Created by Bathilde ROCCHIA on 02/08/2016.
//  Copyright © 2016 Bathilde ROCCHIA. All rights reserved.
//

import Foundation
import AFNetworking

open class AilError: NSError {
  // for compatibility purpose
  open var statusCode: Int? { return code }
  open var name: String?  { return domain }
  
  public override init(domain: String, code: Int, userInfo dict: [String : Any]? = nil) {
    super.init(domain: domain, code: code, userInfo: dict)
    
  }
  
  convenience init(_ domain: String, _ code: Int) {
    self.init(domain: domain, code: code, userInfo: nil)
  }

  convenience init(_ domain: String) {
    self.init(domain: domain, code: 0, userInfo: nil)
  }

  convenience init(_ code: Int) {
    self.init(domain: "AilError", code: code, userInfo: nil)
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  

  static open var badRequest = AilError(400)
  static open var unauthorized = AilError(401)
  static open var paymentRequired = AilError(402)
  static open var forbidden = AilError(403)
  static open var notFound = AilError(404)
  static open var falseMethodType = AilError(405)
  static open var requestTimeout = AilError(408)
  static open var conflict = AilError(409)
  
  static open var outOfService = AilError(500)
  static open var serverNotReachable = AilError(3840)
  
  static open var noNetwork = AilError(1)
  static open var jsonNotValid = AilError(2)
  static open var unknown = AilError(3)
  static open var errorLoading = AilError(4)
  static open var invalidDataEncoding = AilError(5)
  static open var invalidParameters = AilError(6)
  static open var noError = AilError(7)
  static open var timeOut = AilError(8)
  static open var emailNotAvailable = AilError(9)
  static open var notConnected = AilError(10)
  
  static open let allValues = [badRequest, unauthorized, paymentRequired, forbidden, notFound, falseMethodType, requestTimeout, conflict, outOfService, serverNotReachable]
}

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

open class AilNetworkingCancellableTask {
  var currentTask: URLSessionDataTask
  
  init(task: URLSessionDataTask) {
    self.currentTask = task
  }
  
  open func cancelTask() {
    currentTask.cancel()
  }
}

open class AilNetworking {
  var reachability: AFNetworkReachabilityManager?
  private var debugMode: Bool
  private var timeoutInterval: Double
  
  public init(debugMode: Bool = false, timeoutInterval: Double = 30) {
    self.debugMode = debugMode
    self.timeoutInterval = timeoutInterval
  }
  
  public func performBackgroundFetchWithCompletion(_ method: AilMethod = .GET, url: String, headers: [String: String]?, postParams params: [String: Any], encoding: AilParameterEncoding, result: @escaping (Any?, Error?) -> Void) -> AilNetworkingCancellableTask? {
    if (self.networkIsReachable() == true) {
      let currentTask = self.baseRequest(method, url: url, headers: headers, postParams: params, encoding: encoding, result: result)
      return currentTask != nil ? AilNetworkingCancellableTask(task: currentTask!) : nil
    }
    else {
      result(nil, AilError.noNetwork)
      return nil
    }
  }
  
  func baseRequest(_ method: AilMethod = .GET, url: String, headers: [String: String]?, postParams params: [String: Any], encoding: AilParameterEncoding, result: @escaping (Any?, Error?) -> Void) -> URLSessionDataTask? {
    
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
  
  fileprivate func fromErrorCodeToErrorType(_ errorCode: Int) -> Error? {
    for errorEnum in AilError.allValues {
      if errorCode == errorEnum.statusCode {
        return errorEnum
      }
    }
    return nil
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
        if let errorType = fromErrorCodeToErrorType(statusCode) {
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
    /*reachability?.whenReachable = { reachability in
     // this is called on a background thread, but UI updates must
     // be on the main thread, like this:
     DispatchQueue.main.async {
     if reachability.isReachableViaWiFi {
     print("Reachable via WiFi")
     } else {
     print("Reachable via Cellular")
     
     }
     }
     }
     reachability?.whenUnreachable = { reachability in
     // this is called on a background thread, but UI updates must
     // be on the main thread, like this:
     DispatchQueue.main.async {
     print("Not reachable")
     }
     }
     
     do {
     try reachability?.startNotifier()
     } catch {
     print("Unable to start notifier")
     }*/
  }
  
}


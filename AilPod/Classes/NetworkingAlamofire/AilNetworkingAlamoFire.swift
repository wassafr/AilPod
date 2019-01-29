//
//  AilNetworkingAlamoFire.swift
//  AilPod
//
//  Created by Bathilde ROCCHIA on 05/09/2018.
//

import Foundation
import Alamofire

protocol AilDataFormArrayParameter {
  func setFormDataParameters(_ formDataParameters: MultipartFormData, key: String)
}

extension AilMethod {
  var alamoFireMethod: HTTPMethod {
    switch self {
    case .GET:
      return HTTPMethod.get
    case .POST:
      return HTTPMethod.post
    case .PUT:
      return HTTPMethod.put
    case .DELETE:
      return HTTPMethod.delete
    }
  }
}

public class AilNetworkingConfigutation {
  
  let headers: [String : String]?
  var url: String
  
  public required init(headers: [String : String]? = ["Content-Type" :" application/json"], url: String) {
    self.headers = headers
    self.url = url
  }
}

public class AilNetworkingAlamoFireCancellableTask: AilNetworkingCancellableTask {
  var request: DataRequest
  
  init(request: DataRequest) {
    self.request = request
  }
  
  open func cancelTask() {
    request.cancel()
  }
}

public class AilNetworkingAlamoFire: AilNetworking, AilNetworkingFormData {

  let sessionManager: SessionManager
  
  public required init(debugMode: Bool = false, timeoutInterval: Double = 30) {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = timeoutInterval
    sessionManager = Alamofire.SessionManager(configuration: configuration)
  }
  
  public func performBackgroundFetchWithCompletion(_ method: AilMethod, _ configuration: AilNetworkingConfigutation, params: [String : Any]?, encoding: AilParameterEncoding?, result: @escaping (Any?, Error?) -> Void) -> AilNetworkingCancellableTask? {
    let parameterEncoding: ParameterEncoding = encoding == .json ? JSONEncoding.default : URLEncoding.default
    let request: DataRequest = sessionManager.request(configuration.url, method: method.alamoFireMethod, parameters: params, encoding: parameterEncoding, headers: configuration.headers)
    request.responseJSON { (response) in
      switch response.result {
      case .success:
        var error: NSError?
        if let statusCode = response.response?.statusCode,
          !(statusCode <= 200 && statusCode < 300) {
          error = AilError.getAilErrorFrom(response.result.value, statusCode)
          if error == nil {
            error = AilError.getAilErrorFrom(statusCode)
          }
        }
        result(response.result.value, error)
        break
      case .failure(let error):
        result(nil, error)
        break
      }
    }
    
    return AilNetworkingAlamoFireCancellableTask(request: request)
  }
  
  public func performBackgroundFetchFormDataWithCompletion(_ method: AilMethod = .POST, _ configuration: AilNetworkingConfigutation, params: [String : Any]?, result: @escaping (Any?, Error?) -> Void) {
    
    sessionManager.upload(multipartFormData: { (formDataParameters) in
      
      params?.filter({ (key, value) in !(value is AilDataFormFileParameter) }).forEach({ (key, value) in
        if let value = value as? AilDataFormParameter, let data = value.toData() {
          formDataParameters.append(data, withName: key)
        } else if let value = value as? AilDataFormArrayParameter {
          value.setFormDataParameters(formDataParameters, key: key)
        }
        else if value is AilDataFormFileParameter {
          // we serialize the file after everything was serialized
        }
        else {
          print("⚠️ Cannot found serializer for \(key) \(value)")
        }
        
      })
      
      params?.filter({ (key, value) in value is AilDataFormFileParameter }).forEach({ (key, value) in
        if let value = value as? AilDataFormFileParameter {
          formDataParameters.append(value.data, withName: key, fileName: value.fileName, mimeType: value.mimType)
        }
      })
      
    }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: configuration.url, method: method.alamoFireMethod, headers: configuration.headers) { (encodingResult) in
      switch encodingResult {
      case .success(let upload, _, _):
        
        upload.responseJSON { response in
          var error: Error?
          if let statusCode = response.response?.statusCode,
            !(statusCode <= 200 && statusCode < 300) {
            error = AilError.getAilErrorFrom(response.result.value, statusCode)
            if error == nil {
              error = AilError.getAilErrorFrom(statusCode)
            }
          }
          result(response.result.value, error)
        }
        break
      case .failure(let error):
        result(nil, error)
        break
      }
    }
  }
}























//
//  AilError.swift
//  AFNetworking
//
//  Created by Bathilde ROCCHIA on 05/09/2018.
//

import Foundation

public class AilError: NSError {
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
  
  
  static let subErrorsKey = "subErrorsKey-AilPod"
  open var subErrors: [String: AilError]? {
    return self.userInfo[AilError.subErrorsKey] as? [String: AilError]
  }
  
  static public var badRequest = AilError(400)
  static public var unauthorized = AilError(401)
  static public var paymentRequired = AilError(402)
  static public var forbidden = AilError(403)
  static public var notFound = AilError(404)
  static public var falseMethodType = AilError(405)
  static public var requestTimeout = AilError(408)
  static public var conflict = AilError(409)
  
  static public var outOfService = AilError(500)
  static public var serverNotReachable = AilError(3840)
  
  static public var noNetwork = AilError(1)
  static public var jsonNotValid = AilError(2)
  static public var unknown = AilError(3)
  static public var errorLoading = AilError(4)
  static public var invalidDataEncoding = AilError(5)
  static public var invalidParameters = AilError(6)
  static public var noError = AilError(7)
  static public var timeOut = AilError(8)
  static public var emailNotAvailable = AilError(9)
  static public var notConnected = AilError(10)
  
  static public let allValues = [badRequest, unauthorized, paymentRequired, forbidden, notFound, falseMethodType, requestTimeout, conflict, outOfService, serverNotReachable]
  
  static func getAilErrorFrom(_ statusCode: Int) -> AilError? {
    for errorEnum in AilError.allValues {
      if statusCode == errorEnum.statusCode {
        return errorEnum
      }
    }
    return nil
  }
  
  static func getAilErrorFrom(_ response: Any?, _ statusCode: Int) -> AilError? {
    
    if let json = response as? [String: Any] {
      if let message = json["message"] as? String {
        return AilError(domain: message, code: statusCode, userInfo: [NSLocalizedDescriptionKey: message])
      }
      else if let errors = json["errors"] as? [String: Any] {
        if let code = errors["code"] as? Int, let message = errors["message"] as? String {
          return AilError(domain: "AilError", code: statusCode, userInfo: [AilError.subErrorsKey: AilError(domain: message, code: code, userInfo: [NSLocalizedDescriptionKey: message])])
        }
        else {
          var subErrors = [String: AilError]()
          errors.forEach({
            print($0.key, $0.value) 
            if let values = $0.value as? [String: Any],
              let code = values["code"] as? Int, let message = values["message"] as? String {
              subErrors[$0.key] = AilError(domain: message, code: code, userInfo: [NSLocalizedDescriptionKey: message])
            }
          })
          return AilError(domain: "AilError", code: statusCode, userInfo: [AilError.subErrorsKey: subErrors])
        }
      }
    }
    return nil
  }
}






//
//  String.swift
//  AilPod
//
//  Created by Wassa Team on 02/08/2016.
//  Copyright © 2016 Wassa Team. All rights reserved.
//

import Foundation

public enum PasswordStrengh {
  case low
  case medium
  case high
}

public extension String {
  public func localized() -> String {
    return NSLocalizedString(self, comment: "")
  }

  public func isEmailFormat() -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"

    let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)

    let result = predicate.evaluate(with: self)

    return result
  }

  public func getPasswordStrengh() -> PasswordStrengh {
    let count = self.count
    let regex = ".*[A-Za-z]+.*[0-9]+.*|.*[0-9]+.*[A-Za-z]+.*"
    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)

    if count >= 8 && predicate.evaluate(with: self) {
      return .high
    }
    else if count >= 6 {
      return .medium
    }
    return .low
  }
}

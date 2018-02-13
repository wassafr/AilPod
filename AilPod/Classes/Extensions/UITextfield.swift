//
//  UITextfield.swift
//  AilPod
//
//  Created by Wassa Team on 05/09/2016.
//  Copyright © 2016 Wassa Team. All rights reserved.
//

import Foundation

extension UITextField {
  @IBInspectable public var placeHolderColor: UIColor? {
    get {
      return self.placeHolderColor
    }
    set {
      self.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSAttributedStringKey.foregroundColor: newValue!])
    }
  }
}

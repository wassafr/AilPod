//
//  UITextfield.swift
//  AilPod
//
//  Created by Bathilde ROCCHIA on 05/09/2016.
//  Copyright © 2016 Bathilde ROCCHIA. All rights reserved.
//

import Foundation

extension UITextField {
  @IBInspectable public var placeHolderColor: UIColor? {
    get {
      return self.placeHolderColor
    }
    set {
      self.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSAttributedString.Key.foregroundColor: newValue!])
    }
  }
}

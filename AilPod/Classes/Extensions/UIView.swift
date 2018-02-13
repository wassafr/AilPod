//
//  UIView.swift
//  AilPod
//
//  Created by Wassa Team on 30/08/2016.
//  Copyright © 2016 Wassa Team. All rights reserved.
//

import Foundation

extension UIView {
  @IBInspectable public var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
        layer.cornerRadius = newValue
        self.clipsToBounds = newValue > 0
    }
  }
  
  @IBInspectable public var borderWidth: Float {
    get {
      return Float(layer.borderWidth)
    }
    set {
      layer.borderWidth = CGFloat(newValue)
    }
  }
  
  @IBInspectable public var borderColor: UIColor {
    get {
      return layer.borderColor != nil ? UIColor(cgColor: layer.borderColor!) : UIColor()
    }
    set {
      layer.borderColor = newValue.cgColor
    }
  }
}

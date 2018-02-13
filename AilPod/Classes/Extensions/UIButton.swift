//
//  UIButton.swift
//  AilPod
//
//  Created by Wassa Team on 20/09/2016.
//
//

import Foundation

extension UIButton {
  @IBInspectable public var imageTopInset : CGFloat {
    get {
      return self.imageEdgeInsets.top
    }
    set {
      self.imageEdgeInsets.top = newValue
    }
  }

  @IBInspectable public var imageBottomInset : CGFloat {
    get {
      return self.imageEdgeInsets.bottom
    }
    set {
      self.imageEdgeInsets.bottom = newValue
    }
  }

  @IBInspectable public var imageLeftInset : CGFloat {
    get {
      return self.imageEdgeInsets.left
    }
    set {
      self.imageEdgeInsets.left = newValue
    }
  }

  @IBInspectable public var imageRightInset : CGFloat {
    get {
      return self.imageEdgeInsets.right
    }
    set {
      self.imageEdgeInsets.right = newValue
    }
  }

}

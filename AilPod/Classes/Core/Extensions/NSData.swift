//
//  UIImage.swift
//  AilPod
//
//  Created by Bathilde ROCCHIA on 18/08/2016.
//  Copyright © 2016 Bathilde ROCCHIA. All rights reserved.
//

import Foundation
import UIKit

public extension Data {
  public enum ContentType: String {
    case JPG = "image/jpeg"
    case PNG = "image/png"
    case GIF = "image/gif"
    case TIFF = "image/tiff"
  }
  
  public func contentForImageData() -> ContentType? {
    var c = [UInt8](repeating: 0, count: 1)
    (self as NSData).getBytes(&c, length: 1)
    
    switch (c[0]) {
    case 0xFF:
      return ContentType.JPG
    case 0x89:
      return ContentType.PNG
    case 0x47:
      return ContentType.GIF
    case 0x49, 0x4D :
      return ContentType.TIFF
    default:
      return nil
    }
  }
}

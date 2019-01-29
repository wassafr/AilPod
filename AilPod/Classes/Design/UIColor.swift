//
//  UIColor.swift
//  AilPod
//
//  Created by Bathilde ROCCHIA on 30/08/2016.
//  Copyright © 2016 Bathilde ROCCHIA. All rights reserved.
//

import Foundation

extension UIColor {
  static fileprivate func intFromHexa(_ hexa: String) -> UInt32 {
    var hexaInt: UInt32 = 0
    let scanner = Scanner(string: hexa)
    scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
    scanner.scanHexInt32(&hexaInt)
    return hexaInt
  }

  public static func colorFromHexa(_ hexa: String, alpha: Double?) -> UIColor {
    let hexaInt: UInt32 = intFromHexa(hexa)
    return UIColor(
      red: ((CGFloat)((hexaInt & 0xFF0000) >> 16)) / 255,
      green: ((CGFloat)((hexaInt & 0xFF00) >> 8)) / 255,
      blue: ((CGFloat)(hexaInt & 0xFF)) / 255,
      alpha: CGFloat(alpha != nil ? alpha! : 1.0))
  }
}

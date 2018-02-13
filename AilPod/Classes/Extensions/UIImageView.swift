//
//  UIImage.swift
//  AilPod
//
//  Created by Wassa Team on 02/08/2016.
//  Copyright © 2016 Wassa Team. All rights reserved.
//

import Foundation

public extension UIImageView {
  public func loadFrom64Base(_ base64: String?) {
    if base64 != nil && !(base64!.isEmpty) {
      let dataDecoded = Data(base64Encoded: base64!, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
      self.image = UIImage(data: dataDecoded)
    }
  }
}

public extension UIImage {
  static public func resizeImage(_ pickedImage: UIImage, maxSize: Double) -> UIImage {
    
    if Double(pickedImage.size.height) > maxSize || Double(pickedImage.size.width) > maxSize {
      
      let scaleFactor = (pickedImage.size.width > pickedImage.size.height) ? maxSize / Double(pickedImage.size.width): maxSize / Double(pickedImage.size.height);
      
      let newSize: CGSize = CGSize(width: Double(pickedImage.size.width) * scaleFactor, height: Double(pickedImage.size.height) * scaleFactor)
      
      UIGraphicsBeginImageContext(newSize);
      pickedImage.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
      let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext();
      
      return resizedImage!
    }
    return pickedImage
  }
}

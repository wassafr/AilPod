//
//  ToggleButton.swift
//  AilPod
//
//  Created by Bathilde ROCCHIA on 19/09/2016.
//
//

import Foundation

class ToggleButton: UIButton {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    self.addTarget(self, action: #selector(toggleButton), for: UIControlEvents.touchUpInside)
  }
  
  @IBAction func toggleButton() {
    self.isSelected = !self.isSelected
  }
}

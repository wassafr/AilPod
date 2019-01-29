//
//  AilDatePickerViewController.swift
//  iPorta
//
//  Created by Bathilde ROCCHIA on 23/11/2018.
//  Copyright © 2018 Wassa. All rights reserved.
//

import Foundation

class AilDatePickerViewController: UIViewController {
  
  class func displayPicker(_ sender: UIViewController, _ mode: UIDatePicker.Mode, _ selectedValue: Date? = nil, _ completion: @escaping (Date?) -> Void ) {
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let picker = AilDatePickerViewController(nibName: "AilDatePickerView", bundle: nil)
    picker.mode = mode
    picker.selectedValue = selectedValue
    
    alertController.setValue(picker, forKey: "contentViewController")
    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
      completion(picker.pickerView.date)
    }))
    
    sender.present(alertController, animated: true, completion: nil)
  }
  
  var selectedValue: Date?
  @IBOutlet weak var pickerView: UIDatePicker!
  var mode: UIDatePicker.Mode?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.pickerView.datePickerMode = mode ?? .dateAndTime
    if let selectedValue = selectedValue {
      self.pickerView.setDate(selectedValue, animated: true)
    }
  }
  
}


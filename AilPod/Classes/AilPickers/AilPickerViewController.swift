//
//  AilPickerViewController.swift
//  iPorta
//
//  Created by Bathilde ROCCHIA on 22/11/2018.
//  Copyright © 2018 Wassa. All rights reserved.
//

import Foundation

class AilPickerViewController: UIViewController {
  class func displayPicker(_ sender: UIViewController, _ data: [[String]], _ completion: @escaping (Int?, String?) -> Void ) {
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let picker = AilPickerViewController(nibName: "AilPickerView", bundle: nil)
    picker.data = data
    
    alertController.setValue(picker, forKey: "contentViewController")
    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
      completion(picker.selectedComponent, picker.selectedValue)
    }))
    
    sender.present(alertController, animated: true, completion: nil)
  }
  
  var selectedComponent: Int?
  var selectedValue: String?
  var data: [[String]]?
  @IBOutlet weak var pickerView: UIPickerView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    pickerView.dataSource = self
    pickerView.delegate = self
  }
  
}

extension AilPickerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return data?.count ?? 0
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return data?[component].count ?? 0
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return data?[component][row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    self.selectedValue = data?[component][row]
    self.selectedComponent = component
  }
}

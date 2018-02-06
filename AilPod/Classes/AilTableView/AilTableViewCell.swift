//
//  AilTableViewCell.swift
//  Pods
//
//  Created by Julien Brusseaux on 05/05/2017.
//
//

import UIKit

/**
 Protocol implemented by every object displayed by an instance of AilTableviewController.
 */
public protocol AilCellDataSource {
  /**
   The identifier of the cell to use for the object.
   ## Note
   A cell with this identifier must be registered in the tableview. You can also register cells from nib files using the identifiers you return here.
   */
  var cellReuseIdentifier: String? { get }
}

/**
 Protocol implemented by subclasses of UITableviewCell to be displayed in an AilTableviewController tableview.
 */
public protocol AilTableViewCell {
  /**
   Set the content of your cell in this method.
   - parameter source: the object displayed by the cell
   - parameter indexPath: the indexPath of the cell
   */
  func loadData(_ source: AilCellDataSource, indexPath: IndexPath)
}

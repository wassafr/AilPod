//
//  AilCollectionViewController.swift
//  Pods
//
//  Created by Wassa Team on 03/11/2016.
//
//

import UIKit

open class AilCollectionViewController: UICollectionViewController {
  
  // this is the real displayed data source, can be filtered
  fileprivate var filteredDataSource: [[AilCellDataSource]] = []
  
  /** The filter applied to the content of the collectionview */
  public var filter: ((AilCellDataSource) -> Bool)?{
    didSet {
      loadMultiSectionData(customDataSource)
    }
  }
  
  // datasource provided by the app
  private var customDataSource : [[AilCellDataSource]] = []
  
  private var refreshControl : UIRefreshControl?
  
  public var didSelectItem : ((IndexPath, AilCellDataSource) -> ())?
  
  /**
   Content loading function. If no datasource is specified this method will be called by reloadData().
   Usefull for asynchronous content loading.
   */
  public var loadingFunction : (( @escaping ([[AilCellDataSource]]) -> Void) -> Void)?
  
  public var displaysRefreshControl : Bool {
    get {
      return self.refreshControl != nil
    }
    set {
      if newValue {
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        self.collectionView?.addSubview(refreshControl!)
      } else {
        self.refreshControl?.removeFromSuperview()
        self.refreshControl = nil
      }
    }
  }
  
  open override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.reloadData()
  }
  
  override open func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  public func loadMultiSectionData(_ customDataSource: [[AilCellDataSource]]) {
    self.customDataSource = customDataSource
    
    filterData()
    
    updateCustomLayoutSizes()
    
    collectionView?.reloadData()
  }
  
  func updateCustomLayoutSizes() {
    if let layout = self.collectionView?.collectionViewLayout as? AilFlowLayout {
      for section in 0 ..< customDataSource.count {
        for row in 0 ..< customDataSource[section].count {
          let indexPath = IndexPath(row: row, section: section)
          layout.setSize(size: self.size(for: customDataSource[section][row], at: indexPath), for: indexPath)
        }
      }
    } else if let layout = self.collectionView?.collectionViewLayout as? AilCenteredLayout {
      layout.cellsCount = customDataSource.first!.count
      layout.setCellSize(size: self.size(for: nil, at: nil))
    }
  }
  
  public func loadData(_ customDataSource: [AilCellDataSource]) {
    self.loadMultiSectionData([customDataSource])
  }
  
  
  @objc public func reloadData() {
    let doneLoading : (_ values: [[AilCellDataSource]]) -> Void = { values in
      self.loadMultiSectionData(values)
      self.refreshControl?.endRefreshing()
    }
    if let loadingFunction = loadingFunction {
      loadingFunction({ values in
        doneLoading(values)
      })
    } else {
      doneLoading(customDataSource)
    }
  }
  public func getItems() -> [[AilCellDataSource]]? {
    return customDataSource
  }
  
  /**
   - returns: the objects of each section concatenated.
   */
  public func getItemList() -> [AilCellDataSource]? {
    var a : [AilCellDataSource] = []
    customDataSource.forEach({a.append(contentsOf: $0)})
    return a
  }
  
  /**
   Filters the datasource according to the provided filter and removes empty sections if allowEmptySections is false
   */
  func filterData() {
    filteredDataSource = []
    
    if let filter = filter {
      customDataSource.forEach( {
        var section : [AilCellDataSource] = []
        $0.forEach({ (obj) in
          if filter(obj) {
            section.append(obj)
          }
        })
        filteredDataSource.append(section)
      })
    } else {
      filteredDataSource = customDataSource
    }
  }
  
  open func size(for dataSource:AilCellDataSource?, at indexPath: IndexPath?) -> CGSize {
    return CGSize(width: 50, height: 50)
  }
  
  override open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    didSelectItem?(indexPath, filteredDataSource[indexPath.section][indexPath.row])
  }
  
  override open func numberOfSections(in collectionView: UICollectionView) -> Int {
    return filteredDataSource.count
  }
  
  
  override open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return filteredDataSource[section].count
  }
  
  override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let object = filteredDataSource[indexPath.section][indexPath.row]
    
    var identifier = object.cellReuseIdentifier
    if identifier == nil {
      identifier = String(describing: type(of: object))
    }
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier!, for: indexPath)
    
    if let c = cell as? AilCollectionCell {
      c.loadData(object, indexPath: indexPath)
    }
    return cell
  }
}

public protocol AilCollectionCell {
  func loadData(_ source: AilCellDataSource?, indexPath: IndexPath)
}

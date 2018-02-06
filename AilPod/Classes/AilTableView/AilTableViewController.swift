//
//  AilTableViewController.swift
//  Pods
//
//  Created by Julien Brusseaux on 10/10/2016.
//
//

import UIKit

open class AilTableViewController: UITableViewController {
  
  /** The view displayed when the tableview contains no cells */
  @IBOutlet public var placeholder : UIView?
  
  /** datasource provided by the app */
  fileprivate var customDataSource : [[AilCellDataSource]] = []
  fileprivate var sectionTitles : [String]?
  
  /** this is the real displayed data source, can be filtered */
  fileprivate var filteredDataSource: [[AilCellDataSource]] = []
  fileprivate var filteredSectionTitles : [String]?
  
  /** The filter applied to the content of the tableview */
  public var filter: ((AilCellDataSource) -> Bool)?{
    didSet {
      loadData(customDataSource, sectionTitles)
    }
  }
  
  fileprivate var cellIdentifiers : [String:String] = [:]
  
  /** The callback of the cell selection */
  public var didSelectRow : ((IndexPath, AilCellDataSource) -> ())?
  
  /**
   Content loading function. If no datasource is specified this method will be called by reloadData().
   Usefull for asynchronous content loading.
   */
  public var loadingFunction : (( @escaping ([[AilCellDataSource]], [String]?) -> Void) -> Void)?
  
  /** Automatically sets the refreshControl of the tableview and calls reloadData(). */
  public var displaysRefreshControl : Bool {
    get {
      return self.refreshControl != nil
    }
    set {
      if newValue {
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        self.tableView.backgroundView = refreshControl
      } else {
        self.refreshControl = nil
        self.tableView.backgroundView = nil
      }
    }
  }
  
  /** Displays/Hides headers for empty sections */
  public var allowEmptySections: Bool = false {
    didSet {
      loadData(customDataSource, sectionTitles)
    }
  }
  
  open override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.reloadData()
  }
  
  /** Toggles the placeholder view when appropriate. */
  func checkForEmptyTableView() {
    if numberOfSections(in: tableView) == 0 {
      placeholder?.isHidden = false
      tableView.isHidden = true
    } else {
      placeholder?.isHidden = true
      tableView.isHidden = false
    }
  }
  
  //MARK: Loading the tableView content
  
  /**
   - parameter customDataSource: the sections of objects to be displayed
   - parameter sectionTitles: the titles of the tableview's sections
   */
  public func loadData(_ customDataSource: [[AilCellDataSource]], _ sectionTitles: [String]?) {
    self.customDataSource = customDataSource
    self.sectionTitles = sectionTitles
    
    filterData()
    
    if self.isViewLoaded {
      tableView.reloadData()
    }
    checkForEmptyTableView()
  }
  
  /**
   Updates a section of the tableview without reloading the whole data source
   - parameter index: the index of the section to update.
   - parameter content: the new content of the section. Can have a different size than the original section.
   - parameter refreshIndexes: the indexes of the old rows you wish to refresh.
   - parameter animated: indicates if the update should be animated or instant.
   */
  open func updateSection(index: Int,
                          content: [AilCellDataSource],
                          refreshIndexes: [IndexPath],
                          animated: Bool = true) {
    if filteredDataSource.count > index {
      let section = filteredDataSource[index]
      var indexPathsToRemove: [IndexPath]?
      var indexPathsToInsert: [IndexPath]?
      
      if content.count < section.count {
        indexPathsToRemove = (content.count ..< section.count).map({ IndexPath(row: $0, section: index) })
      } else if content.count > section.count {
        indexPathsToInsert = (section.count ..< content.count).map({ IndexPath(row: $0, section: index) })
      }
      
      filteredDataSource.replaceSubrange((index...index), with: [content])
      
      if let indexPathsToRemove = indexPathsToRemove {
        tableView.deleteRows(at: indexPathsToRemove, with: animated ? .automatic : .none)
      }
      if let indexPathsToInsert = indexPathsToInsert {
        tableView.insertRows(at: indexPathsToInsert, with: animated ? .automatic : .none)
      }
      tableView.reloadRows(at: refreshIndexes, with: animated ? .automatic : .none)
    }
  }
  
  /**
   Shortcut method for loadData(_ customDataSource: [[AilCellDataSource]], _ sectionTitles: [String]?) in case of a single section tableview.
   - parameter customDataSource: the content of the section.
   */
  public func loadData(_ customDataSource: [AilCellDataSource]) {
    loadData([customDataSource], nil)
  }
  
  @objc public func reloadData() {
    let doneLoading : (_ values: [[AilCellDataSource]], _ titles : [String]?) -> Void = { values, titles in
      self.loadData(values, titles)
      self.refreshControl?.endRefreshing()
    }
    if let loadingFunction = loadingFunction {
      loadingFunction({ values, titles in
        doneLoading(values, titles)
      })
    } else {
      doneLoading(customDataSource,sectionTitles)
    }
  }
  
  /**
   - returns: the section titles of the tableview
   */
  public func getSectionTitles() -> [String]? {
    return filteredSectionTitles
  }
  
  /**
   - returns: the content of the sections of the tableview.
   */
  public func getItems() -> [[AilCellDataSource]]? {
    return filteredDataSource
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
    filteredSectionTitles = sectionTitles
    
    if !allowEmptySections {
      if let sectionTitles = sectionTitles {
        let cleared = (0..<filteredDataSource.count)
          .map({ (filteredDataSource[$0],sectionTitles[$0]) })
          .filter({ $0.0.count > 0 })
        filteredDataSource = cleared.map({$0.0})
        filteredSectionTitles = cleared.map({$0.1})
      } else {
        filteredDataSource = filteredDataSource.filter({ $0.count > 0 })
        filteredSectionTitles = nil
      }
    }
  }
  
  public func insert(item: AilCellDataSource, at indexPath: IndexPath, animated: Bool = true) {
    if filteredDataSource.count <= indexPath.section {
      filteredDataSource.append([])
      tableView.insertSections([indexPath.section], with: animated ? .automatic : .none)
    }
    filteredDataSource[indexPath.section].insert(item, at: indexPath.row)
    tableView.insertRows(at: [indexPath], with: animated ? .automatic : .none)
    checkForEmptyTableView()
  }
  
  public func deleteItem(at indexPath: IndexPath, animated: Bool = true) {
    filteredDataSource[indexPath.section].remove(at: indexPath.row)
    if filteredDataSource[indexPath.section].count == 0 {
      filteredDataSource.remove(at: indexPath.section)
      tableView.deleteSections([indexPath.section], with: animated ? .automatic : .none)
    } else {
      tableView.deleteRows(at: [indexPath], with: animated ? .automatic : .none)
    }
    checkForEmptyTableView()
  }
  
  override open func numberOfSections(in tableView: UITableView) -> Int {
    return filteredDataSource.count
  }
  
  override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredDataSource[section].count
  }
  
  override open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return filteredSectionTitles != nil && filteredSectionTitles!.count > section ? filteredSectionTitles![section] : nil
  }
  
  
  override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let object = filteredDataSource[indexPath.section][indexPath.row]
    
    var identifier = object.cellReuseIdentifier
    if identifier == nil {
      identifier = String(describing: type(of: object))
    }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: identifier!, for: indexPath)
    
    if let c = cell as? AilTableViewCell {
      c.loadData(object, indexPath: indexPath)
    } else {
      cell.textLabel?.text = String(describing: object)
    }
    
    return cell
  }
  
  override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if indexPath.section < filteredDataSource.count &&
      indexPath.row < filteredDataSource[indexPath.section].count {
          let object = filteredDataSource[indexPath.section][indexPath.row]
          didSelectRow?(indexPath, object)
      }
  }
}

//
//  AilFlowLayout.swift
//  Pods
//
//  Created by Wassa Team on 03/11/2016.
//
//

import UIKit

public enum FlowLayoutDirection {
  case Vertical
  case Horizontal
}

open class AilFlowLayout: UICollectionViewLayout {
  
  public var direction : FlowLayoutDirection = .Vertical
  
  public var spacing : CGFloat = 5
  
  public var verticalFlowColumns : Int = 2
  public var horizontalFlowRows : Int = 3
  
  fileprivate var sizes : [IndexPath:CGSize] = [:]
  fileprivate var attributes : [IndexPath:UICollectionViewLayoutAttributes] = [:]
  
  open func setSize(size: CGSize, for indexPath: IndexPath) {
    sizes[indexPath] = size
  }
  
  override open var collectionViewContentSize: CGSize {
    get {
      
      if collectionView == nil || sizes.keys.count == 0 {
        return CGSize()
      }
      
      var width : CGFloat = 0
      var height : CGFloat = 0
      
      attributes = [:]
      
      let sortedIndexPaths = sizes.keys.sorted()
      
      let halfSpace = spacing*0.5
      
      switch direction {
      case .Vertical:
        width = collectionView!.bounds.size.width
        
        let columnWidth = width/CGFloat(verticalFlowColumns)
        
        class Column {
          var x: CGFloat
          var bottom: CGFloat
          
          init(x: CGFloat, bottom: CGFloat) {
            self.x = x
            self.bottom = bottom
          }
        }
        
        let columns: [Column] = (0 ..< verticalFlowColumns).map({
          Column(x:CGFloat($0)*columnWidth, bottom:0)
        })
        
        for indexPath in sortedIndexPaths {
          let cellSize = CGSize(width: columnWidth-spacing, height: sizes[indexPath]!.height)
          let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
          
          let column = columns.sorted(by: { (c1, c2) -> Bool in
            return c1.bottom < c2.bottom
          }).first!
          
          attr.frame = CGRect(origin: CGPoint(x: column.x+halfSpace, y: column.bottom+halfSpace), size: cellSize)
          
          column.bottom += cellSize.height+spacing
          attributes[indexPath] = attr
        }
        height = columns.sorted(by: { (c1, c2) -> Bool in
          return c1.bottom < c2.bottom
        }).last!.bottom + halfSpace
        
      case .Horizontal:
        height = collectionView!.bounds.size.height
        
        let rowHeight = height/CGFloat(horizontalFlowRows)
        
        class Row {
          var y: CGFloat
          var trailing: CGFloat
          
          init(y: CGFloat, trailing: CGFloat) {
            self.y = y
            self.trailing = trailing
          }
        }
        
        let rows: [Row] = (0 ..< horizontalFlowRows).map({
          Row(y:CGFloat($0)*rowHeight, trailing:0)
        })
        
        for indexPath in sortedIndexPaths {
          let cellSize = CGSize(width: sizes[indexPath]!.width, height: rowHeight-spacing)
          let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
          
          let row = rows.sorted(by: { (r1, r2) -> Bool in
            return r1.trailing < r2.trailing
          }).first!
          
          attr.frame = CGRect(origin: CGPoint(x: row.trailing+halfSpace, y: row.y+halfSpace), size: cellSize)
          
          row.trailing += cellSize.width+spacing
          attributes[indexPath] = attr
        }
        
        
        width = rows.sorted(by: { (r1, r2) -> Bool in
          return r1.trailing < r2.trailing
        }).last!.trailing + halfSpace
      }
      
      return CGSize(width: width, height: height)
    }
  }
  
  open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    if super.layoutAttributesForItem(at: indexPath) != nil {
      return attributes[indexPath]
    }
    return nil
  }
  
  open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    return Array(attributes.values)
  }
}

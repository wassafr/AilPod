//
//  AilCenteredLayout.swift
//  AilPod
//
//  Created by Julien Brusseaux on 18/11/2016.
//
//

import UIKit

public enum CenteredLayoutDirection {
  case Vertical
  case Horizontal
  case Both
}

@IBDesignable
open class AilCenteredLayout: UICollectionViewFlowLayout {
  public var centerDirection : CenteredLayoutDirection = .Horizontal
  @IBInspectable public var spacing : CGFloat = 5
  
  public var cellsCount : Int = 0
  
  fileprivate var cellSize : CGSize?
  fileprivate var attributes : [IndexPath:UICollectionViewLayoutAttributes] = [:]
  
  public func setCellSize(size: CGSize) {
    cellSize = size
  }
  
  
  override open var collectionViewContentSize: CGSize {
    get {
      
      if collectionView == nil || cellSize == nil {
        return CGSize()
      }
      
      let collectionViewSize = self.collectionView!.bounds.size
      
      attributes = [:]
      
      //let sortedIndexPaths = sizes.keys.sorted()
      
      let halfSpace = spacing*0.5
      
      var maxHCells = Int(collectionViewSize.width/(cellSize!.width+spacing))
      var maxVCells = Int(collectionViewSize.height/(cellSize!.height+spacing))
      
      if maxHCells < 1 {
        maxHCells = 1
      }
      
      if maxVCells < 1 {
        maxVCells = 1
      }
      
      var cDirection = centerDirection
      
      
      if cellsCount > maxHCells*maxVCells {
        switch centerDirection {
        case .Horizontal:
          if self.scrollDirection == .horizontal {
            cDirection = .Vertical
            maxHCells = Int(ceil(Float(cellsCount) / Float(maxVCells)))
          }
        case .Vertical:
          if self.scrollDirection == .horizontal {
            cDirection = .Horizontal
            maxVCells = cellsCount / maxHCells
          }
        case .Both:
          cDirection = .Horizontal
        }
      }
      
      var generatedIndexes = (0 ..< cellsCount).map({IndexPath(row: $0, section: 0)})
      
      switch cDirection {
        
      case .Vertical:
        
        let columnHeight = CGFloat(ceilf(Float(cellsCount)/Float(maxHCells))) * (cellSize!.height+spacing) - spacing
        var y = (collectionViewSize.height-columnHeight)*0.5
        
        while generatedIndexes.count > 0 {
          
          //Select the elements of the line
          var line : [IndexPath] = []
          for _ in 0 ..< maxHCells {
            if generatedIndexes.count == 0 {
              break
            }
            line.append(generatedIndexes.remove(at: 0))
          }
          
          //Compute the sizes on the current line
          
          var x = spacing
          
          for ip in line {
            let attr = UICollectionViewLayoutAttributes(forCellWith: ip)
            attr.frame = CGRect(origin: CGPoint(x: x, y:y), size: cellSize!)
            attributes[ip] = attr
            x += cellSize!.width+spacing
          }
          y += cellSize!.height+spacing
        }
        return CGSize(width: CGFloat(maxHCells)*(cellSize!.width+spacing), height: y)
        
      case .Horizontal:
        var height = halfSpace-1
        var width : CGFloat = 0.0
        while generatedIndexes.count > 0 {
          
          //Select the elements of the line
          var line : [IndexPath] = []
          for _ in 0 ..< maxHCells {
            if generatedIndexes.count == 0 {
              break
            }
            line.append(generatedIndexes.remove(at: 0))
          }
          
          //Compute the sizes on the current line
          let lineWidth = CGFloat(line.count) * (cellSize!.width+spacing) - spacing
          var x = (collectionViewSize.width-lineWidth)*0.5
          if x < 0 {
            x = 0
          }
          
          width = x + lineWidth
          
          for ip in line {
            let attr = UICollectionViewLayoutAttributes(forCellWith: ip)
            attr.frame = CGRect(origin: CGPoint(x: x, y:height), size: cellSize!)
            attributes[ip] = attr
            x += cellSize!.width+spacing
          }
          height += cellSize!.height+spacing
        }
        return CGSize(width: width, height: height)
        
      case .Both:
        return CGSize()
        
      }
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

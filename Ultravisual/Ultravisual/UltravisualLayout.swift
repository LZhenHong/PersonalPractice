/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

// The heights are declared as constants outside of the class so they can be easily referenced elsewhere 
struct UltravisualLayoutConstants {
  struct Cell {
    // The height of the non-featured cell 
    static let standardHeight: CGFloat = 100
    // The height of the first visible cell 
    static let featuredHeight: CGFloat = 280
  }
}

// MARK: Properties and Variables

class UltravisualLayout: UICollectionViewLayout {
  // The amount the user needs to scroll before the featured cell changes 
  let dragOffset: CGFloat = 180.0
  
  var cache: [UICollectionViewLayoutAttributes] = []
  
  // Returns the item index of the currently featured cell 
  var featuredItemIndex: Int {
      // Use max to make sure the featureItemIndex is never < 0 
      return max(0, Int(collectionView!.contentOffset.y / dragOffset))
  }
  
  // Returns a value between 0 and 1 that represents how close the next cell is to becoming the featured cell 
  var nextItemPercentageOffset: CGFloat {
      return (collectionView!.contentOffset.y / dragOffset) - CGFloat(featuredItemIndex)
  }
  
  // Returns the width of the collection view 
  var width: CGFloat {
      return collectionView!.bounds.width
  }
  
  // Returns the height of the collection view 
  var height: CGFloat {
      return collectionView!.bounds.height
  }
  
  // Returns the number of items in the collection view 
  var numberOfItems: Int {
      return collectionView!.numberOfItems(inSection: 0)
  }
}

// MARK: UICollectionViewLayout

extension UltravisualLayout {
  // Return the size of all the content in the collection view 
  override var collectionViewContentSize : CGSize {
    let contentHeight = (CGFloat(numberOfItems) * dragOffset) + (height - dragOffset)
    return CGSize(width: width, height: contentHeight)
  }
  
  override func prepare() {
    cache.removeAll(keepingCapacity: false)
    
    let standardHeight = UltravisualLayoutConstants.Cell.standardHeight
    let featureHeight = UltravisualLayoutConstants.Cell.featuredHeight
    
    var frame = CGRect.zero
    var y: CGFloat = 0
    
    for item in 0..<numberOfItems {
      let indexPath = IndexPath(item: item, section: 0)
      let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
      
      attributes.zIndex = item
      var height = standardHeight
      if indexPath.item == featuredItemIndex {
        let yOffset = standardHeight * nextItemPercentageOffset
        y = collectionView!.contentOffset.y - yOffset
        height = featureHeight
      } else if indexPath.item == (featuredItemIndex + 1) && indexPath.item != numberOfItems {
        let maxY = y + standardHeight
        height = standardHeight + max((featureHeight - standardHeight) * nextItemPercentageOffset, 0)
        y = maxY - height
      }
      
      frame = CGRect(x: 0, y: y, width: width, height: height)
      attributes.frame = frame
      cache.append(attributes)
      y = frame.maxY
    }
  }
  
  // Return all attributes in the cache whose frame intersects with the rect passed to the method 
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var layoutAttributes: [UICollectionViewLayoutAttributes] = []
    for attributes in cache {
      if attributes.frame.intersects(rect) {
        layoutAttributes.append(attributes)
      }
    }
    return layoutAttributes
  }
  
  // Return true so that the layout is continuously invalidated as the user scrolls 
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }
  
  override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
    let itemIndex = round(proposedContentOffset.y / dragOffset)
    let yOffset = itemIndex * dragOffset
    return CGPoint(x: 0, y: yOffset)
  }
}

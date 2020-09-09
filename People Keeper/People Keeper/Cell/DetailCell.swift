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

/* Abstract:
 Provides a simple collection view cell that can display a feature/
 topic image and/or description. This is used in the `PersonDetailViewController`.
 */

class DetailCell: UICollectionViewCell {
  
  // For simplicity's sake, use the string reprentation of the class as its reuse identifier
  static let reuseIdentifier = "\(DetailCell.self)"
  
  // Each of `PersonDetailViewController`'s `DetailCell`s contains an image view that can hold an image of a feature representing that cell's selectable feature option. That same image view can also just contain a background color and no image to represent the selectable hair color or eye color options. `textLabel` can hold a text description of the selectable feature/topic option represented by the cell.
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var textLabel: UILabel!
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  // By overriding the `UICollectionViewCell`'s `isSelected` property, if a cell is selected, it will have a thick cyan border; if not selected, it will have a thin light gray border.
  override var isSelected: Bool {
    didSet {
      if isSelected {
        layer.borderWidth = 4.0
        layer.borderColor = UIColor.cyan.cgColor
      } else {
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.lightGray.cgColor
      }
    }
  }
  
  // Clear out `imageView` and `textLabel` to prepare for reuse.
  override func prepareForReuse() {
    imageView.image = nil
    textLabel.text = nil
    imageView.backgroundColor = .clear
  }
}

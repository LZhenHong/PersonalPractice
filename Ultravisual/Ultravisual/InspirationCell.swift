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

class InspirationCell: UICollectionViewCell {
  static let reuseIdentifier = String(describing: InspirationCell.self)
    
  @IBOutlet private weak var imageView: UIImageView!
  @IBOutlet private weak var imageCoverView: UIView!
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var timeAndRoomLabel: UILabel!
  @IBOutlet private weak var speakerLabel: UILabel!
  
  
  var inspiration: Inspiration? {
    didSet {
      if let inspiration = inspiration {
        imageView.image = inspiration.backgroundImage
        titleLabel.text = inspiration.title
        timeAndRoomLabel.text = inspiration.roomAndTime
        speakerLabel.text = inspiration.speaker
      }
    }
  }
  
  override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
    super.apply(layoutAttributes)
    
    let standardHeight = UltravisualLayoutConstants.Cell.standardHeight
    let featuredHeight = UltravisualLayoutConstants.Cell.featuredHeight
    let delta = 1 - ((featuredHeight - frame.height) / (featuredHeight - standardHeight))
    let minAlpha: CGFloat = 0.3
    let maxAlpha: CGFloat = 0.75
    imageCoverView.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))
    let scale = max(0.5, delta)
    titleLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
    timeAndRoomLabel.alpha = delta
    speakerLabel.alpha = delta
  }
}

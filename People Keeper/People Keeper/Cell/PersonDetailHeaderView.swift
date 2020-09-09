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
 Provides a header view for `PersonDetailViewController`'s collection
 view that displays either a person preview or section text description.
 */

class PersonDetailHeaderView: UICollectionReusableView {
  
  // For simplicity's sake, use the string reprentation of the class as its reuse identifier
  static let reuseIdentifier = "\(PersonDetailHeaderView.self)"
  
  // `PersonDetailHeaderView`'s interface is laid out in `Main.storyboard`'s `PersonDetailHeaderView` collection view prototype header.
  // The `PersonDetailHeaderView`s in the first section of `PersonDetailViewController`'s collection view will contain a preview view that can be added as a subview to `previewView`. All the other collection view section headers will show a text description in `textLabel`.
  @IBOutlet weak var previewView: UIView!
  @IBOutlet weak var textLabel: UILabel!

  // Prepare for reuse by removing all `previewView` subviews and deleting `textLabel`'s text.
  override func prepareForReuse() {
    previewView.subviews.forEach { $0.removeFromSuperview() }
    textLabel.text = nil
  }
}

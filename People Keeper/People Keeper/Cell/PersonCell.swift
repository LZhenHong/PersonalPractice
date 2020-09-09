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
 Defines a table view cell used in the `PersonListViewController` to
 display a person. Also used to display a person's preview in
 `PersonDetailViewController`.
 */

class PersonCell: UITableViewCell {
  
  // For simplicity's sake, use the string reprentation of the class as its reuse identifier
  static let reuseIdentifier = "\(PersonCell.self)"
  
  @IBOutlet weak var faceImageView: UIImageView!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var likesTextView: UITextView!
  @IBOutlet weak var dislikesTextView: UITextView!
  
  var featureImageViews: [UIImageView] = []
  
  var person: Person? {
    
    // Update the UI to show `person`'s info whenever `person` is set.
    didSet {
      guard let person = person else {
        return
      }
      // nameTextField holds `person`'s name
      nameTextField.text = person.name
      
      // likesTextView holds a list of `person`'s likes, each separated by a comma
      likesTextView.text = Array(person.likes).map { topic -> String in
        return topic.rawValue
        }.joined(separator: ", ")
      
      // dislikesTextView holds a list of `person`'s dislikes, each separated by a comma
      dislikesTextView.text = Array(person.dislikes).map { topic -> String in
        return topic.rawValue
        }.joined(separator: ", ")
      
      // As you can see in `PersonCell.xib`, `faceImageView` contains a plain smiley face. To add to the person composite, one by one we add an image view of each feature to `featureImageViews`; then add all those image views as subviews onto `faceImageView`.
      
      // `person`'s `hairLength` string represetation is combined with "_hair" to produce an image file name. "long_hair", "medium_hair", and "short_hair" are all valid files stored in `Assets.xcassets`; "bald_hair" does not correspond to an image in the bundle and therefore no hair image is added as a feature when `person`'s hair length is "bald".
      // The "long_hair", "medium_hair", and "short_hair" assets are all set to render as template images so that setting their tint will change any non-tranparent part of the image to that tint color.  In this case, an image's tint color is set to that of the person's current `hairColor`.
      if let hairImage = UIImage(named: person.face.hairLength.rawValue + "_hair") {
        let imageView = UIImageView(image: hairImage)
        imageView.tintColor = person.face.hairColor.rawValue.color()
        featureImageViews += [imageView]
      }
      
      // Loop through each item in the person's facial hair set and create an image view corresponding to each contained facial hair style's string value.
      // Both the "mustache" and "beard" assets are set to render as template images so setting their tint will change any non-tranparent part of the image to that tint color.  In this case, an image's tint color is set to that of the person's current `hairColor`.
      for facialHair in person.face.facialHair {
        if let facialHairImage = UIImage(named: facialHair.rawValue) {
          let imageView = UIImageView(image: facialHairImage)
          imageView.tintColor = person.face.hairColor.rawValue.color()
          // Shadow to help differentiate beard from hair
          imageView.layer.shadowColor = UIColor.black.cgColor
          imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
          imageView.layer.shadowRadius = 2
          imageView.layer.shadowOpacity = 0.15
          
          featureImageViews += [imageView]
        }
      }
      
      // The "eyes" asset is set to render as a template image so setting its tint will change any non-tranparent part of the image to that tint color.  In this case, the eye image's tint color is set to that of the person's `eyeColor`.
      if let eyesImage = UIImage(named: "eyes") {
        let imageView = UIImageView(image: eyesImage)
        imageView.tintColor = person.face.eyeColor.rawValue.color()
        featureImageViews += [imageView]
      }
      
      // If the person wears glasses, add the bundle's "glasses" image to `featureImageViews`.
      if person.face.glasses, let glassesImage = UIImage(named: "glasses") {
        let imageView = UIImageView(image: glassesImage)
        featureImageViews += [imageView]
      }
      
      // Now that all the relevant image views have been added to `featureImageViews`, use `forEach` to go through each array item and add each item as a subview of faceImageView.
      featureImageViews.forEach { imageView in
        imageView.contentMode = faceImageView.contentMode
        imageView.frame = faceImageView.bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        faceImageView.addSubview(imageView)
      }
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func prepareForReuse() {
    // To prepare for a cell's reuse, clear out all the inputs and remove all the faceImageView feature subviews.
    nameTextField.text = nil
    likesTextView.text = nil
    dislikesTextView.text = nil
    featureImageViews.forEach { $0.removeFromSuperview() }
    featureImageViews = []
  }
}

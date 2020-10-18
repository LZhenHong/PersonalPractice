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

final class BookDetailViewController: UIViewController {
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var nameField: UITextField!
  @IBOutlet var ratingView: STRatingControl!
  @IBOutlet var notesView: UITextView!
  @IBOutlet var tapToAddMessage: UILabel!
  
  var detailBook: Book?
  var pickedImage: UIImage?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    imageView.layer.cornerRadius = imageView.bounds.width / 2
    imageView.layer.borderColor = UIColor.black.cgColor
    imageView.layer.borderWidth = 1
    
    if detailBook == nil {
      navigationItem.rightBarButtonItem = nil
    }
    
    detailBook = detailBook ?? Book()
    
    title = detailBook?.name
    nameField.text = detailBook?.name
    ratingView.rating = detailBook?.rating ?? 1
    notesView.text = detailBook?.note
    imageView.image = detailBook?.getImage()
    imageView.backgroundColor = .white
    pickedImage = detailBook?.getImage()
    tapToAddMessage.isHidden = (imageView.image != nil)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    saveBook()
  }
  
  private func saveBook() {
    guard var detailBook = detailBook,
          let name = nameField.text,
          !name.isEmpty else {
        return
    }
    
    detailBook.name = name
    detailBook.rating = ratingView.rating
    detailBook.note = notesView.text
    detailBook.set(image: pickedImage)
    
    BookManager.shared.add(book: detailBook)
  }
  
  @IBAction func share(_ sender: UIBarButtonItem) {
    saveBook()
    
    guard let detailBook = detailBook,
          let url = detailBook.exportToURL() else {
      return
    }
    
    let activity = UIActivityViewController(activityItems: ["Check out this book! I like using Book Tracker.", url], applicationActivities: nil)
    activity.popoverPresentationController?.barButtonItem = sender
    present(activity, animated: true, completion: nil)
  }
  
  @IBAction func pickPhoto(_ sender: AnyObject) {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
    alert.addAction(cancelAction)
    
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      let takePhotoAction = UIAlertAction(title: NSLocalizedString("Take Photo", comment: ""), style: .default) { _ in
        self.showImagePicker(withSourceType: .camera)
        }
      alert.addAction(takePhotoAction)
    }
    
    let chooseFromLibraryAction = UIAlertAction(title: NSLocalizedString("Choose From Library", comment: ""), style: .default) { _ in
      self.showImagePicker(withSourceType: .photoLibrary)
      }
    alert.addAction(chooseFromLibraryAction)
    
    alert.popoverPresentationController?.sourceView = imageView
    present(alert, animated: true, completion: nil)
  }
}

// MARK: - UIImagePickerControllerDelegate
extension BookDetailViewController: UIImagePickerControllerDelegate {
  func showImagePicker(withSourceType source: UIImagePickerController.SourceType) {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = source
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    imagePicker.view.tintColor = view.tintColor
    present(imagePicker, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    guard let image = info[.editedImage] as? UIImage else {
      dismiss(animated: true, completion: nil)
      return
    }
    
    pickedImage = image
    imageView.image = image
    tapToAddMessage.isHidden = true
    
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
}

// MARK: - UINavigationControllerDelegate
extension BookDetailViewController: UINavigationControllerDelegate {}

/// Copyright (c) 2020 Razeware LLC
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

final class FlickrPhotosViewController: UICollectionViewController {
  
  private let reuseIdentifier = "FlickrCell"
  private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
  
  private var searches: [FlickrSearchResults] = []
  private let flickr = Flickr()
  private let itemsPerRow: CGFloat = 3
  
  private var selectedPhotos: [FlickrPhoto] = []
  private let shareLabel = UILabel()
  
  var largePhotoIndexPath: IndexPath? {
    didSet {
      var indexPaths: [IndexPath] = []
      if let largePhotoIndexPath = largePhotoIndexPath {
        indexPaths.append(largePhotoIndexPath)
      }
      
      if let oldValue = oldValue {
        indexPaths.append(oldValue)
      }
      
      collectionView.performBatchUpdates {
        self.collectionView.reloadItems(at: indexPaths)
      } completion: { _ in
        if let largePhotoIndexPath = self.largePhotoIndexPath {
          self.collectionView.scrollToItem(at: largePhotoIndexPath, at: .centeredVertically, animated: true)
        }
      }

    }
  }
  
  var sharing: Bool = false {
    didSet {
      collectionView.allowsMultipleSelection = sharing
      collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
      selectedPhotos.removeAll()
      
      guard let shareButton = self.navigationItem.rightBarButtonItems?.first else {
        return
      }
      
      guard sharing else {
        navigationItem.setRightBarButton(shareButton, animated: true)
        return
      }
      
      if largePhotoIndexPath != nil {
        largePhotoIndexPath = nil
      }
      
      updateSharedPhotoCountLabel()
      
      let sharingItem = UIBarButtonItem(customView: shareLabel)
      let items: [UIBarButtonItem] = [shareButton, sharingItem]
      navigationItem.setRightBarButtonItems(items, animated: true)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.dragInteractionEnabled = true
    collectionView.dragDelegate = self
    collectionView.dropDelegate = self
  }
  
  @IBAction func share(_ sender: UIBarButtonItem) {
    guard !searches.isEmpty else {
      return
    }
    
    guard !selectedPhotos.isEmpty else {
      sharing.toggle()
      return
    }
    
    guard sharing else {
      return
    }
    
    let images: [UIImage] = selectedPhotos.compactMap { photo in
      if let thumbnail = photo.thumbnail {
        return thumbnail
      }
      return nil
    }
    
    guard !images.isEmpty else {
      return
    }
    
    let shareController = UIActivityViewController(activityItems: images, applicationActivities: nil)
    shareController.completionWithItemsHandler = {
      _, _, _, _ in
      self.sharing = false
      self.selectedPhotos.removeAll()
      self.updateSharedPhotoCountLabel()
    }
    shareController.popoverPresentationController?.barButtonItem = sender
    shareController.popoverPresentationController?.permittedArrowDirections = .any
    present(shareController, animated: true, completion: nil)
  }
  
}

// MARK: - UITextFieldDelegate
extension FlickrPhotosViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    textField.addSubview(activityIndicator)
    activityIndicator.frame = textField.bounds
    activityIndicator.startAnimating()
    
    flickr.searchFlickr(for: textField.text!) { searchResults in
      activityIndicator.removeFromSuperview()
      
      switch searchResults {
      case .error(let error):
        print("Error search: \(error.localizedDescription)")
      case .results(let results):
        print("Found \(results.searchResults.count) matching \(results.searchTerm)")
        self.searches.insert(results, at: 0)
        self.collectionView.reloadData()
      }
    }
    
    textField.text = nil
    textField.resignFirstResponder()
    
    return true
  }
}

// MARK: - UICollectionViewDataSource
extension FlickrPhotosViewController {
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return searches.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return searches[section].searchResults.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FlickrPhotoCell else {
      preconditionFailure("Invalid cell type")
    }
    cell.activityIndicator.stopAnimating()
    
    let flickrPhoto = photo(for: indexPath)
    
    guard indexPath == largePhotoIndexPath else {
      cell.imageView.image = flickrPhoto.thumbnail
      return cell
    }
    
    guard flickrPhoto.largeImage == nil else {
      cell.imageView.image = flickrPhoto.largeImage
      return cell
    }
    
    cell.imageView.image = flickrPhoto.thumbnail
    performLargeImageFetch(for: cell, flickrPhoto: flickrPhoto)
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    switch kind {
    case UICollectionView.elementKindSectionHeader:
      guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(FlickrPhotoHeaderView.self)", for: indexPath) as? FlickrPhotoHeaderView else {
        fatalError("Invalid view type")
      }
      let searchTerm = searches[indexPath.row].searchTerm
      headerView.label.text = searchTerm
      return headerView
    default:
      assert(false, "Invalid element type")
    }
  }
}

// MARK: - UICollectionViewDelegate
extension FlickrPhotosViewController {
  override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    guard !sharing else {
      return true
    }
    
    if largePhotoIndexPath == indexPath {
      largePhotoIndexPath = nil
    } else {
      largePhotoIndexPath = indexPath
    }
    return false
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard sharing else {
      return
    }
    
    let flickrPhoto = photo(for: indexPath)
    selectedPhotos.append(flickrPhoto)
    updateSharedPhotoCountLabel()
  }
  
  override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    guard sharing else {
      return
    }
    
    let flickrPhoto = photo(for: indexPath)
    if let index = selectedPhotos.firstIndex(of: flickrPhoto) {
      selectedPhotos.remove(at: index)
      updateSharedPhotoCountLabel()
    }
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FlickrPhotosViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if indexPath == largePhotoIndexPath {
      let flickrPhoto = photo(for: indexPath)
      var size = collectionView.bounds.size
      size.height -= (sectionInsets.top + sectionInsets.bottom)
      size.width -= (sectionInsets.left + sectionInsets.right)
      return flickrPhoto.sizeToFillWidth(of: size)
    }
    
    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow
    return CGSize(width: widthPerItem, height: widthPerItem)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left
  }
}

extension FlickrPhotosViewController: UICollectionViewDragDelegate {
  func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    let flickrPhoto = photo(for: indexPath)
    guard let thumbnail = flickrPhoto.thumbnail else {
      return []
    }
    let item = NSItemProvider(object: thumbnail)
    let dragItem = UIDragItem(itemProvider: item)
    return [dragItem]
  }
}

extension FlickrPhotosViewController: UICollectionViewDropDelegate {
  func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
    guard session.localDragSession != nil else {
      return false
    }
    return true
  }
  
  func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
    return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
  }
  
  func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
    guard let destinationIndexPath = coordinator.destinationIndexPath else {
      return
    }
    
    coordinator.items.forEach { dropItem in
      guard let sourceIndexPath = dropItem.sourceIndexPath else {
        return
      }
      
      collectionView.performBatchUpdates {
        let flickrPhoto = photo(for: sourceIndexPath)
        removePhoto(at: sourceIndexPath)
        insertPhoto(flickrPhoto, at: destinationIndexPath)
        collectionView.deleteItems(at: [sourceIndexPath])
        collectionView.insertItems(at: [destinationIndexPath])
      } completion: { _ in
        coordinator.drop(dropItem.dragItem, toItemAt: destinationIndexPath)
      }
    }
  }
}

private extension FlickrPhotosViewController {
  func photo(for indexPath: IndexPath) -> FlickrPhoto {
    return searches[indexPath.section].searchResults[indexPath.row]
  }
  
  func performLargeImageFetch(for cell: FlickrPhotoCell, flickrPhoto: FlickrPhoto) {
    cell.activityIndicator.startAnimating()
    
    flickrPhoto.loadLargeImage { [weak self] result in
      guard let self = self else {
        return
      }
      cell.activityIndicator.stopAnimating()
      
      switch result {
      case .results(let photo):
        let indexPath = self.collectionView.indexPath(for: cell)
        if indexPath == self.largePhotoIndexPath {
          cell.imageView.image = photo.largeImage
        }
      case .error(_):
        return
      }
    }
  }
  
  func updateSharedPhotoCountLabel() {
    if sharing {
      shareLabel.text = "\(selectedPhotos.count) photos selected"
    } else {
      shareLabel.text = ""
    }
    shareLabel.textColor = themeColor
    
    UIView.animate(withDuration: 0.3) {
      self.shareLabel.sizeToFit()
    }
  }
  
  func removePhoto(at indexPath: IndexPath) {
    searches[indexPath.section].searchResults.remove(at: indexPath.row)
  }
  
  func insertPhoto(_ flickrPhoto: FlickrPhoto, at indexPath: IndexPath) {
    searches[indexPath.section].searchResults.insert(flickrPhoto, at: indexPath.row)
  }
}

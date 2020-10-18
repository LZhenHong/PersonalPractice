/// Copyright (c) 2019 Razeware LLC
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
import Geocache

class CachesViewController: UIViewController {
  // MARK: - Properties
  @IBOutlet weak var inProgressCollectionView: UICollectionView!
  @IBOutlet weak var completedCollectionView: UICollectionView!

  // Initial in-progress geocaches are loaded from a .plist
  private lazy var inProgressDataSource: CachesDataSource = {
    guard let path = Bundle.main.path(forResource: "Geocaches", ofType: "plist")
      else {
        print("Failed to read Geocaches.plist")
        return CachesDataSource(geocaches: [])
    }

    let fileUrl = URL.init(fileURLWithPath: path)

    guard let geocachesArray = NSArray(contentsOf: fileUrl) as? [[String: Any]]
      else { return CachesDataSource(geocaches: []) }

    let geocaches: [Geocache] = geocachesArray.compactMap({ (geocache) in
      guard
        let name = geocache[Geocache.Key.name] as? String,
        let summary = geocache[Geocache.Key.summary] as? String,
        let latitude = geocache[Geocache.Key.latitude] as? Double,
        let longitude = geocache[Geocache.Key.longitude] as? Double,
        let imageName = geocache[Geocache.Key.image] as? String,
        let image = UIImage(named: imageName)?.pngData()
        else {
          return nil
      }

      return Geocache(
        name: name, summary: summary,
        latitude: latitude, longitude: longitude, image: image)
    })
    return CachesDataSource(geocaches: geocaches)
  }()

  // Initial completed geocaches are empty
  private var completedDataSource = CachesDataSource(geocaches: [])

  // MARK: - Lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
    for collectionView in [inProgressCollectionView, completedCollectionView] {
      if let collectionView = collectionView {
        collectionView.dataSource = dataSourceForCollectionView(collectionView)
        collectionView.delegate = self
      }
    }
  }

}

// MARK: - Private methods
private extension CachesViewController {
  func dataSourceForCollectionView(
    _ collectionView: UICollectionView
  ) -> CachesDataSource {
    if collectionView == inProgressCollectionView {
      return inProgressDataSource
    } else {
      return completedDataSource
    }
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CachesViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.bounds.width, height: 100)
  }
}

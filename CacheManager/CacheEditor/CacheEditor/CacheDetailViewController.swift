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
import MapKit

class CacheDetailViewController: UIViewController {
  // MARK: - Properties
  @IBOutlet weak var cacheImageView: UIImageView!
  @IBOutlet weak var cacheNameTextField: UITextField!
  @IBOutlet weak var cacheSummaryTextView: UITextView!
  @IBOutlet weak var mapView: MKMapView!

  private var geocache = Geocache(
    name: "Eiffel Tower",
    summary: """
      The Eiffel Tower is a wrought-iron lattice tower on the Champ de \
      Mars in Paris, France. It is named after the engineer Gustave Eiffel, \
      whose company designed and built the tower.
      """,
    latitude: 48.858370, longitude: 2.294481,
    image: UIImage(named: "eiffel_tower")?.pngData()
    )

  // MARK: - Lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }

  // MARK: - Actions
  @IBAction func nameTextFieldChanged(_ sender: Any) {
    if let name = cacheNameTextField.text {
      geocache.name = name
    }
  }
}

// MARK: - Private methods
private extension CacheDetailViewController {
  func configureView() {
    if let image = geocache.image {
      cacheImageView.image = UIImage(data: image)
    } else {
      cacheImageView.image = nil
    }
    cacheNameTextField.text = geocache.name
    cacheSummaryTextView.text = geocache.summary
    let coordinate = CLLocationCoordinate2D(latitude: geocache.latitude, longitude: geocache.longitude)
    let mapRect = MKCoordinateRegion(
      center: coordinate,
      latitudinalMeters: 1000,
      longitudinalMeters: 1000
    )
    mapView.setRegion(mapRect, animated: false)
  }

  func adjustViewBrightness(to alpha: CGFloat) {
    cacheImageView.alpha = alpha
    cacheNameTextField.alpha = alpha
    cacheSummaryTextView.alpha = alpha
    mapView.alpha = alpha
  }
}

// MARK: - UITextViewDelegate
extension CacheDetailViewController: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    if let summary = textView.text {
      geocache.summary = summary
    }
  }
}

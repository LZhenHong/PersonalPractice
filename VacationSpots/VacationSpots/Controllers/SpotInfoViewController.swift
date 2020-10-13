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
import SafariServices

class SpotInfoViewController: UIViewController {
  var vacationSpot: VacationSpot!
  
  @IBOutlet var backgroundColoredViews: [UIView]!
  @IBOutlet var headingLabels: [UILabel]!
  
  @IBOutlet var ownRatingStackView: UIStackView!
  @IBOutlet var whyVisitLabel: UILabel!
  @IBOutlet var whatToSeeLabel: UILabel!
  @IBOutlet var weatherInfoLabel: UILabel!
  @IBOutlet var averageRatingLabel: UILabel!
  @IBOutlet var ownRatingLabel: UILabel!
  @IBOutlet var weatherHideOrShowButton: UIButton!
  @IBOutlet var submitRatingButton: UIButton!
  
  var shouldHideWeatherInfoSetting: Bool {
    get {
      return UserDefaults.standard.bool(forKey: "shouldHideWeatherInfo")
    }
    set {
      UserDefaults.standard.set(newValue, forKey: "shouldHideWeatherInfo")
    }
  }
  
  var currentUserRating: Int {
    get {
      return UserDefaults.standard.integer(
        forKey: "currentUserRating-\(vacationSpot.identifier)")
    }
    set {
      UserDefaults.standard.set(
        newValue, forKey: "currentUserRating-\(vacationSpot.identifier)")
      updateCurrentRating()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Clear background colors from labels and buttons
    for view in backgroundColoredViews {
      view.backgroundColor = .clear
    }
    
    // Set the kerning to 1 to increase spacing between letters
    headingLabels.forEach { $0.attributedText = NSAttributedString(
      string: $0.text!, attributes: [NSAttributedString.Key.kern: 1]) }
    
    title = vacationSpot.name
    
    whyVisitLabel.text = vacationSpot.whyVisit
    whatToSeeLabel.text = vacationSpot.whatToSee
    weatherInfoLabel.text = vacationSpot.weatherInfo
    averageRatingLabel.text = String(repeating: "★", count: vacationSpot.userRating)
    
    updateWeatherInfoViews(hideWeatherInfo: shouldHideWeatherInfoSetting,
                           animated: false)
    
    let interaction = UIContextMenuInteraction(delegate: self)
    submitRatingButton.addInteraction(interaction)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateCurrentRating()
  }
  
  private func updateCurrentRating() {
    UIView.animate(withDuration: 0.3) {
      let rating = self.currentUserRating
      if rating > 0 {
        self.submitRatingButton.setTitle("Update Rating (\(rating))",
          for: .normal)
        self.ownRatingStackView.isHidden = false
        self.ownRatingLabel.text = String(repeating: "★",
                                          count: rating)
      } else {
        self.submitRatingButton.setTitle("Submit Rating", for: .normal)
        self.ownRatingStackView.isHidden = true
      }
    }
  }
  
  @IBAction func weatherHideOrShowButtonTapped(_ sender: UIButton) {
    let shouldHideWeatherInfo = sender.titleLabel!.text! == "Hide"
    updateWeatherInfoViews(hideWeatherInfo: shouldHideWeatherInfo,
                           animated: true)
    shouldHideWeatherInfoSetting = shouldHideWeatherInfo
  }
  
  func updateWeatherInfoViews(hideWeatherInfo shouldHideWeatherInfo: Bool,
                              animated: Bool) {
    let newButtonTitle = shouldHideWeatherInfo ? "Show" : "Hide"
    
    if animated {
      UIView.animate(withDuration: 0.3) {
        self.weatherHideOrShowButton.setTitle(newButtonTitle, for: .normal)
        self.weatherInfoLabel.isHidden = shouldHideWeatherInfo
      }
    } else {
      weatherHideOrShowButton.setTitle(newButtonTitle, for: .normal)
      weatherInfoLabel.isHidden = shouldHideWeatherInfo
    }
  }
  
  @IBAction func wikipediaButtonTapped(_ sender: UIButton) {
    let safariVC = SFSafariViewController(url: vacationSpot.wikipediaURL)
    safariVC.delegate = self
    present(safariVC, animated: true, completion: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier! {
    case "presentMapViewController":
      guard
        let navigationController = segue.destination as? UINavigationController,
        let mapViewController = navigationController.topViewController
          as? MapViewController
        else {
          fatalError("Unexpected view hierarchy")
      }
      mapViewController.locationToShow = vacationSpot.coordinate
      mapViewController.title = vacationSpot.name
    case "presentRatingViewController":
      guard
        let navigationController = segue.destination as? UINavigationController,
        let ratingViewController = navigationController.topViewController
          as? RatingViewController
        else {
          fatalError("Unexpected view hierarchy")
      }
      ratingViewController.vacationSpot = vacationSpot
      ratingViewController.onComplete = updateCurrentRating
    default:
      fatalError("Unhandled Segue: \(segue.identifier!)")
    }
  }
}

// MARK: - SFSafariViewControllerDelegate

extension SpotInfoViewController: SFSafariViewControllerDelegate {
  func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
    controller.dismiss(animated: true, completion: nil)
  }
}

// MARK: - UIContextMenuInteractionDelegate

extension SpotInfoViewController: UIContextMenuInteractionDelegate {
  func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
    return UIContextMenuConfiguration(identifier: nil, previewProvider: makePreview) { _ in
      let removeRating = self.makeRemoveRatingAction()
      let rateMenu = self.makeRateMenu()
      let children = [rateMenu, removeRating]
      return UIMenu(title: "", children: children)
    }
  }
  
  func makeRateMenu() -> UIMenu {
    let ratingButtonTitles = ["Boring", "Meh", "It's OK", "Like It", "Fantastic!"]
    
    let rateActions = ratingButtonTitles.enumerated().map { index, title in
      UIAction(title: title, identifier: UIAction.Identifier("\(index + 1)"), handler: updateRating)
    }
    return UIMenu(title: "Rate...", image: UIImage(systemName: "star.circle"), options: .displayInline, children: rateActions)
  }
  
  func makeRemoveRatingAction() -> UIAction {
    var removeRatingAttributes = UIMenuElement.Attributes.destructive
    
    if currentUserRating == 0 {
      removeRatingAttributes.insert(.disabled)
    }
    
    let deleteImage = UIImage(systemName: "delete.left")
    return UIAction(title: "Remove Rating",
                    image: deleteImage,
                    identifier: nil,
                    attributes: removeRatingAttributes) { _ in
      self.currentUserRating = 0
    }
  }
  
  func updateRating(from action: UIAction) {
    guard let number = Int(action.identifier.rawValue) else {
      return
    }
    currentUserRating = number
  }
  
  func makePreview() -> UIViewController {
    let viewController = UIViewController()
    let imageView = UIImageView(image: UIImage(named: "rating_star"))
    imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    viewController.view = imageView
    viewController.preferredContentSize = imageView.frame.size
    return viewController
  }
}

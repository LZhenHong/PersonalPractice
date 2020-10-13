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
import MapKit

class SpotsViewController: UITableViewController {
  var vacationSpots: [VacationSpot] = []

  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    vacationSpots = VacationSpot.defaultSpots
  }
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard
      let selectedCell = sender as? UITableViewCell,
      let selectedRowIndex = tableView.indexPath(for: selectedCell)?.row,
      segue.identifier == "showSpotInfoViewController"
      else {
        fatalError("sender is not a UITableViewCell or was not found in the tableView, or segue.identifier is incorrect")
    }
    
    let vacationSpot = vacationSpots[selectedRowIndex]
    let detailViewController = segue.destination as! SpotInfoViewController
    detailViewController.vacationSpot = vacationSpot
  }
  
  func showMap(vacationSpot: VacationSpot) {
    let storyboard = UIStoryboard(name: "Map", bundle: nil)
    
    let initial = storyboard.instantiateInitialViewController()
    guard
      let navigationController =  initial as? UINavigationController,
      let mapViewController = navigationController.topViewController
        as? MapViewController
      else {
        fatalError("Unexpected view hierarchy")
    }
    
    mapViewController.locationToShow = vacationSpot.coordinate
    mapViewController.title = vacationSpot.name
    
    present(navigationController, animated: true)
  }
  
  // MARK: - UITableViewDataSource
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return vacationSpots.count
  }
  
  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "VacationSpotCell",
                                             for: indexPath) as! VacationSpotCell
    let vacationSpot = vacationSpots[indexPath.row]
    cell.nameLabel.text = vacationSpot.name
    cell.locationNameLabel.text = vacationSpot.locationName
    cell.thumbnailImageView.image = UIImage(named: vacationSpot.thumbnailName)
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
    let index = indexPath.row
    let vacationSpot = vacationSpots[index]
    let identifier = "\(index)" as NSString
    return UIContextMenuConfiguration(identifier: identifier, previewProvider: nil) { _ in
      let mapAction = UIAction(title: "View Map", image: UIImage(systemName: "map")) { _ in
        self.showMap(vacationSpot: vacationSpot)
      }
      
      let shareAction = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { _ in
        VacationSharer.share(vacationSpot: vacationSpot, in: self)
      }
      
      return UIMenu(title: "", image: nil, children: [mapAction, shareAction])
    }
  }
  
  override func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
    guard let identifier = configuration.identifier as? String,
          let index = Int(identifier),
          let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? VacationSpotCell else {
      return nil
    }
    
    return UITargetedPreview(view: cell.thumbnailImageView)
  }
  
  override func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
    guard let identifier = configuration.identifier as? String,
          let index = Int(identifier) else {
      return
    }
    let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
    animator.addCompletion {
      self.performSegue(withIdentifier: "showSpotInfoViewController", sender: cell)
    }
  }
}

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
import MapKit
import CoreLocation

protocol AddGeotificationsViewControllerDelegate {
  func addGeotificationViewController(_ controller: AddGeotificationViewController, didAdd geotification: Geotification)
  func addGeotificationViewController(_ controller: AddGeotificationViewController, didChange oldGeotifcation: Geotification, to newGeotification: Geotification)
  func addGeotificationViewController(_ controller: AddGeotificationViewController, didSelect action: UIPreviewAction, for previewedController: UIViewController)
}

class AddGeotificationViewController: UITableViewController {
  @IBOutlet var addButton: UIBarButtonItem!
  @IBOutlet var zoomButton: UIBarButtonItem!
  @IBOutlet weak var eventTypeSegmentedControl: UISegmentedControl!
  @IBOutlet weak var radiusTextField: UITextField!
  @IBOutlet weak var noteTextField: UITextField!
  @IBOutlet weak var mapView: MKMapView!
  
  var delegate: AddGeotificationsViewControllerDelegate?
  var geotification: Geotification?
  
  override var previewActionItems: [UIPreviewActionItem] {
    let editAction = UIPreviewAction(title: "Edit", style: .default) {
      [weak self] (action, controller) in
      self?.handle(action: action, and: controller)
    }
    
    let deleteAction = UIPreviewAction(title: "Delete", style: .destructive) {
      [weak self] (action, controller) in
      self?.handle(action: action, and: controller)
    }
    let cancelAction = UIPreviewAction(title: "Cancel", style: .default) {
      [weak self] (action, controller) in
      self?.handle(action: action, and: controller)
    }
    let group = UIPreviewActionGroup(title: "Delete...", style: .destructive, actions: [deleteAction, cancelAction])
    return [editAction, group]
  }
  
  private func handle(action: UIPreviewAction, and controller: UIViewController) {
    delegate?.addGeotificationViewController(self, didSelect: action, for: controller)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.rightBarButtonItems = [addButton, zoomButton]
    addButton.isEnabled = false
    if let geotification = geotification {
      setup(geotification)
    }
  }
  
  private func setup(_ geotification: Geotification) {
    title = "Edit Geotification"
    eventTypeSegmentedControl.selectedSegmentIndex = geotification.eventType == .onEntry ? 0 : 1
    radiusTextField.text = String(Int(geotification.radius))
    noteTextField.text = geotification.note
    mapView.setCenter(geotification.coordinate, animated: false)
    addButton.title = "Save"
    addButton.isEnabled = true
  }
  
  @IBAction func textFieldEditingChanged(sender: UITextField) {
    addButton.isEnabled = !radiusTextField.text!.isEmpty && !noteTextField.text!.isEmpty
  }
  
  @IBAction func onCancel(sender: AnyObject) {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction private func onAdd(sender: AnyObject) {
    let coordinate = mapView.centerCoordinate
    let radius = Double(radiusTextField.text!) ?? 0
    let identifier = NSUUID().uuidString
    let note = noteTextField.text ?? ""
    let eventType: Geotification.EventType = (eventTypeSegmentedControl.selectedSegmentIndex == 0) ? .onEntry : .onExit
    if let geotification = geotification {
      let oldGeotification = geotification
      geotification.coordinate = coordinate
      geotification.radius = radius
      geotification.note = note
      geotification.eventType = eventType
      delegate?.addGeotificationViewController(self, didChange: oldGeotification, to: geotification)
    } else {
      let clampedRadius = min(radius, CLLocationManager().maximumRegionMonitoringDistance)
      let geotification = Geotification(coordinate: coordinate, radius: clampedRadius, identifier: identifier, note: note, eventType: eventType)
      delegate?.addGeotificationViewController(self, didAdd: geotification)
    }
  }
  
  @IBAction private func onZoomToCurrentLocation(sender: AnyObject) {
    mapView.zoomToUserLocation()
  }
}

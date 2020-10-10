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

class GeotificationsViewController: UIViewController {
  @IBOutlet weak var mapView: MKMapView!
  private var locationManager = CLLocationManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    locationManager.delegate = self
    locationManager.requestAlwaysAuthorization()
    GeotificationManager.shared.geotifications.forEach {
      addToMap($0)
    }
  }
  
  // MARK: - Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "addGeotification" {
      guard let addViewController = segue.destination as? AddGeotificationViewController else { return }
      addViewController.delegate = self
    }
  }
  
  @IBAction func listExit(segue: UIStoryboardSegue) {
    mapView.removeAnnotations(mapView.annotations)
    GeotificationManager.shared.geotifications.forEach {
      addToMap($0)
    }
    if GeotificationManager.shared.geotifications.isEmpty {
      updateGeotificationsCount()
    }
  }
  
  // MARK: Functions that update the model/associated views with geotification changes
  func add(_ geotification: Geotification) {
    GeotificationManager.shared.geotifications.append(geotification)
    addToMap(geotification)
  }
  
  private func addToMap(_ geotification: Geotification) {
    mapView.addAnnotation(geotification)
    addRadiusOverlay(forGeotification: geotification)
    updateGeotificationsCount()
  }
  
  func remove(_ geotification: Geotification) {
    GeotificationManager.shared.remove(geotification)
    mapView.removeAnnotation(geotification)
    removeRadiusOverlay(forGeotification: geotification)
    updateGeotificationsCount()
  }
  
  private func updateGeotificationsCount() {
    let count = GeotificationManager.shared.geotifications.count
    title = "Geotifications: \(count)"
    navigationItem.rightBarButtonItem?.isEnabled = (count < 20)
  }
  
  // MARK: Map overlay functions
  private func addRadiusOverlay(forGeotification geotification: Geotification) {
    mapView?.addOverlay(MKCircle(center: geotification.coordinate, radius: geotification.radius))
  }
  
  private func removeRadiusOverlay(forGeotification geotification: Geotification) {
    // Find exactly one overlay which has the same coordinates & radius to remove
    guard let overlays = mapView?.overlays else { return }
    for overlay in overlays {
      guard let circleOverlay = overlay as? MKCircle else { continue }
      let coord = circleOverlay.coordinate
      if coord.latitude == geotification.coordinate.latitude && coord.longitude == geotification.coordinate.longitude && circleOverlay.radius == geotification.radius {
        mapView?.removeOverlay(circleOverlay)
        break
      }
    }
  }
  
  // MARK: Other mapview functions
  @IBAction func zoomToCurrentLocation(sender: AnyObject) {
    mapView.zoomToUserLocation()
  }
}

// MARK: - Location Manager Delegate
extension GeotificationsViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    mapView.showsUserLocation = status == .authorizedAlways
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Location Manager failed with the following error: \(error)")
  }
}

// MARK: - MapView Delegate
extension GeotificationsViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    let identifier = "myGeotification"
    if annotation is Geotification {
      var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
      if annotationView == nil {
        annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        annotationView?.canShowCallout = true
        let removeButton = UIButton(type: .custom)
        removeButton.frame = CGRect(x: 0, y: 0, width: 23, height: 23)
        removeButton.setImage(UIImage(named: "DeleteGeotification")!, for: .normal)
        annotationView?.leftCalloutAccessoryView = removeButton
        annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        if let annotationView = annotationView, traitCollection.forceTouchCapability == .available {
          registerForPreviewing(with: self, sourceView: annotationView)
        }
      } else {
        annotationView?.annotation = annotation
      }
      return annotationView
    }
    return nil
  }
  
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    if overlay is MKCircle {
      let circleRenderer = MKCircleRenderer(overlay: overlay)
      circleRenderer.lineWidth = 1.0
      circleRenderer.strokeColor = .purple
      circleRenderer.fillColor = UIColor.purple.withAlphaComponent(0.4)
      return circleRenderer
    }
    return MKOverlayRenderer(overlay: overlay)
  }
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    // Delete geotification
    if control == view.rightCalloutAccessoryView {
      guard let annotation = view.annotation as? Geotification,
        let addGeotificationViewController = storyboard?.instantiateViewController(withIdentifier: "AddGeotificationViewController") as? AddGeotificationViewController else { return }
      addGeotificationViewController.geotification = annotation
      addGeotificationViewController.delegate = self
      navigationController?.show(addGeotificationViewController, sender: nil)
    } else {
      let geotification = view.annotation as! Geotification
      remove(geotification)
    }
  }
}

// MARK: AddGeotificationViewControllerDelegate
extension GeotificationsViewController: AddGeotificationsViewControllerDelegate {
  func addGeotificationViewController(_ controller: AddGeotificationViewController, didAdd geotification: Geotification) {
    navigationController?.popViewController(animated: true)
    GeotificationManager.shared.add(geotification)
    addToMap(geotification)
  }
  
  func addGeotificationViewController(_ controller: AddGeotificationViewController, didChange oldGeotifcation: Geotification, to newGeotification: Geotification) {
    navigationController?.popViewController(animated: true)
    remove(oldGeotifcation)
    GeotificationManager.shared.add(newGeotification)
    addToMap(newGeotification)
  }
  
  func addGeotificationViewController(_ controller: AddGeotificationViewController, didSelect action: UIPreviewAction, for previewedController: UIViewController) {
    switch action.title {
    case "Edit":
      navigationController?.show(previewedController, sender: nil)
    case "Delete":
      guard let addGeotificationViewController = previewedController as? AddGeotificationViewController,
            let geotification = addGeotificationViewController.geotification else {
        return
      }
      remove(geotification)
    default:
      break
    }
  }
}

extension GeotificationsViewController: UIViewControllerPreviewingDelegate {
  func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
    guard let annotationView = previewingContext.sourceView as? MKAnnotationView,
          let annotation = annotationView.annotation as? Geotification,
          let addGeotificationViewController = storyboard?.instantiateViewController(withIdentifier: "AddGeotificationViewController") as? AddGeotificationViewController else {
      return nil
    }
    addGeotificationViewController.geotification = annotation
    addGeotificationViewController.delegate = self
    
    addGeotificationViewController.preferredContentSize = CGSize(width: 0, height: 360)
    return addGeotificationViewController
  }
  
  func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
    navigationController?.show(viewControllerToCommit, sender: nil)
  }
}

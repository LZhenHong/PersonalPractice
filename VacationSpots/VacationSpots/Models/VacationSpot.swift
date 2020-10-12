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

import Foundation
import MapKit

struct VacationSpot {
  let identifier: Int
  let name: String
  let locationName: String
  let thumbnailName: String
  let whyVisit: String
  let whatToSee: String
  let weatherInfo: String
  let userRating: Int
  let wikipediaURL: URL
  let coordinate: CLLocationCoordinate2D
}

extension VacationSpot: Codable {
  enum CodingKeys: String, CodingKey {
    case identifier
    case name
    case locationName
    case thumbnailName
    case whyVisit
    case whatToSee
    case weatherInfo
    case userRating
    case wikipediaLink
    case latitude
    case longitude
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(identifier, forKey: .identifier)
    try container.encode(name, forKey: .name)
    try container.encode(locationName, forKey: .locationName)
    try container.encode(thumbnailName, forKey: .thumbnailName)
    try container.encode(whyVisit, forKey: .whyVisit)
    try container.encode(whatToSee, forKey: .whatToSee)
    try container.encode(weatherInfo, forKey: .weatherInfo)
    try container.encode(userRating, forKey: .userRating)
    try container.encode(wikipediaURL, forKey: .wikipediaLink)
    try container.encode(coordinate.latitude, forKey: .latitude)
    try container.encode(coordinate.longitude, forKey: .longitude)
  }
  
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    
    identifier = try values.decode(Int.self, forKey: .identifier)
    name = try values.decode(String.self, forKey: .name)
    locationName = try values.decode(String.self, forKey: .locationName)
    thumbnailName = try values.decode(String.self, forKey: .thumbnailName)
    whyVisit = try values.decode(String.self, forKey: .whyVisit)
    whatToSee = try values.decode(String.self, forKey: .whatToSee)
    weatherInfo = try values.decode(String.self, forKey: .weatherInfo)
    userRating = try values.decode(Int.self, forKey: .userRating)
    
    let wikipediaLink = try values.decode(String.self, forKey: .wikipediaLink)
    guard let wikiURL = URL(string: wikipediaLink) else {
      fatalError("Invalid Wikipedia URL.")
    }
    wikipediaURL = wikiURL
      
    let latitude = try values.decode(Double.self, forKey: .latitude)
    let longitude = try values.decode(Double.self, forKey: .longitude)
    coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
}

// MARK: - Support for loading data from plist

extension VacationSpot {
  static let defaultSpots = loadVacationSpotsFromPlistNamed("vacation_spots")
  
  
  static func loadVacationSpotsFromPlistNamed(_ plistName: String) -> [VacationSpot] {
    guard
      let plistURL = Bundle.main.url(forResource: plistName, withExtension: "plist"),
      let data = try? Data(contentsOf: plistURL)
      else {
        fatalError("An error occurred while reading \(plistName).plist")
    }
    
    let decoder = PropertyListDecoder()
    
    do {
      let vacationSpots = try decoder.decode([VacationSpot].self, from: data)
      return vacationSpots
    } catch {
      print("Couldn't load vacation spots: \(error.localizedDescription)")
      return []
    }
  }
}

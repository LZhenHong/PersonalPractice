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
import MobileCoreServices

public let geocacheTypeId = "com.razeware.geocache"

enum EncodingError: Error {
  case invalidData
}

public class Geocache: NSObject, Codable {
  // MARK: - Enums
  public enum Key {
    public static let name = "name"
    public static let summary = "summary"
    public static let latitude = "latitude"
    public static let longitude = "longitude"
    public static let image = "imageName"
  }

  // MARK: - Properties
  public var name: String
  public var summary: String
  public var latitude: Double
  public var longitude: Double
  public var image: Data?

  // MARK: - Initialization
  public required init(
    name: String,
    summary: String,
    latitude: Double,
    longitude: Double,
    image: Data? = nil
    ) {
    self.name = name
    self.summary = summary
    self.latitude = latitude
    self.longitude = longitude
    self.image = image
  }

  public required init(_ geocache: Geocache) {
    self.name = geocache.name
    self.summary = geocache.summary
    self.latitude = geocache.latitude
    self.longitude = geocache.longitude
    self.image = geocache.image
    super.init()
  }
}

extension Geocache: NSItemProviderWriting {
  public static var writableTypeIdentifiersForItemProvider: [String] {
    [geocacheTypeId, kUTTypePNG as String, kUTTypePlainText as String]
  }
  
  // The system calls this when an item is dropped and passes in the appropriate type identifier.
  public func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
    if typeIdentifier == kUTTypePNG as String {
      if let image = image {
        completionHandler(image, nil)
      } else {
        completionHandler(nil, nil)
      }
    } else if typeIdentifier == kUTTypePlainText as String {
      completionHandler(name.data(using: .utf8), nil)
    } else if typeIdentifier == geocacheTypeId {
      do {
        let archiver = NSKeyedArchiver(requiringSecureCoding: false)
        try archiver.encodeEncodable(self, forKey: NSKeyedArchiveRootObjectKey)
        archiver.finishEncoding()
        let data = archiver.encodedData
        completionHandler(data, nil)
      } catch {
        completionHandler(nil, nil)
      }
    }
    return nil
  }
}

// Conform to NSItemProviderReading to specify how to handle incoming data.
extension Geocache: NSItemProviderReading {
  public static var readableTypeIdentifiersForItemProvider: [String] {
    [geocacheTypeId, kUTTypePlainText as String]
  }
  
  public static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
    if typeIdentifier == kUTTypePlainText as String {
      guard let name = String(data: data, encoding: .utf8) else {
        throw EncodingError.invalidData
      }
      return self.init(name: name, summary: "Unknown", latitude: 0.0, longitude: 0.0)
    } else if typeIdentifier == geocacheTypeId {
      do {
        let unarchiver = try NSKeyedUnarchiver(forReadingFrom: data)
        guard let geocache = try unarchiver.decodeTopLevelDecodable(Geocache.self, forKey: NSKeyedArchiveRootObjectKey) else {
          throw EncodingError.invalidData
        }
        return self.init(geocache)
      } catch {
        throw EncodingError.invalidData
      }
    } else {
      throw EncodingError.invalidData
    }
  }
}

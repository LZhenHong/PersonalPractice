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

/* Abstract:
 Defines the person, face, and topic model types that are used
 throughout the app.
 */

import UIKit

class Person {
  
  // MARK: - Properties
  var name: String
  var face: Face
  var likes: Set<Topic>
  var dislikes: Set<Topic>
  var tag: Int // The `tag` property will help differentiate people with identical names, faces, likes and dislikes from one another
  
  // MARK: - Initialization
  init(name: String, face: Face, likes: Set<Topic>, dislikes: Set<Topic>, tag: Int) {
    self.name = name
    self.face = face
    self.likes = likes
    self.dislikes = dislikes
    self.tag = tag
  }
  
  // MARK: - Types
  
  // Facial Features
  // Each feature enum contains the enumeration cases representing the possible options for that particular enum.
  // Each enumeration case has a string representation that can be used to either produce (1) a color using the `color()` method located in the `String` extension at the bottom of this file or (2) an image by referencing the file with a corresponding name in the app bundle's `Assets.xcassets` folder.
  
  enum HairColor: String, CaseIterable {
    case black = "black", brown = "brown", blonde = "blonde", red = "red", gray = "gray"
  }
  enum HairLength: String, CaseIterable {
    case bald = "bald", short = "short", medium = "medium", long = "long"
  }
  enum EyeColor: String, CaseIterable {
    case black = "black", brown = "brown", blue = "blue", green = "green"
  }
  enum FacialHair: String, CaseIterable {
    case mustache = "mustache", beard = "beard"
  }
  
  // `Face` is a `typealias` for type `(hairColor: HairColor, hairLength: HairLength, eyeColor: EyeColor, facialHair: Set<FacialHair>, glasses: Bool)`. A type alias declaration introduces a named alias of an existing type into your program; and each propety of the aliased type can be accessed through its alias via dot notation, ex. `face.hairColor`. A `Face`'s `hairColor`, `hairLength`, and `eyeColor` properties each hold a single enumeration case; `facialHair` holds a set containing both, one, or none of the facial hair options; and glasses holds a boolean that is true if the person wears glasses and false otherwise.
  
  typealias Face = (hairColor: HairColor, hairLength: HairLength, eyeColor: EyeColor, facialHair: Set<FacialHair>, glasses: Bool)

  // Topics
  // Both `Person`'s `likes` and `dislikes` are sets containing all, some, or none of `topics` enumeration cases.
  enum Topic: String, CaseIterable {
    
    case fashion = "fashion"
    case food = "food"
    case sports = "sports"
    case travel = "travel"
    case movies = "movies"
    case books = "books"
    case politics = "politics"
    case weather = "weather"
    case television = "television"
    case music = "music"
    case family = "family"
    case cars = "cars"
    case comedy = "comedy"
    
  }
}

// MARK: - Convenience extensions

extension String {
  // This method converts string representations of hair and eye colors into system `UIColors`.
  // (Blonde, the one color string option that does not have a `UIColor` with
  // the same name, is replaced with similar color "yellow", i.e. `UIColor.yellow`.)
  func color() -> UIColor? {
    let colorString = (self != "blonde" ? self : "yellow")
    let colorSelector = Selector(colorString + "Color")
    return UIColor.self.perform(colorSelector).takeUnretainedValue() as? UIColor
  }
}


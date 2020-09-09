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
 Defines the model for the `PeopleListViewController` type. This is in
 a separate file from the `PeopleListViewController` class so we can
 test it in isolation without having to import the view controller.
 */

import UIKit

class PeopleModel {
    
  // MARK: Property
  var people: [Person]
  
  // MARK: Initialization
  init(people: [Person]) {
    self.people = people
  }
  
  // Set of initial data to be used for the app's people data model upon launch.
  static var initial: PeopleModel {
    return PeopleModel(people: [
      Person(name: "Bob", face: (hairColor: .red, hairLength: .bald, eyeColor: .blue, facialHair: [.mustache, .beard], glasses: true), likes: [.weather], dislikes: [.travel, .television, .sports, .movies, .family, .fashion], tag: 1),
      Person(name: "Joan", face: (hairColor: .gray, hairLength: .short, eyeColor: .black, facialHair: [], glasses: false), likes: [.cars, .politics], dislikes: [.sports, .fashion], tag: 2),
      Person(name: "Sam", face: (hairColor: .blonde, hairLength: .long, eyeColor: .brown, facialHair: [.mustache], glasses: false), likes: [.music, .family, .fashion, .movies, .books], dislikes: [], tag: 3)
      ])
  }
}

/// Copyright (c) 2020 Razeware LLC
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
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

protocol ResultsTableViewDelegate: class {
  func didSelect(token: UISearchToken)
}

class ResultsTableViewController: UITableViewController {
  var countries: [Country]? {
    didSet {
      tableView.reloadData()
    }
  }
    
  var searchTokens: [UISearchToken] = []
  weak var delegate: ResultsTableViewDelegate?
    
  var isFilterByCountry: Bool {
    countries != nil
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    makeTokens()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return isFilterByCountry ? (countries?.count ?? 0) : searchTokens.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if isFilterByCountry, let cell = tableView.dequeueReusableCell(withIdentifier: "results", for: indexPath) as? CountryCell {
      cell.country = countries?[indexPath.row]
      return cell
    } else if let cell = tableView.dequeueReusableCell(withIdentifier: "search", for: indexPath) as? SearchTokenCell {
      cell.token = searchTokens[indexPath.row]
      return cell
    }
    return UITableViewCell()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard !isFilterByCountry else {
      return
    }
    
    delegate?.didSelect(token: searchTokens[indexPath.row])
  }
}

extension ResultsTableViewController {
  func makeTokens() {
    searchTokens = Continent.allCases.map({ (continent) -> UISearchToken in
      let globeImage = UIImage(systemName: "globe")
      let token = UISearchToken(icon: globeImage, text: continent.description)
      token.representedObject = Continent(rawValue: continent.rawValue)
      return token
    })
  }
}

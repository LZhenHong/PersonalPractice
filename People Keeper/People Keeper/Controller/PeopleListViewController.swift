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

/* Abstract:
 Defines the view controller responsible for showing the list of people.
 This view controller is the first view controller that appears in the
 application.
 */

class PeopleListViewController: UITableViewController {

  // MARK: - Properties
  
  // `peopleModel` serves as the table view's data model. It's initially set to the default data model defined in `PeopleModel.swift`.
  
  private var peopleModel = PeopleModel.initial
  
  // `tagNumber` keeps track of the last tag assigned to a `Person` object so that each `Person`'s `tag` property can be unique. It's initially set to `PeopleModel.initial.people.count` since the current objects in the data model each have tags matching their count in the model array and `PeopleModel.initial.people.count` is therefore the last tag assigned.
  
  private var tagNumber = PeopleModel.initial.people.count
  
  // `undoButton`, `redoButton` and `addNewPersonButton` are private to their class and defined lazily such that the closure waits to access `self` until after its known. `self` is then available as a target when setting each button's actions within its initial declaration.
  
  private lazy var undoButton: UIBarButtonItem = {
    let undoButton = UIBarButtonItem(barButtonSystemItem: .undo, target: self, action: #selector(undoTapped))
    undoButton.isEnabled = false
    return undoButton
  }()
  
  private lazy var redoButton: UIBarButtonItem = {
    let redoButton = UIBarButtonItem(barButtonSystemItem: .redo, target: self, action: #selector(redoTapped))
    redoButton.isEnabled = false
    return redoButton
  }()
  
  private lazy var addNewPersonButton: UIButton = {
    let addNewPersonButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 50)))
    addNewPersonButton.setTitle("Add New Person", for: .normal)
    addNewPersonButton.setTitleColor(.blue, for: .normal)
    addNewPersonButton.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 1.0, alpha: 1.0)
    addNewPersonButton.addTarget(self, action: #selector(addPersonTapped), for: .touchUpInside)
    return addNewPersonButton
  }()
  
  // `UIViewController` has a built-in `undoManager` property, so it needs to be overriden, i.e. `override var undoManager`, in order to set a stored undo manager instance for the `undoManager` property.
  
  private let _undoManager = UndoManager()
  override var undoManager: UndoManager {
    return _undoManager
  }
  
  // MARK: View Life Cycle
  override func viewDidLoad() {
    title = "People Keeper"
    navigationItem.leftBarButtonItem = undoButton
    navigationItem.rightBarButtonItem = redoButton
    tableView.register(UINib(nibName: "\(PersonCell.self)", bundle: nil), forCellReuseIdentifier: PersonCell.reuseIdentifier)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    becomeFirstResponder()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    resignFirstResponder()
  }
  
  override var canBecomeFirstResponder: Bool {
    true
  }
  
  @objc func redoTapped() {
    undoManager.redo()
  }
  
  @objc func undoTapped() {
    undoManager.undo()
  }
  
  @objc func addPersonTapped() {
    tagNumber += 1
    
    let person = Person(name: "", face: (hairColor: .black, hairLength: .bald, eyeColor: .black, facialHair: [], glasses: false), likes: [], dislikes: [], tag: tagNumber)
    modifyModel { peopleModel in
      peopleModel.people += [person]
    }
    tableView.selectRow(at: IndexPath(item: peopleModel.people.count - 1, section: 0), animated: true, scrollPosition: .bottom)
    showPersonDetails(at: IndexPath(item: peopleModel.people.count - 1, section: 0))
  }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension PeopleListViewController {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return peopleModel.people.count
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 180
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: PersonCell.reuseIdentifier, for: indexPath) as! PersonCell
    cell.person = peopleModel.people[indexPath.row]
    cell.nameTextField.isUserInteractionEnabled = false
    cell.isHidden = false // work around for apparent Apple bug
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    showPersonDetails(at: indexPath)
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let delete = UITableViewRowAction(style: .default, title: "Delete") { action, index in
      self.modifyModel { peopleModel in
        peopleModel.people.remove(at: indexPath.row)
      }
    }
    return [delete]
  }
  
  override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 50
  }
  
  override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return addNewPersonButton
  }
}

// MARK: - Segue Handling
extension PeopleListViewController {
  /// Called when a `Person` in the list is tapped.
  func showPersonDetails(at indexPath: IndexPath) {
    performSegue(withIdentifier: "showDetail", sender: nil)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let selectedIndex = tableView.indexPathForSelectedRow?.row else {
      return
    }
    let detailViewController = segue.destination as? PersonDetailViewController
    let person = peopleModel.people[selectedIndex]
    detailViewController?.setPerson(person)
    detailViewController?.personDidChange = { updatedPerson in
      self.modifyModel { peopleModel in
        peopleModel.people[selectedIndex] = updatedPerson
      }
    }
  }
}

extension PeopleListViewController {
  private func modifyModel(_ mutations: (inout PeopleModel) -> Void) {
    var peopleModel = self.peopleModel
    let oldModel = peopleModel
    mutations(&peopleModel)
    
    tableView.beginUpdates()
    let modelDiff = oldModel.diffed(with: peopleModel)
    peopleModelDidChange(diff: modelDiff)
    tableView.endUpdates()
  }
  
  private func peopleModelDidChange(diff: PeopleModel.Diff) {
    switch diff.peopleChange {
    case .inserted(let person):
      if let index = diff.to.people.firstIndex(of: person) {
        tableView.insertRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
      }
    case .removed(let person):
      if let index = diff.from.people.firstIndex(of: person) {
        tableView.deleteRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
      }
    case .updated(let person):
      if let index = diff.to.people.firstIndex(of: person) {
        tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
      }
    default:
      return
    }
    peopleModel = diff.to
    
    undoManager.registerUndo(withTarget: self) { target in
      target.modifyModel { model in
        model = diff.from
      }
      
      DispatchQueue.main.async {
        self.undoButton.isEnabled = self.undoManager.canUndo
        self.redoButton.isEnabled = self.undoManager.canRedo
      }
    }
  }
}

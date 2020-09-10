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

class PersonDetailViewController: UICollectionViewController {
  
  var personDidChange: ((Person) -> Void)?
  
  // MARK: - Properties
  
  // `person`'s properties serve as the collection view's data model.
  private var person: Person!
  
  func setPerson(_ person: Person) {
    self.person = person
  }
  
  // `undoButton`and `redoButton` are private to their class and defined lazily such that the closure waits to access `self` until after its known. `self` is then available as a target when setting each button's actions within its initial declaration.
  
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
  
  // `UIViewController` has a built-in `undoManager` property, so it needs to be overriden, i.e. `override var undoManager`, in order to set a stored undo manager instance for the `undoManager` property.
  
  private let _undoManager = UndoManager()
  override var undoManager: UndoManager {
    return _undoManager
  }
  
  // MARK: - Sections
  // The section enumeration represents each section of the collection view in order. Since the enumeration is of type `Int`, `Int` `rawValue`s are automatically assigned to each case in order starting from 0. For example, `case preview` = 0, `case hairColor` = 1, `case hairLength` = 2, etc.
  enum Section: Int, CaseIterable {
    case preview
    case hairColor
    case hairLength
    case facialHair
    case eyeColor
    case glasses
    case likes
    case dislikes
    
    // `Section` can be initialized using an index path; the section number of `indexPath` returns the `Section` case with a raw `Int` value equal to the `indexPath.section` value.
    init(at indexPath: IndexPath) {
      self.init(rawValue: indexPath.section)!
    }
    
    // `Section` can be initialized using a section number; the section number returns the `Section` case with a raw `Int` value equal to the `section` value.
    init(_ section: Int) {
      self.init(rawValue: section)!
    }
    
    // `numberOfItems` represents the number of items in each `Section` of the collection view.
    var numberOfItems: Int {
      switch self {
      // The preview section only contains a header, so there are 0 items displayed in the preview section.
      case .preview:
        return 0
      // The glasses section shows a single option, glasses, that can either be toggled on or off; so there is 1 item displays in the glasses section.
      case .glasses:
        return 1
      // Every other section holds the number of cases represented by its corresponding `Person` enum. Since each enum in `Person.swift` contains an `all` array holding all of its enumeration cases, each section of the collection view contains the number of items corresponding enum's `all`.
      case .hairColor:
        return Person.HairColor.allCases.count
      case .hairLength:
        return Person.HairLength.allCases.count
      case .facialHair:
        return Person.FacialHair.allCases.count
      case .eyeColor:
        return Person.EyeColor.allCases.count
      case .likes:
        return Person.Topic.allCases.count
      case .dislikes:
        return Person.Topic.allCases.count
      }
    }
  }
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.leftItemsSupplementBackButton = true
    navigationItem.leftBarButtonItem = undoButton
    navigationItem.rightBarButtonItem = redoButton

    collectionView?.register(UINib(nibName: "\(DetailCell.self)", bundle: nil), forCellWithReuseIdentifier: DetailCell.reuseIdentifier)
    collectionView?.allowsMultipleSelection = true
    
    // To resign the keyboard when the view's background is tapped
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
    tapGesture.cancelsTouchesInView = false
    view.addGestureRecognizer(tapGesture)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    becomeFirstResponder()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    // To resign the keyboard before returning to the previous view controller
    view.endEditing(true)
    
    resignFirstResponder()
    
    personDidChange?(person)
  }
  
  override var canBecomeFirstResponder: Bool {
    true
  }
  
  @objc func backgroundTapped() {
    view.endEditing(true)
  }
  
  @objc func undoTapped() {
    undoManager.undo()
  }
  
  @objc func redoTapped() {
    undoManager.redo()
  }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension PersonDetailViewController {
    
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return Section.allCases.count
  }
  
  override func collectionView(_ collectionView: UICollectionView,
      numberOfItemsInSection section: Int) -> Int {
    return Section(section).numberOfItems
  }
  
  override func collectionView(_ collectionView: UICollectionView,
      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCell.reuseIdentifier,
                                                  for: indexPath) as! DetailCell
    
    switch Section(at: indexPath) {
    case .hairColor:
      // Set the cell's `imageView` background color and `textLabel` title to represent the hair color option corresponding to the current `indexPath`.
      // If the class's `person` object's hair color is the same as the one at this hair color option's index, it's selected; otherwise it's not.
      cell.imageView.backgroundColor = Person.HairColor.allCases[indexPath.row].rawValue.color()
      cell.textLabel.text = Person.HairColor.allCases[indexPath.row].rawValue.capitalized
      cell.isSelected = person.face.hairColor == Person.HairColor.allCases[indexPath.row]
    case .hairLength:
      // Set the cell's `imageView` image and `textLabel` title to represent the hair length image file and descriptive name corresponding to the current `indexPath`.
      // The "[Hair Length]_hair" image in the assets catalog is set to render as a template image so that setting its tint will change any non-tranparent part of the image to that tint color. In this case, the image's tint color is set to that of the person's current `hairColor`.
      // If the class's `person`'s hair length equals the hair length option at this index, it's selected; otherwise it's not.
      cell.imageView.image = UIImage(named: Person.HairLength.allCases[indexPath.row].rawValue + "_hair")
      cell.imageView.tintColor = person.face.hairColor.rawValue.color()
      cell.textLabel.text = Person.HairLength.allCases[indexPath.row].rawValue.capitalized
      cell.isSelected = person.face.hairLength == Person.HairLength.allCases[indexPath.row]
    case .facialHair:
      // Set the cell's `imageView` image and `textLabel` title to represent the facial hair image file and descriptive name corresponding to the current `indexPath`.
      // The "[Facial Hair]" image in the assets catalog is set to render as a template image so that setting its tint will change any non-tranparent part of the image to that tint color. In this case, the image's tint color is set to that of the person's current `hairColor`.
      // If the class's `person`'s facial hair set contains the facial hair option at this index, it's selected; otherwise it's not.
      cell.imageView.image = UIImage(named: Person.FacialHair.allCases[indexPath.row].rawValue)
      cell.imageView.tintColor = person.face.hairColor.rawValue.color()
      cell.textLabel.text = Person.FacialHair.allCases[indexPath.row].rawValue.capitalized
      cell.isSelected = person.face.facialHair.contains(Person.FacialHair.allCases[indexPath.row])
    case .eyeColor:
      // Set the cell's `imageView` image to "eyes"; and since "eyes" is set to render as a template image, setting its tint to the eye color represented by the current index will display eyes of the corresponding color.
      // Set `textLabel` to display the name of the eye color represented by the current index.
      // If the class's `person`'s eye color equals the eye color option at this index, it's selected; otherwise it's not.
      cell.imageView.image = UIImage(named: "eyes")
      cell.imageView.tintColor = Person.EyeColor.allCases[indexPath.row].rawValue.color()
      cell.textLabel.text = Person.EyeColor.allCases[indexPath.row].rawValue.capitalized
      cell.isSelected = person.face.eyeColor == Person.EyeColor.allCases[indexPath.row]
    case .glasses:
      // Set the cell's `imageView` image to "glasses" and write "Glasses" in the cell's description `textLabel`.
      // If `person.face.glasses == true`, then the person is wearing glasses and the cell is selected to reflect that; otherwise if `person.face.glasses == false`, the cell is not selected.
      cell.imageView.image = UIImage(named: "glasses")
      cell.textLabel.text = "Glasses"
      cell.isSelected = person.face.glasses
    case .likes:
      // Set the cell's `textLabel` to the topic string at the current index.
      // If `person`'s set of `likes` contains the topic at `indexPath`, it's selected; otherwise it's not.
      cell.textLabel.text = Person.Topic.allCases[indexPath.row].rawValue.capitalized
      cell.isSelected = person.likes.contains(Person.Topic.allCases[indexPath.row])
    case .dislikes:
      // Set the cell's `textLabel` to the topic string at the current index.
      // If `person`'s set of `dilikes` contains the topic at `indexPath`, it's selected; otherwise it's not.
      cell.textLabel.text = Person.Topic.allCases[indexPath.row].rawValue.capitalized
      cell.isSelected = person.dislikes.contains(Person.Topic.allCases[indexPath.row])
    default:
      break
    }
    
    // If the cell has been set to selected, also select it within the collectionView
    if cell.isSelected {
      collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
    }
    // If the cell is not selected, deselect it within the collectionView
    else {
      collectionView.deselectItem(at: indexPath, animated: false)
    }
    
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView,
      viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
    if kind == UICollectionView.elementKindSectionHeader,
      let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
          withReuseIdentifier: PersonDetailHeaderView.reuseIdentifier, for: indexPath) as? PersonDetailHeaderView {

      switch Section(at: indexPath) {
        
      // The preview section's header contains a `PersonCell` subview which, as it also does in `PeopleListViewController`'s table view cells, displays an image composite of the person's features and their name, likes and dislikes.
      // Unlike the nameTextField in `PeopleListViewController`'s `PersonCell`'s, the field remains editable and has a rounded rectangular border to draw focus to that fact that it's editable.
      case .preview:
        let personCellNib = UINib(nibName: "PersonCell", bundle: nil)
        let previewTableViewCell = personCellNib.instantiate(withOwner: self, options: nil).first as! PersonCell
        previewTableViewCell.nameTextField.font = UIFont.systemFont(ofSize: 18)
        previewTableViewCell.nameTextField.borderStyle = .roundedRect
        previewTableViewCell.nameTextField.delegate = self
        previewTableViewCell.person = person
        previewTableViewCell.frame = headerView.previewView.bounds
        previewTableViewCell.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        headerView.previewView.addSubview(previewTableViewCell)
        
      // The header of every other section simply displays the section category
      case .hairColor:
        headerView.textLabel.text = "Hair Color"
      case .hairLength:
        headerView.textLabel.text = "Hair Length"
      case .facialHair:
        headerView.textLabel.text = "Facial Hair"
      case .eyeColor:
        headerView.textLabel.text = "Eye Color"
      case .glasses:
        headerView.textLabel.text = "Glasses"
      case .likes:
        headerView.textLabel.text = "Likes"
      case .dislikes:
        headerView.textLabel.text = "Dislikes"
      }
      return headerView
    }
    
    return UICollectionReusableView()
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    modifyPerson { person in
      switch Section(at: indexPath) {
      case .hairColor:
        person.face.hairColor = Person.HairColor.allCases[indexPath.row]
      case .hairLength:
        person.face.hairLength = Person.HairLength.allCases[indexPath.row]
      case .eyeColor:
        person.face.eyeColor = Person.EyeColor.allCases[indexPath.row]
      case .glasses:
        person.face.glasses = true
      case .facialHair:
        person.face.facialHair.insert(Person.FacialHair.allCases[indexPath.row])
      case .likes:
        person.likes.insert(Person.Topic.allCases[indexPath.row])
        person.dislikes.remove(Person.Topic.allCases[indexPath.row])
      case .dislikes:
        person.likes.remove(Person.Topic.allCases[indexPath.row])
        person.dislikes.insert(Person.Topic.allCases[indexPath.row])
      default:
        break
      }
    }
  }
  
  override func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
    switch Section(at: indexPath) {
    case .facialHair, .glasses, .likes, .dislikes:
      return true
    default:
      return false
    }
  }
  
  override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    modifyPerson { person in
      switch Section(at: indexPath) {
      case .facialHair:
        person.face.facialHair.subtract([Person.FacialHair.allCases[indexPath.row]])
      case .likes:
        person.likes.subtract([Person.Topic.allCases[indexPath.row]])
      case .dislikes:
        person.dislikes.subtract([Person.Topic.allCases[indexPath.row]])
      case .glasses:
        person.face.glasses = false
      default:
        break
      }
    }
  }
}

extension PersonDetailViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                      referenceSizeForHeaderInSection section: Int) -> CGSize {
    switch Section(section).rawValue {
    case 0:
      // The preview section header size
      return CGSize(width: collectionView.bounds.width, height: 250)
    default:
      // Every other header size
      return CGSize(width: collectionView.bounds.width, height: 80)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
      sizeForItemAt indexPath: IndexPath) -> CGSize {
    switch Section(at: indexPath) {
    case .dislikes, .likes:
      // Likes and dislike collection view item size
      return CGSize(width: self.view.frame.size.width/3 - 10, height: 40)
    default:
      // Hair color, hair length, facial hair, eye color, and glasses item size
      return CGSize(width: self.view.frame.size.width/3 - 10, height: 150)
    }
  }
}

extension PersonDetailViewController: UITextFieldDelegate {
  // Resign the keyboard when the user taps the return button
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if let text = textField.text {
      let fromPerson: Person = person
      person.name = text
      personDidChange(diff: fromPerson.diffed(with: person))
    }
  }
}

// MARK: - Model & State Types
extension PersonDetailViewController {
  
  private func modifyPerson(_ mutatePerson: (inout Person) -> Void) {
    var person: Person = self.person
    let oldPerson = person
    mutatePerson(&person)
    let personDiff = oldPerson.diffed(with: person)
    personDidChange(diff: personDiff)
  }
  
  private func personDidChange(diff: Person.Diff) {
    guard diff.hasChanges else {
      return
    }
    
    person = diff.to
    collectionView?.reloadData()
    
    undoManager.registerUndo(withTarget: self) { target in
      target.modifyPerson { person in
        person = diff.from
      }
    }
    
    DispatchQueue.main.async {
      self.undoButton.isEnabled = self.undoManager.canUndo
      self.redoButton.isEnabled = self.undoManager.canRedo
    }
  }
  
}

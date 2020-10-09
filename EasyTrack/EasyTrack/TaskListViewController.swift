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

class TaskListViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var balloon: Balloon!
  
  var taskList: [Task] = []
  
  var timer: Timer?
  
  var animationTimer: Timer?
  var startTime: TimeInterval?
  var endTime: TimeInterval?
  var animationDuration = 3.0
  var height: CGFloat = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
      target: self,
      action: #selector(presentAlertController))
  }
}

// MARK: - UITableViewDelegate
extension TaskListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewCell else {
      return
    }
    
    cell.updateState()
  }
}

// MARK: - UITableViewDataSource
extension TaskListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return taskList.count
  }
  
  func tableView(_ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
    
    if let cell = cell as? TaskTableViewCell {
      cell.task = taskList[indexPath.row]
    }
    
    return cell
  }
}

// MARK: - Actions
extension TaskListViewController {
  @objc func presentAlertController(_ sender: UIBarButtonItem) {
    createTimer()
    
    let alertController = UIAlertController(title: "Task name",
      message: nil,
      preferredStyle: .alert)
    alertController.addTextField { textField in
      textField.placeholder = "Task name"
      textField.autocapitalizationType = .sentences
    }
    let createAction = UIAlertAction(title: "OK", style: .default) {
      [weak self, weak alertController] _ in
      guard
        let self = self,
        let text = alertController?.textFields?.first?.text
        else {
          return
      }
      
      DispatchQueue.main.async {
        let task = Task(name: text)
        
        self.taskList.append(task)
        
        let indexPath = IndexPath(row: self.taskList.count - 1, section: 0)
        
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [indexPath], with: .top)
        self.tableView.endUpdates()
      }
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    alertController.addAction(createAction)
    alertController.addAction(cancelAction)
    
    present(alertController, animated: true, completion: nil)
  }
}

extension TaskListViewController {
  func createTimer() {
    if self.timer == nil {
      let timer = Timer.scheduledTimer(timeInterval: 1.0,
                                   target: self,
                                   selector: #selector(updateTimer),
                                   userInfo: nil,
                                   repeats: true)
      timer.tolerance = 0.1
      RunLoop.current.add(timer, forMode: .common)
      
      self.timer = timer
    }
  }
  
  @objc func updateTimer() {
    guard let visibleRowsIndexPaths = tableView.indexPathsForVisibleRows else {
      return
    }
    
    for indexPath in visibleRowsIndexPaths {
      if let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewCell {
        cell.updateTime()
      }
    }
  }
}

extension TaskListViewController {
  func showCongratulationAnimation() {
    height = UIScreen.main.bounds.height + balloon.frame.height
    balloon.center = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: balloon.frame.height * 0.5 + height)
    balloon.isHidden = false
    
    startTime = Date().timeIntervalSince1970
    endTime = startTime! + animationDuration
    
    animationTimer = Timer.scheduledTimer(withTimeInterval: 1 / 60, repeats: true) { timer in
      self.updateAnimation()
    }
  }
  
  func updateAnimation() {
    guard let startTime = startTime, let endTime = endTime else {
      return
    }
    let now = Date().timeIntervalSince1970
    
    if now >= endTime {
      animationTimer?.invalidate()
      balloon.isHidden = true
    }
    
    let percent = (now - startTime) / animationDuration * 100
    let y = height - ((height + balloon.frame.height / 2) / 100 * CGFloat(percent))
    balloon.center = CGPoint(x: balloon.center.x + CGFloat.random(in: -0.5...0.5), y: y)
  }
}

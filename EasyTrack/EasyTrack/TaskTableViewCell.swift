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

class TaskTableViewCell: UITableViewCell {
  
  @IBOutlet weak var taskLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  
  var task: Task? {
    didSet {
      taskLabel.text = task?.name
      setState()
      updateTime()
    }
  }
  
  func updateState() {
    guard let task = task else {
      return
    }
    
    task.completed.toggle()
    
    setState()
    updateTime()
  }
  
  func updateTime() {
    guard let task = task else {
      return
    }
    
    if task.completed {
      timeLabel.text = "Completed"
    } else {
      let time = Date().timeIntervalSince(task.creationDate)
      
      let hours = Int(time) / 3600
      let minutes = Int(time) / 60 % 60
      let seconds = Int(time) % 60
      
      var times: [String] = []
      if hours > 0 {
        times.append("\(hours)h")
      }
      if minutes > 0 {
        times.append("\(minutes)m")
      }
      times.append("\(seconds)s")
      
      timeLabel.text = times.joined(separator: " ")
    }
  }
  
  private func setState() {
    guard let task = task else {
      return
    }
    
    if task.completed {
      taskLabel.attributedText = NSAttributedString(string: task.name,
        attributes: [.strikethroughStyle: 1])
    } else {
      taskLabel.attributedText = NSAttributedString(string: task.name,
        attributes: nil)
    }
  }
}

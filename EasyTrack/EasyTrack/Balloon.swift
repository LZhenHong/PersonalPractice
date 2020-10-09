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

@IBDesignable class Balloon: UIView {
  override func draw(_ rect: CGRect) {
    let balloonColor = UIColor(named: "rw-green") ?? UIColor.green
    let cordColor = UIColor(named: "rw-dark") ?? UIColor.black
    
    let ovalPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 66, height: 93))
    balloonColor.setFill()
    ovalPath.fill()
    
    let trianglePath = UIBezierPath()
    trianglePath.move(to: CGPoint(x: 33, y: 81.5))
    trianglePath.addLine(to: CGPoint(x: 42.96, y: 98.75))
    trianglePath.addLine(to: CGPoint(x: 23.04, y: 98.75))
    trianglePath.close()
    balloonColor.setFill()
    trianglePath.fill()
    
    let cordPath = UIBezierPath()
    cordPath.move(to: CGPoint(x: 33.29, y: 98.5))
    cordPath.addCurve(to: CGPoint(x: 33.29, y: 126.5),
      controlPoint1: CGPoint(x: 33.29, y: 98.5),
      controlPoint2: CGPoint(x: 27.01, y: 114.06))
    cordPath.addCurve(to: CGPoint(x: 33.29, y: 157.61),
      controlPoint1: CGPoint(x: 39.57, y: 138.94),
      controlPoint2: CGPoint(x: 39.57, y: 145.17))
    cordPath.addCurve(to: CGPoint(x: 33.29, y: 182.5),
      controlPoint1: CGPoint(x: 27.01, y: 170.06),
      controlPoint2: CGPoint(x: 33.29, y: 182.5))
    cordColor.setStroke()
    cordPath.lineWidth = 1
    cordPath.stroke()
  }
}

// MIT License
//
// Copyright (c) 2019 Anton Yereshchenko
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

extension CALayer {
  
  private static var kCutLayerName: String {
    return "kCutLayerName"
  }
  
  func addCutLayer(with configuration: AYCodesScannerAreaConfiguration) {
    addCutLayer(with: configuration.center(with: bounds),
                opacity: configuration.opacity,
                color: configuration.color,
                cornerRadius: configuration.cornerRadius)
  }
  
  func addCutLayer(with rect: CGRect, opacity: CGFloat = 0.32, color: UIColor = UIColor.black, cornerRadius: CGFloat) {
    guard layer(by: CALayer.kCutLayerName) == nil else { return }

    let path = UIBezierPath(rect: bounds)
    let mask = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
    path.append(mask)
    
    let fillLayer = CAShapeLayer()
    fillLayer.name = CALayer.kCutLayerName
    fillLayer.path = path.cgPath
    fillLayer.fillRule = .evenOdd
    fillLayer.fillColor = color.cgColor
    fillLayer.opacity = Float(opacity)
    addSublayer(fillLayer)
  }
  
  func removeCutLayer() {
    guard let layer = layer(by: CALayer.kCutLayerName) else { return }
    layer.removeFromSuperlayer()
  }
  
  func layer(by name: String) -> CALayer? {
    guard let sublayers = sublayers else { return nil }
    for layer in sublayers {
      if let layer = layer as? CAShapeLayer,
        layer.name == CALayer.kCutLayerName {
          return layer
      }
    }
    return nil
  }
  
}


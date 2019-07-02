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

import Foundation
import AVFoundation.AVMetadataObject

// MARK: - AYCodesScannerAreaConfiguration -
public struct AYCodesScannerAreaConfiguration {
  public var size: CGSize
  public var opacity: CGFloat
  public var color: UIColor
  public var cornerRadius: CGFloat
  
  public static func defaultConfig() -> AYCodesScannerAreaConfiguration {
    return AYCodesScannerAreaConfiguration(with: CGSize(width: 100, height: 100),
                                           opacity: 0.32,
                                           color: UIColor.black,
                                           cornerRadius: 8.0)
  }
  
  public init(with size: CGSize, opacity: CGFloat, color: UIColor, cornerRadius: CGFloat) {
    self.size = size
    self.opacity = opacity
    self.color = color
    self.cornerRadius = cornerRadius
  }
  
  func center(with frame: CGRect) -> CGRect {
    let center = CGPoint(x: frame.width / 2, y: frame.height / 2)
    return CGRect(x: center.x - size.width / 2,
                  y: center.y - size.height / 2,
                  width: size.width,
                  height: size.height)
  }
}

// MARK: - AYCodesScannerButtonConfiguration -
public struct AYCodesScannerButtonConfiguration {
  public var onText: String?
  public var offText: String?
  public var onImage: UIImage?
  public var offImage: UIImage?
  
  public init(with onText: String, offText: String? = nil) {
    self.onText = onText
    self.offText = offText == nil ? onText : offText
  }
  
  public init(with onImage: UIImage?, offImage: UIImage? = nil) {
    self.onImage = onImage
    self.offImage = offImage == nil ? onImage : offImage
  }
}

// MARK: - AYCodesScannerViewConfiguration -
public struct AYCodesScannerViewConfiguration {
  public var area: AYCodesScannerAreaConfiguration?
  public var btnTorchConf: AYCodesScannerButtonConfiguration?
  public var btnCameraConf: AYCodesScannerButtonConfiguration?
  public var btnCancelConf: AYCodesScannerButtonConfiguration?
  
  public static func defaultConfig() -> AYCodesScannerViewConfiguration {
    return AYCodesScannerViewConfiguration(
      with: AYCodesScannerAreaConfiguration.defaultConfig(),
      btnTorchConf: AYCodesScannerButtonConfiguration(with: "Torch", offText: nil),
      btnCameraConf: AYCodesScannerButtonConfiguration(with: "Camera", offText: nil),
      btnCancelConf: AYCodesScannerButtonConfiguration(with: "Cancel", offText: nil))
  }
  
  public init(
    with area: AYCodesScannerAreaConfiguration,
    btnTorchConf: AYCodesScannerButtonConfiguration?,
    btnCameraConf: AYCodesScannerButtonConfiguration?,
    btnCancelConf: AYCodesScannerButtonConfiguration?) {
    self.area = area
    self.btnTorchConf = btnTorchConf
    self.btnCameraConf = btnCameraConf
    self.btnCancelConf = btnCancelConf
  }
}

// MARK: - AYCodesScannerDataConfiguration -
public struct AYCodesScannerDataConfiguration {
  public var codes: [AVMetadataObject.ObjectType]
  
  public static func defaultConfig() -> AYCodesScannerDataConfiguration {
    return AYCodesScannerDataConfiguration(with: [.qr, .ean8, .ean13])
  }
  
  public init(with codes: [AVMetadataObject.ObjectType]) {
    self.codes = codes
  }
  
  public init(with code: AVMetadataObject.ObjectType) {
    self.codes = [code]
  }
}

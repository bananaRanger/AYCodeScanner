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

// MARK: - AYCodesScannerConfiguratorProtocol -
protocol AYCodesScannerConfiguratorProtocol {
  static func config(
    with viewConfiguration: AYCodesScannerViewConfiguration?,
    dataConfiguration: AYCodesScannerDataConfiguration,
    completionHandler: @escaping AYCodesScannerCompletionHandler,
    dismissHandler: @escaping AYCodesScannerDismissHandler) -> AYCodesScannerViewController
}

// MARK: - AYCodesScannerPresenterProtocol -
protocol AYCodesScannerPresenterProtocol {
  func isCameraAccessAllowed(handler: @escaping (Bool) -> ())
  func viewDidLoad()
  func startCameraSession()
  func stopCameraSession()
  func updateRectOfInterest(with rect: CGRect)
  func changeCamera(orientation: UIDeviceOrientation)
  func changeCamera(bounds: CGRect)
  func changeTorchState()
  func changeCameraType()
  func detected(code: String?)
  func cameraIsNotAllow()
  func canceled()
}

// MARK: - AYCodesScannerViewProtocol -
protocol AYCodesScannerViewProtocol {
  func showError(_ text: String, with actionHandler: (() -> ())?)
  func addCamera(layer: CALayer)
  func changeTorchState(isOn: Bool)
  func changeCameraType(isFront: Bool)
  func changeTorchEnable(isEnable: Bool)
  func configCancelButton()
}

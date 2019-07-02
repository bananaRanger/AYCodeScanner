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

public class AYCodesScannerViewController: UIViewController {
  @IBOutlet weak var btnTorch: UIButton!
  @IBOutlet weak var btnCamera: UIButton!
  @IBOutlet weak var btnCancel: UIButton!

  var viewConfig: AYCodesScannerViewConfiguration?

  var presenter: AYCodesScannerPresenterProtocol?
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    if viewConfig == nil {
      viewConfig = AYCodesScannerViewConfiguration.defaultConfig()
    }
    
    if presenter == nil {
      AYCodesScannerConfigurator.defaultConfig(for: self)
    }
    
    presenter?.isCameraAccessAllowed(handler: { [weak self] (result) in
      if result {
        self?.presenter?.viewDidLoad()
      } else {
        self?.presenter?.cameraIsNotAllow()
      }
    })
  }
  
  override public func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    presenter?.startCameraSession()
    if let rect = viewConfig?.area?.center(with: view.frame) {
      presenter?.updateRectOfInterest(with: rect)
    }
  }
  
  override public func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    presenter?.stopCameraSession()
  }
  
}

// MARK: - Orientation -
extension AYCodesScannerViewController {
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    presenter?.changeCamera(orientation: UIDevice.current.orientation)
    presenter?.changeCamera(bounds: view.bounds)
    if let area = viewConfig?.area {
      view.layer.addCutLayer(with: area)
    }
  }
  
  public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    if let rect = viewConfig?.area?.center(with: view.frame) {
      presenter?.updateRectOfInterest(with: rect)
      view.layer.removeCutLayer()
    }
  }
  
}

// MARK: - @IBAction -
extension AYCodesScannerViewController {
  @IBAction func btnTorchTouchUpInside(sender: UIButton) {
    presenter?.changeTorchState()
  }
  
  @IBAction func btnCameraTouchUpInside(sender: UIButton) {
    presenter?.changeCameraType()
  }
  
  @IBAction func btnCancelTouchUpInside(sender: UIButton) {
    presenter?.canceled()
  }
}

// MARK: - AYCodesScannerViewProtocol -
extension AYCodesScannerViewController: AYCodesScannerViewProtocol {
  func showError(_ text: String, with actionHandler: (() -> ())?) {
    showWarningAlert(with: text, handler: actionHandler)
  }
  
  func addCamera(layer: CALayer) {
    layer.frame = view.layer.bounds
    view.layer.insertSublayer(layer, at: 0)
  }
  
  func changeTorchState(isOn: Bool) {
    configuration(button: btnTorch, with: isOn, and: viewConfig?.btnTorchConf)
  }
  
  func changeCameraType(isFront: Bool) {
    configuration(button: btnCamera, with: isFront, and: viewConfig?.btnCameraConf)
    if isFront {
      transitionFlipFromLeftAnimation(with: 0.32)
    } else {
      transitionFlipFromRightAnimation(with: 0.32)
    }
  }
  
  func changeTorchEnable(isEnable: Bool) {
    btnTorch.isEnabled = isEnable
    btnTorch.alpha = isEnable ? 1.0 : 0.64
  }
  
  func configCancelButton() {
    configuration(button: btnCancel, with: true, and: viewConfig?.btnCancelConf)
  }
}

// MARK: - Private methods -
extension AYCodesScannerViewController {
  private func configuration(button: UIButton,
                             with state: Bool,
                             and config: AYCodesScannerButtonConfiguration?) {
    let image = state ? config?.onImage : config?.offImage
    let text = state ? config?.onText : config?.offText
    button.setImage(image, for: .normal)
    button.imageView?.contentMode = .scaleAspectFit
    button.setTitle(text, for: .normal)
  }
  
  private func transitionFlipFromLeftAnimation(with duration: TimeInterval) {
    UIView.transition(with: view, duration: duration, options: .transitionFlipFromLeft, animations: nil, completion: nil)
  }
  
  private func transitionFlipFromRightAnimation(with duration: TimeInterval) {
    UIView.transition(with: view, duration: duration, options: .transitionFlipFromRight, animations: nil, completion: nil)
  }
}

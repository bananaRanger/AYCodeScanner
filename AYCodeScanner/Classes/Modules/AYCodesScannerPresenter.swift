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

import AVFoundation

class AYCodesScannerPresenter: NSObject {
  var view: AYCodesScannerViewProtocol?
  
  var data: AYCodesScannerDataConfiguration
  
  var completioHandler: AYCodesScannerCompletionHandler?
  var dismissHandler: AYCodesScannerDismissHandler?
  
  var captureSession: AVCaptureSession?
  var videoCaptureDevice: AVCaptureDevice?
  var previewLayer: AVCaptureVideoPreviewLayer?
  var metadataOutput = AVCaptureMetadataOutput()
  
  init(with view: AYCodesScannerViewProtocol,
       data: AYCodesScannerDataConfiguration) {
    self.view = view
    self.data = data
  }
}

// MARK: - AYCodesScannerPresenterProtocol -
extension AYCodesScannerPresenter: AYCodesScannerPresenterProtocol {
  func isCameraAccessAllowed(handler: @escaping (Bool) -> ()) {
    if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
      DispatchQueue.main.async {
        handler(true)
      }
    } else {
      AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
        DispatchQueue.main.async {
          handler(granted)
        }
      })
    }
  }
  
  func viewDidLoad() {
    captureSession = AVCaptureSession()
    
    guard let device = AVCaptureDevice.default(for: .video) else {
      view?.showError("Doesn't have access to the camera", with: nil)
      return
    }
    
    let videoInput: AVCaptureDeviceInput
    do {
      videoInput = try AVCaptureDeviceInput(device: device)
    } catch {
      view?.showError(error.localizedDescription, with: nil)
      return
    }
    
    videoCaptureDevice = device
    
    if let captureSession = captureSession {
      
      guard captureSession.canAddInput(videoInput) else {
        view?.showError("Doesn't have access to the camera", with: nil)
        return
      }
      
      captureSession.addInput(videoInput)

      guard captureSession.canAddOutput(metadataOutput) else {
        view?.showError("Doesn't have access to the camera", with: nil)
        return
      }
      
      captureSession.addOutput(metadataOutput)
      metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
      metadataOutput.metadataObjectTypes = data.codes
      
      previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
      if let previewLayer = previewLayer {
        previewLayer.videoGravity = .resizeAspectFill
        view?.addCamera(layer: previewLayer)
      }
      
    }
    
    view?.changeTorchState(isOn: isTorchActive())
    view?.changeCameraType(isFront: device.position == .front)
    view?.configCancelButton()
    
    startCameraSession()
  }
  
  func startCameraSession() {
    if captureSession?.isRunning == false {
      captureSession?.startRunning()
    }
  }
  
  func stopCameraSession() {
    if captureSession?.isRunning == true {
      captureSession?.stopRunning()
    }
  }
  
  func updateRectOfInterest(with rect: CGRect) {
    guard let visibleRect = previewLayer?.metadataOutputRectConverted(fromLayerRect: rect) else { return }
    metadataOutput.rectOfInterest = visibleRect
  }
  
  func changeCamera(orientation: UIDeviceOrientation) {
    guard let connection = previewLayer?.connection, connection.isVideoOrientationSupported else { return }
    connection.videoOrientation = UIDevice.current.orientation.toAVCaptureVideoOrientation()
  }
  
  func changeCamera(bounds: CGRect) {
    previewLayer?.frame = bounds
  }
  
  func changeTorchState() {
    do {
      try videoCaptureDevice?.lockForConfiguration()
    } catch {
      view?.showError(error.localizedDescription, with: nil)
    }
    
    guard videoCaptureDevice?.isTorchAvailable == true else {
      view?.showError("Torch is not available on current device", with: nil)
      return
    }
    
    let isActive = videoCaptureDevice?.isTorchActive ?? false
    videoCaptureDevice?.torchMode = (isActive ? .off : .on)
    view?.changeTorchState(isOn: isActive)
    
    videoCaptureDevice?.unlockForConfiguration()
  }
  
  func changeCameraType() {
    if let currentCameraInput: AVCaptureInput = captureSession?.inputs.first {
      captureSession?.removeInput(currentCameraInput)
      
      guard let input = currentCameraInput as? AVCaptureDeviceInput else { return }
      
      let nextDevice: AVCaptureDevice.Position = (input.device.position == .back) ? .front : .back
      videoCaptureDevice = cameraWithPosition(nextDevice)
      view?.changeCameraType(isFront: nextDevice == .front)
      view?.changeTorchEnable(isEnable: nextDevice == .back)

      do {
        if let device = videoCaptureDevice {
          try captureSession?.addInput(AVCaptureDeviceInput(device: device))
        }
      } catch {
        view?.showError(error.localizedDescription, with: nil)
      }
    }
  }
  
  func detected(code: String?) {
    if let completioHandler = completioHandler,
      let viewController = view as? UIViewController {
      completioHandler(code, viewController)
    }
  }
  
  func cameraIsNotAllow() {
    view?.showError("Doesn't have access to the camera", with: { [weak self] in
      self?.canceled()
    })
  }
  
  func canceled() {
    if let dismissHandler = dismissHandler,
      let viewController = view as? UIViewController {
      dismissHandler(viewController)
    }
  }
  
  private func isTorchActive() -> Bool {
    return videoCaptureDevice?.isTorchActive ?? false
  }
  
  private func cameraWithPosition(_ position: AVCaptureDevice.Position) -> AVCaptureDevice? {
    let deviceDescoverySession = AVCaptureDevice.DiscoverySession(
      deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera],
      mediaType: AVMediaType.video,
      position: AVCaptureDevice.Position.unspecified)
    
    for device in deviceDescoverySession.devices {
      if device.position == position {
        return device
      }
    }
    return nil
  }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate -
extension AYCodesScannerPresenter: AVCaptureMetadataOutputObjectsDelegate {
  public func metadataOutput(
    _ output: AVCaptureMetadataOutput,
    didOutput metadataObjects: [AVMetadataObject],
    from connection: AVCaptureConnection) {
    
    stopCameraSession()
    var message: String? = nil
    if let metadataObject = metadataObjects.first {
      guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
      message = readableObject.stringValue
    }
    detected(code: message)
  }
}

// MARK: - UIDeviceOrientation extension -
extension UIDeviceOrientation {
  func toAVCaptureVideoOrientation() -> AVCaptureVideoOrientation {
    switch self {
    case .portrait:
      return .portrait
    case .landscapeRight:
      return .landscapeLeft
    case .landscapeLeft:
      return .landscapeRight
    case .portraitUpsideDown:
      return .portraitUpsideDown
    default:
      return .portrait
    }
  }
}

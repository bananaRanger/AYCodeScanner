//
//  ViewController.swift
//  AYCodeScanner
//
//  Created by antonyereshchenko@gmail.com on 07/02/2019.
//  Copyright (c) 2019 antonyereshchenko@gmail.com. All rights reserved.
//

import UIKit
import AVFoundation
import AYCodeScanner

class ViewController: UIViewController {
  
  @IBOutlet weak var lblMessage: UILabel!
  @IBOutlet weak var btnScan: UIButton!
  
  @IBAction func btnScanTouchUpInside(_ sender: Any) {
    let codes: [AVMetadataObject.ObjectType] = [.ean8, .ean13, .qr]
    showScanViewController(with: codes)
  }
  
  private func showScanViewController(with codes: [AVMetadataObject.ObjectType]) {
    
    let dataConfig = AYCodesScannerDataConfiguration(with: codes)
    
    let areaConfig = AYCodesScannerAreaConfiguration.defaultConfig()
    
    let torchButtonConfig = AYCodesScannerButtonConfiguration(
      with: UIImage(named: "torchOn"),
      offImage: UIImage(named: "torchOff")
    )
    let cameraButtonConfig = AYCodesScannerButtonConfiguration(
      with: UIImage(named: "cameraImage")
    )
    let closeButtonConfig = AYCodesScannerButtonConfiguration(
      with: UIImage(named: "closeImage")
    )
    
    let viewConfig = AYCodesScannerViewConfiguration(
      with: areaConfig,
      btnTorchConf: torchButtonConfig,
      btnCameraConf: cameraButtonConfig,
      btnCancelConf: closeButtonConfig
    )
    
    let scannerController = AYCodesScannerConfigurator.config(
      with: viewConfig,
      dataConfiguration: dataConfig,
      completionHandler: { [weak self] message, viewController in
        self?.lblMessage.text = message ?? "unknown"
        viewController.dismiss(animated: true, completion: nil)
      }, dismissHandler: { viewController in
        viewController.dismiss(animated: true, completion: nil)
    })
    
    present(scannerController, animated: true, completion: nil)
  }
}


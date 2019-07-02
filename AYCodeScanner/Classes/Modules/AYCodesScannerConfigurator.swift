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

public typealias AYCodesScannerCompletionHandler = (String?, UIViewController) -> ()
public typealias AYCodesScannerDismissHandler = (UIViewController) -> ()

public class AYCodesScannerConfigurator: AYCodesScannerConfiguratorProtocol {
  public static func config(
    with viewConfiguration: AYCodesScannerViewConfiguration?,
    dataConfiguration: AYCodesScannerDataConfiguration,
    completionHandler: @escaping AYCodesScannerCompletionHandler,
    dismissHandler: @escaping AYCodesScannerDismissHandler) -> AYCodesScannerViewController {
    
    let bundle = Bundle(for: AYCodesScannerConfigurator.self)
    let viewController = AYCodesScannerViewController(nibName: nil, bundle: bundle)
    let presenter = AYCodesScannerPresenter(with: viewController, data: dataConfiguration)
    presenter.completioHandler = completionHandler
    presenter.dismissHandler = dismissHandler
    viewController.viewConfig = viewConfiguration
    viewController.presenter = presenter
    return viewController
  }
  
  static func defaultConfig(for viewController: AYCodesScannerViewController) {
    let codes = AYCodesScannerDataConfiguration.defaultConfig()
    let presenter = AYCodesScannerPresenter(with: viewController, data: codes)
    viewController.presenter = presenter
  }
}

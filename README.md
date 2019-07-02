# AYCodeScanner

[![CI Status](https://img.shields.io/travis/antonyereshchenko@gmail.com/AYCodeScanner.svg?style=flat)](https://travis-ci.org/antonyereshchenko@gmail.com/AYCodeScanner)
[![Version](https://img.shields.io/cocoapods/v/AYCodeScanner.svg?style=flat)](https://cocoapods.org/pods/AYCodeScanner)
[![License](https://img.shields.io/cocoapods/l/AYCodeScanner.svg?style=flat)](https://cocoapods.org/pods/AYCodeScanner)
[![Platform](https://img.shields.io/cocoapods/p/AYCodeScanner.svg?style=flat)](https://cocoapods.org/pods/AYCodeScanner)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

❕ Don't forget add permission in project Info.plist

**Key:** Privacy - Camera Usage Description

**Value:** $(PRODUCT_NAME) needs the camera

## Installation

SheetViewController is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
inhibit_all_warnings!

target 'YOUR-TARGET-NAME' do
  use_frameworks!
	pod 'AYCodeScanner'
end
```

## Usage

```swift
// 'viewConfig' - the object of class 'AYCodesScannerViewConfiguration'.
// 'dataConfig' - the object of class 'AYCodesScannerDataConfiguration'.

let scannerController = AYCodesScannerConfigurator.config(
  with: viewConfig,
  dataConfiguration: dataConfig,
  completionHandler: { [weak self] message, viewController in
    print(message ?? "unknown")
    viewController.dismiss(animated: true, completion: nil)
  }, dismissHandler: { viewController in
    viewController.dismiss(animated: true, completion: nil)
})
    
present(scannerController, animated: true, completion: nil)
```

## Author

Anton Yereshchenko

## License

AYCodeScanner is available under the MIT license. See the LICENSE file for more info.

## Used in project

Icons:

Icons8 - https://icons8.com

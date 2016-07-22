# AppAnalyticsSwift

[![CI Status](http://img.shields.io/travis/appanalytic/lib-swift.svg?style=flat)](https://travis-ci.org/appanalytic/lib-swift)
[![Version](https://img.shields.io/cocoapods/v/AppAnalyticsSwift.svg?style=flat)](http://cocoapods.org/pods/AppAnalyticsSwift)
[![License](https://img.shields.io/cocoapods/l/AppAnalyticsSwift.svg?style=flat)](http://cocoapods.org/pods/AppAnalyticsSwift)
[![Platform](https://img.shields.io/cocoapods/p/AppAnalyticsSwift.svg?style=flat)](http://cocoapods.org/pods/AppAnalyticsSwift)

## Example
To run the example project:

1. Clone the repo

2. Run `pod install` from the `Example/RealAppTest` directory first

3. Run `RealAppTest.xcworkspace`

## Requirements
Enable http domains exception:

info.plist >> 

Add `App Transport Security Settings` ++>> `Allow Arbitrary Loads = YES` 

## Installation

AppAnalyticsSwift is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "AppAnalyticsSwift"
```
Run `pod install` from terminal

Run `YOUR_APP_NAME.xcworkspace`

Installation Completed!

## How to use
Insert following line to your `ViewController`
```swift
import AppAnalyticsSwift
```
Initialize `AppAnalyticsSwift` class and call `submitCampaing` method:
```swift
let app = AppAnalyticsSwift(accessKey = "YOUR_ACCESS_KEY")

app.submitCampain()
```

#Events
To add event with value just call `addEvent` method:
```swift
app.addEvent(eventName: "StartMainController", eventValue: NSDate())
```
To add event without value call `addEvent` method add put `nil` for value : 
```swift
app.addEvent(eventName: "StartMainController", eventValue: nil)
```
## Author

AppAnalytics Develpment Team, development@appanalytics.ir

## License

AppAnalyticsSwift is available under the MIT license. See the LICENSE file for more info.

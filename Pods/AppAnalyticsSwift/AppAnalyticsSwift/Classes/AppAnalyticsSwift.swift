//
//  AppAnalytic.swift
//  Pods
//
//  Created by Vahid Sayad on 2016-06-19.
//
//

import Foundation
import UIKit

public extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 where value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}

// //////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: AppAnalyticsSwift Class
// //////////////////////////////////////////////////////////////////////////////////////////////////
public class AppAnalyticsSwift{
    
    private let _accessKey: String
    private var _APIURL = "http://appanalytics.ir/api/v1/iosservice/initialize/"
    private var _APIURL_DeviceInfo = "http://appanalytics.ir/api/v1/iosservice/setdeviceinfo/"
    private var _APIURL_AddEvent = "http://appanalytics.ir/api/v1/iosservice/addevent/"
    private let _UUID: String
    private var _deviceModelName: String
    private var _iOSVersion: String
    private var _orientation: String
    private var _batteryLevel: String
    private var _multitaskingSupported: String
    
    // //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: submitCampain Function
    // //////////////////////////////////////////////////////////////////////////////////////////////////
    public func submitCampaign(){
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if defaults.boolForKey("firstTimeAppAnalytics") {
            print("AppAnalytic Info (Submit Campaign): Already initialized")
        } else {
            
            let url = NSURL(string: self._APIURL + self._UUID)
            let request = NSMutableURLRequest(URL: url!)
            
            request.setValue(self._accessKey, forHTTPHeaderField: "Access-Key")
            
            NSURLSession.sharedSession().dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
                if let data = data {
                    do {
                        let jsonDic = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
                        let status = jsonDic["status"] as? String;
                        if status == "ok" {
                            defaults.setBool(true, forKey: "firstTimeAppAnalytics")
                            print("AppAnalytic Info (Submit Campaign): [", String(data: data, encoding: NSUTF8StringEncoding)!,"]")
                            self.sendDeviceInfo(self.getDeviceInfo())
                        }
                    } catch {
                        print("AppAnalytic Error (Submit Campaign): [Error in deserialize AppAnalytics.ir JSON result]")
                        defaults.setBool(false, forKey: "firstTimeAppAnalytics")
                    }
                }
                if let error = error {
                    print("AppAnalytic Error (Submit Campaign): [\(error.localizedDescription)")
                    defaults.setBool(false, forKey: "firstTimeAppAnalytics")
                }
                }.resume()
        }
    }
    
    // //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: AddEvent()
    // //////////////////////////////////////////////////////////////////////////////////////////////////
    public func addEvent(eventName eventName: String!, eventValue: String?){
        var tmpURL = self._APIURL_AddEvent + self._UUID + "/"
        
        if eventName.characters.count > 0 {
            tmpURL += eventName + "/"
        } else {
            return
        }
        
        if eventValue != nil && eventValue?.characters.count > 0 {
            tmpURL += eventValue!
        }
        
        print("TMPURL: \(tmpURL)")
        let url = NSURL(string: tmpURL)
        let request = NSMutableURLRequest(URL: url!)
        
        request.setValue(self._accessKey, forHTTPHeaderField: "Access-Key")
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            if let data = data {
                print("AppAnalytic Info (AddEvent): [", String(data: data, encoding: NSUTF8StringEncoding)!,"]")
                self.sendDeviceInfo(self.getDeviceInfo())
            }
            if let error = error {
                print("AppAnalytic Error (AddEvent): [\(error.localizedDescription)]")
            }
            }.resume()
    }

    // //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: SendDeviceInfo()
    // //////////////////////////////////////////////////////////////////////////////////////////////////
    private func sendDeviceInfo(jsonData: NSData){
        let defaults = NSUserDefaults.standardUserDefaults()
        let url = NSURL(string: self._APIURL_DeviceInfo + self._UUID)
        let request = NSMutableURLRequest(URL: url!)
        
        request.setValue(self._accessKey, forHTTPHeaderField: "Access-Key")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        request.HTTPBody = jsonData
        
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            if let data = data {
                
                do {
                    let jsonDic = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
                    let status = jsonDic["status"] as? String;
                    if status == "ok" {
                        defaults.setBool(true, forKey: "firstTimeAppAnalytics")
                        print("AppAnalytic Info (Send Device Info): [", String(data: data, encoding: NSUTF8StringEncoding)!,"]")
                    }
                } catch {
                    print("AppAnalytic Error (Send Device Info): [Error in deserialize AppAnalytics.ir JSON result]")
                    defaults.setBool(false, forKey: "firstTimeAppAnalytics")
                }
                
            }
            if let error = error {
                print("AppAnalytic Error (Send Device Info): [\(error.localizedDescription)]")
                defaults.setBool(false, forKey: "firstTimeAppAnalytics")
            }
            }.resume()
    }
    
    // //////////////////////////////////////////////////////////////////////////////////////////////////
    // Mark: GetDeviceInfo()
    // //////////////////////////////////////////////////////////////////////////////////////////////////
    private func getDeviceInfo() -> NSData {
        var json = NSData()
        let info = NSMutableDictionary()
        if self._deviceModelName != "Error" {
            info["DeviceModel"] = self._deviceModelName
        }
        if self._iOSVersion != "Error" {
            info["iOSVersion"] = self._iOSVersion
        }
        if self._orientation != "Error" {
            info["Orientation"] = self._orientation
        }
        if self._batteryLevel != "Error" {
            info["BatteryLevel"] = self._batteryLevel
        }
        if self._multitaskingSupported != "Error" {
            info["MultiTaskingSupported"] = self._multitaskingSupported
        }
        
        do {
            json = try NSJSONSerialization.dataWithJSONObject(info, options: NSJSONWritingOptions.PrettyPrinted)
        } catch let error as NSError {
            print("AppAnalytic Error: [\(error.localizedDescription)]")
        }
        return json
    }
    
    // //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Init
    // //////////////////////////////////////////////////////////////////////////////////////////////////
    public init(accessKey key: String){
        self._accessKey = key
        if let id = UIDevice.currentDevice().identifierForVendor {
            self._UUID = id.UUIDString
        } else {
            self._UUID = "error"
        }
        
        //Device model name
        self._deviceModelName = UIDevice.currentDevice().modelName
        
        // iOS Version
        self._iOSVersion = UIDevice.currentDevice().systemVersion
        
        // Device Oriantation
        let orientation = UIDevice.currentDevice().orientation
        switch orientation {
        case .LandscapeLeft:
            self._orientation = "LandscapeLeft"
        case .LandscapeRight:
            self._orientation = "LandscapeRight"
        case .Portrait:
            self._orientation = "Portrait"
        case .PortraitUpsideDown:
            self._orientation = "PortraitUpsideDown"
        default:
            self._orientation = "Error"
        }
        
        // Battery Level
        switch UIDevice.currentDevice().batteryLevel {
        case -1.0:
            self._batteryLevel = "Error"
        default:
            self._batteryLevel = String("\(UIDevice.currentDevice().batteryLevel )")
        }
        
        //Multi tasking supported:
        if UIDevice.currentDevice().multitaskingSupported {
            self._multitaskingSupported = "true"
        } else {
            self._multitaskingSupported = "false"
        }
    }

}
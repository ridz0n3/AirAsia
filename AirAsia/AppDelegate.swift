//
//  AppDelegate.swift
//  AirAsia
//
//  Created by ME-Tech Mac User 1 on 7/14/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import XLForm
import CoreData
import RealmSwift
import Realm
import SwiftyJSON
import Fabric
import Crashlytics
import Appsee
import AppAnalyticsSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        XLFormViewController.cellClassesForRowDescriptorTypes()[XLFormRowDescriptorTypeFloatLabeled] = CustomFloatLabelCell.self
        XLFormViewController.cellClassesForRowDescriptorTypes()[XLFormRowDescriptorCheckbox] = "CustomCheckBoxCell"
        
        let homeStoryBoard = UIStoryboard(name: "SplashScreen", bundle: nil)
        let navigationController = homeStoryBoard.instantiateViewControllerWithIdentifier("LaunchScreenVC")
        self.window?.rootViewController = navigationController
        
        let config = RLMRealmConfiguration.defaultConfiguration()
        config.schemaVersion = 11
        config.migrationBlock = { (migration, oldSchemaVersion) in
            // nothing to do
        }
        
        let app = AppAnalyticsSwift(accessKey: "RCPICIG5ByxplElFVMZ3WhHIx1HPsjU6")
        app.submitCampaign()
        Appsee.start("f985a8f49302498a925aad25e175aca6")
        Fabric.with([Crashlytics.self, Answers.self])
        RLMRealmConfiguration.setDefaultConfiguration(config)
        BeaconManager.sharedInstance.setBeacon()
        
        if #available(iOS 8.0, *) {
            if(application.respondsToSelector(#selector(UIApplication.registerUserNotificationSettings(_:)))) {
                if #available(iOS 8.0, *) {
                    application.registerUserNotificationSettings(
                        UIUserNotificationSettings(
                            forTypes: [UIUserNotificationType.Alert, UIUserNotificationType.Sound],
                            categories: nil
                        )
                    )
                } else {
                    // Fallback on earlier versions
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
        return true
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
        print("test")
        let appDelegate = UIApplication.sharedApplication().keyWindow
        let root = appDelegate?.rootViewController
        viewsController = root!
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loadingVC = storyboard.instantiateViewControllerWithIdentifier("LogoVC") as! NotificationViewController
        //loadingVC.view.backgroundColor = UIColor.clearColor()
        
        viewsController.presentViewController(loadingVC, animated: true, completion: nil)
        
    }

    func applicationWillResignActive(application: UIApplication) {
       // Appsee.stopAndUpload()
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        //Appsee.stopAndUpload()
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        //Appsee.stopAndUpload()
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        Appsee.stopAndUpload()
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


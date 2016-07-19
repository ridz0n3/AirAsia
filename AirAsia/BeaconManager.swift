//
//  BeaconManager.swift
//  AirAsia
//
//  Created by ME-Tech Mac User 1 on 7/19/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import CoreLocation

class BeaconManager: NSObject, CLLocationManagerDelegate {

    static let sharedInstance = BeaconManager()
    
    var locationManager: CLLocationManager?
    var lastProximity: CLProximity?
    
    func setBeacon(){
        
        let uuidString = "B9407F30-F5F8-466E-AFF9-25556B57FE6D"
        let beaconIdentifier = "iBeaconModules.us"
        let beaconUUID:NSUUID = NSUUID(UUIDString: uuidString)!
        let beaconRegion:CLBeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID,
                                                         identifier: beaconIdentifier)
        
        locationManager = CLLocationManager()
        
        if #available(iOS 8.0, *) {
            if(locationManager!.respondsToSelector(#selector(CLLocationManager.requestAlwaysAuthorization))) {
                if #available(iOS 8.0, *) {
                    locationManager!.requestAlwaysAuthorization()
                } else {
                    // Fallback on earlier versions
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
        locationManager!.delegate = self
        locationManager!.pausesLocationUpdatesAutomatically = false
        
        locationManager!.startMonitoringForRegion(beaconRegion)
        locationManager!.startRangingBeaconsInRegion(beaconRegion)
        locationManager!.startUpdatingLocation()
        
    }
    
    func sendLocalNotificationWithMessage(message: String!, playSound: Bool) {
        let notification:UILocalNotification = UILocalNotification()
        notification.alertBody = message
        
        if(playSound) {
            // classic star trek communicator beep
            //	http://www.trekcore.com/audio/
            //
            // note: convert mp3 and wav formats into caf using:
            //	"afconvert -f caff -d LEI16@44100 -c 1 in.wav out.caf"
            // http://stackoverflow.com/a/10388263
            
            notification.soundName = "tos_beep.caf";
        }
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func locationManager(manager: CLLocationManager,
                         didRangeBeacons beacons: [CLBeacon],
                                         inRegion region: CLBeaconRegion) {
        
        //NSLog("didRangeBeacons");
        var message:String = ""
        
        var playSound = false
        
        if(beacons.count > 0) {
            let nearestBeacon:CLBeacon = beacons[0]
            
            if(nearestBeacon.proximity == lastProximity ||
                nearestBeacon.proximity == CLProximity.Unknown) {
                return;
            }
            lastProximity = nearestBeacon.proximity;
            
            switch nearestBeacon.proximity {
            case CLProximity.Far:
                message = "You are far away from the beacon"
                playSound = true
            case CLProximity.Near:
                message = "You are near the beacon"
            case CLProximity.Immediate:
                message = "You are in the immediate proximity of the beacon"
            case CLProximity.Unknown:
                return
            }
        } else {
            
            if(lastProximity == CLProximity.Unknown) {
                return;
            }
            
            message = "No beacons are nearby"
            playSound = true
            lastProximity = CLProximity.Unknown
        }
        
        //NSLog("%@", message)
        sendLocalNotificationWithMessage(message, playSound: playSound)
    }
    
    func locationManager(manager: CLLocationManager,
                         didEnterRegion region: CLRegion) {
        manager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
        manager.startUpdatingLocation()
        
       // NSLog("You entered the region")
        sendLocalNotificationWithMessage("You entered the region", playSound: true)
    }
    
    func locationManager(manager: CLLocationManager,
                         didExitRegion region: CLRegion) {
        manager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
        manager.stopUpdatingLocation()
        
       // NSLog("You exited the region")
        sendLocalNotificationWithMessage("You exited the region", playSound: true)
    }

}

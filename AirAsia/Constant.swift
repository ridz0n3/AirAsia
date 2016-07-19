//
//  Constant.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/20/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit
import SCLAlertView
import RealmSwift
import MBProgressHUD

let realm = try! Realm()
let defaults = NSUserDefaults.standardUserDefaults()
let key = "owNLfnLjPvwbQH3hUmj5Wb7wBIv83pR7" // length == 3
let iv = "owNLfnLjPvwbQH3h" // length == 16
let kStageURL = "http://fyapistage.me-tech.com.my/"
let kProductionURL = "http://fyapi.me-tech.com.my/"//
let kDevURL = "http://fyapidev.me-tech.com.my/"
let khttpsProductionURL = "https://m.fireflyz.com.my/"
let estimote_uuid = NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")
let virtual_uuid = NSUUID(UUIDString: "8492E75F-4FD6-469D-B132-043FE94921D8")
var deviceId = UIDevice.currentDevice().identifierForVendor?.UUIDString

var purposeArray:[Dictionary<String,AnyObject>] = [["purpose_code":"1","purpose_name":"Leisure"],["purpose_code":"2","purpose_name":"Business"]]
var travelDoc : [Dictionary<String, AnyObject>] = [["doc_code":"P","doc_name":"Passport"],["doc_code":"NRIC","doc_name":"Malaysia IC"],["doc_code":"V","doc_name":"Travel VISA"]]
var genderArray : [Dictionary<String, AnyObject>] = [["gender_code":"Female","gender_name":"Female"],["gender_code":"Male","gender_name":"Male"]]
var titleArray = defaults.objectForKey("title") as! [Dictionary<String,AnyObject>]
var countryArray = defaults.objectForKey("country") as! [Dictionary<String,AnyObject>]

internal struct Tags {
    static let ValidationUsername = "Email"
    static let ValidationPassword = "Password"
    static let ValidationNewPassword = "New Password"
    static let ValidationConfirmPassword = "Confirm Password"
    static var ValidationTitle = "Title"
    static var ValidationFirstName = "First Name"
    static var ValidationLastName = "Last Name"
    static var ValidationDate = "Date"
    static let ValidationAddressLine1 = "Address Line 1"
    static let ValidationAddressLine2 = "Address Line 2"
    static let ValidationAddressLine3 = "Address Line 3"
    static var ValidationCountry = "Country"
    static let ValidationTownCity = "Town/City"
    static let ValidationState = "State"
    static let ValidationPostcode = "Postcode"
    static let ValidationMobileHome = "Mobile/Home"
    static let ValidationAlternate = "Alternate"
    static let ValidationFax = "Fax"
    static let ValidationEmail = "Email"
    static var ValidationTravelDoc = "Travel Document"
    static var ValidationDocumentNo = "Document No"
    static var ValidationExpiredDate = "Expiration Date"
    static var ValidationEnrichLoyaltyNo = "Bonuslink"
    static var ValidationTravelWith = "Traveling with"
    static var ValidationGender = "Gender"
    static var ValidationPurpose = "Purpose"
    static var ValidationCompanyName = "Company Name"
    static var ValidationCardType = "Card Type"
    static var ValidationCardNumber = "Card Number"
    static var ValidationCardExpiredDate = "Card Expiration Date"
    static var ValidationHolderName = "Holder Name"
    static var ValidationCcvNumber = "CCV/CVC Number"
    static var ValidationConfirmationNumber = "Confirmation Number"
    static var ValidationDeparting = "Departing"
    static var ValidationArriving = "Arriving"
    static var ValidationSSRList = "Meals"
    static var HideSection = "hide"
    static var SaveFamilyAndFriend = "save"
    
}

struct GAConstants {
    
    static let searchFlightScreen = "Search Flight";
    static let addFlightDetailScreen = "Add Flight Detail";
    static let addPassengerDetailScreen = "Add Passenger Detail";
    static let addContactDetailScreen = "Add Contact Detail";
    static let addSeatSelectionScreen = "Add Seat Selection";
    static let paymentSummaryScreen = "Payment Summary";
    static let addPaymentScreen = "Add Payment";
    
}

class Constant: NSObject {
    
}

func nullIfEmpty(value : AnyObject?) -> AnyObject? {
    if value is NSNull {
        return ""
    } else {
        return value
    }
}

func nilIfEmpty(value : AnyObject?) -> AnyObject? {
    if value == nil {
        return ""
    } else {
        return value
    }
}

func getTitleName(titleCode:String) -> String{
    var titleName = String()
    if (defaults.objectForKey("title") != nil){
        for titleData in titleArray{
            if titleData["title_code"] as! String == titleCode{
                titleName = titleData["title_name"] as! String
            }
        }
    }else{
        titleName = titleCode
    }
    
    return titleName
}

func getCountryName(countryCode:String) -> String{
    var countryName = String()
    
    if (defaults.objectForKey("country") != nil){
        
        for countryData in countryArray{
            if countryData["country_code"] as! String == countryCode{
                countryName = countryData["country_name"] as! String
            }
        }
        
    }else{
        countryName = countryCode
    }
    
    
    return countryName
}

var location = [NSDictionary]()
var travel = [NSDictionary]()
var pickerRow = [String]()
var pickerTravel = [String]()

func getDepartureAirport(module : String){
    
    location = [NSDictionary]()
    pickerRow = [String]()
    
    if (defaults.objectForKey("flight") != nil){
        let flight = defaults.objectForKey("flight") as! [Dictionary<String, AnyObject>]
        var first = flight[0]["location_code"]
        location.append(flight[0] as NSDictionary)
        pickerRow.append("\(flight[0]["location"] as! String) (\(flight[0]["location_code"] as! String))")
        
        for loc in flight{
            
            if loc["location_code"] as! String != first as! String{
                
                if module == "checkIn"{
                    
                    if loc["mobile_check_in"] as! String == "Y"{
                        location.append(loc as NSDictionary)
                        pickerRow.append("\(loc["location"] as! String) (\(loc["location_code"] as! String))")
                        first = loc["location_code"]
                    }
                    
                }else{
                    location.append(loc as NSDictionary)
                    pickerRow.append("\(loc["location"] as! String) (\(loc["location_code"] as! String))")
                    first = loc["location_code"]
                }
                
            }
            
        }
    }
}

func getArrivalAirport(departureAirport: String, module : String){
    
    if (defaults.objectForKey("flight") != nil){
        
        let flight = defaults.objectForKey("flight") as! [Dictionary<String, AnyObject>]
        
        let first = departureAirport
        
        for loc in flight{
            
            if loc["location_code"] as! String == first{
                
                if module == "checkIn"{
                    
                    if loc["mobile_check_in"] as! String == "Y"{
                        travel.append(loc as NSDictionary)
                        pickerTravel.append("\(loc["travel_location"] as! String) (\(loc["travel_location_code"] as! String))")
                    }
                }else{
                    travel.append(loc as NSDictionary)
                    pickerTravel.append("\(loc["travel_location"] as! String) (\(loc["travel_location_code"] as! String))")
                }
                
            }
            
        }
        
    }
    
}

func showErrorMessage(message : String){
    
    // Create custom Appearance Configuration
    let appearance = SCLAlertView.SCLAppearance(
        kTitleFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
        kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
        kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
        showCircularIcon: true,
        kCircleIconHeight: 35
    )
    let alertViewIcon = UIImage(named: "alertIcon")
    let errorView = SCLAlertView(appearance: appearance)
    errorView.showError("Error!", subTitle:message, colorStyle: 0xFF0000, closeButtonTitle : "Close", circleIconImage: alertViewIcon)
    
}

func showRetryMessage(message : String){
    // Create custom Appearance Configuration
    let appearance = SCLAlertView.SCLAppearance(
        kTitleFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
        kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
        kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
        showCircularIcon: true,
        showCloseButton: false,
        kCircleIconHeight: 35
    )
    let alertViewIcon = UIImage(named: "alertIcon")
    let errorView = SCLAlertView(appearance: appearance)
    errorView.addButton("Retry") { () -> Void in
        InitialLoadManager.sharedInstance.load()
    }
    errorView.showError("Error!", subTitle:message, colorStyle: 0xFF0000, circleIconImage: alertViewIcon)
    
}

func showToastMessage(message:String){
    
    // Create custom Appearance Configuration
    let appearance = SCLAlertView.SCLAppearance(
        kTitleFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
        kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
        kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
        showCircularIcon: true,
        kCircleIconHeight: 35
    )
    let alertViewIcon = UIImage(named: "alertIcon")
    let messageView = SCLAlertView(appearance: appearance)
    messageView.showSuccess("Success", subTitle:message, colorStyle: 0xFF0000, closeButtonTitle : "Close", circleIconImage: alertViewIcon)
    
}

func showNotif(title : String, message:String){
    
    // Create custom Appearance Configuration
    let appearance = SCLAlertView.SCLAppearance(
        kTitleFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
        kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
        kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
        showCircularIcon: true,
        kCircleIconHeight: 35
    )
    let alertViewIcon = UIImage(named: "alertIcon")
    let infoView = SCLAlertView(appearance:appearance)
    infoView.showInfo(title, subTitle: message, closeButtonTitle: "Close", colorStyle: 0xFF0000, circleIconImage: alertViewIcon)
    
}

func showInfo(message:String){
    
    // Create custom Appearance Configuration
    let appearance = SCLAlertView.SCLAppearance(
        kTitleFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
        kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
        kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
        showCircularIcon: true,
        kCircleIconHeight: 35
    )
    let alertViewIcon = UIImage(named: "alertIcon")
    let infoView = SCLAlertView(appearance:appearance)
    infoView.showInfo("Info", subTitle: message, closeButtonTitle: "Okay", colorStyle: 0xFF0000, circleIconImage: alertViewIcon)
    
}

var viewsController = UIViewController()

func showLoading(){
    let loadingNotification = MBProgressHUD.showHUDAddedTo(viewsController.view, animated: true)
    loadingNotification.mode = MBProgressHUDMode.Indeterminate
    loadingNotification.labelText = "Loading"
    loadingNotification.show(true)
    /*
    let appDelegate = UIApplication.sharedApplication().keyWindow
    let root = appDelegate?.rootViewController
    viewsController = root!
    
    let storyboard = UIStoryboard(name: "Loading", bundle: nil)
    let loadingVC = storyboard.instantiateViewControllerWithIdentifier("LoadingVC") as! LoadingViewController
    loadingVC.view.backgroundColor = UIColor.clearColor()
    
    viewsController.presentViewController(loadingVC, animated: true, completion: nil)
 */
    
}

func hideLoading(){
    MBProgressHUD.hideAllHUDsForView(viewsController.view, animated: true)
    //viewsController.presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
    
}

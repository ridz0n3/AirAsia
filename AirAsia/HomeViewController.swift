//
//  HomeViewController.swift
//  AirAsia
//
//  Created by ME-Tech Mac User 1 on 7/14/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit



class HomeViewController: UITabBarController {

    private enum TabTitles: String, CustomStringConvertible {
        case Shake
        case Emoji
        case Bonus
        case Exploration
        case Profile
        
        private var description: String {
            return self.rawValue
        }
    }
    
    private var tabIcons = [
        TabTitles.Shake: "shake",
        TabTitles.Emoji: "emoji",
        TabTitles.Bonus: "bonus",
        TabTitles.Exploration: "exploration",
        TabTitles.Profile: "profile"
    ]
    
    func imageWithImage(image: UIImage, scaledToSize:CGSize) -> UIImage{
        
        UIGraphicsBeginImageContextWithOptions(scaledToSize, false, 0.0)
        image.drawInRect(CGRectMake(0, 0, scaledToSize.width, scaledToSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = UIColor.redColor()
        
        if let tabBarItems = tabBar.items {
            for item in tabBarItems {
                if let title = item.title,
                    tab = TabTitles(rawValue: title),
                    glyph = tabIcons[tab] {
                    
                    let img = UIImage(named: glyph)
                    let newImg = imageWithImage(img!, scaledToSize: CGSizeMake(30, 30))
                    //item.image = CGSizeMake(30, 30)
                    item.image = newImg
                    item.selectedImage = newImg
                }
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        
        let animation = CATransition()
        animation.type = kCATransitionFade
        animation.duration = 0.25
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        self.view.window?.layer.addAnimation(animation, forKey: "fadeTransition")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

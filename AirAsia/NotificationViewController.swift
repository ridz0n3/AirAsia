//
//  NotificationViewController.swift
//  AirAsia
//
//  Created by ME-Tech Mac User 1 on 7/19/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit

class NotificationViewController: BaseViewController {

    @IBOutlet weak var views: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.views.transform = CGAffineTransformMakeRotation((270.0 * CGFloat(M_PI)) / 180.0)
        //self.lbl.transform = CGAffineTransformMakeRotation((90 * CGFloat(M_PI)) / 180.0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeBtnPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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

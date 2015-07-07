//
//  LivemodusTabBarController.swift
//  FireflyApp
//
//  Created by ak on 19.06.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import UIKit
/**
Pushes the LogNavigatoinView over the Livemodus
*/
class LivemodusTabBarController: UITabBarController {
    
    @IBAction func missionsButtonPressed(sender: AnyObject) {
        var overlay = storyboard!.instantiateViewControllerWithIdentifier("LogNavigationView") as! UINavigationController
        self.presentViewController(overlay, animated: true, completion: nil)
    }
    
}

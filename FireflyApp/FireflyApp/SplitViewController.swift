//
//  SplitViewController.swift
//  FireflyApp
//
//  Created by Alexander Zeier on 03.06.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllers.append(self.storyboard?.instantiateViewControllerWithIdentifier("masterViewNavigation") as! UINavigationController)
        self.viewControllers.append(self.storyboard?.instantiateViewControllerWithIdentifier("detailView") as! UINavigationController)
    }
    
}
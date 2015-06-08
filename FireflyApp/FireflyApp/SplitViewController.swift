//
//  SplitViewController.swift
//  FireflyApp
//
//  Created by Alexander Zeier on 03.06.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController {
    
    var log: Log?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Live Mode"
        
        self.preferredDisplayMode = UISplitViewControllerDisplayMode.PrimaryHidden
        
        self.viewControllers.append(self.storyboard?.instantiateViewControllerWithIdentifier("masterViewNavigation") as! UINavigationController)
        self.viewControllers.append(self.storyboard?.instantiateViewControllerWithIdentifier("detailView") as! UINavigationController)
        
        let masterNavigationController = self.viewControllers.first as! UINavigationController
        let detailNavigationController = self.viewControllers.last as! UINavigationController
        let masterViewController = masterNavigationController.viewControllers.first as! UITabBarController
        let masterTableView = masterViewController.viewControllers?.last as! MasterTableView
        let mapView = detailNavigationController.viewControllers.first as! FirstViewController
        
        masterTableView.waypointTableDelegate = mapView
    }
    
}
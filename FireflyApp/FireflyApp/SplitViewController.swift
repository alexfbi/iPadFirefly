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
        
        let masterNavigationView = self.viewControllers.first as! UINavigationController
        let detailNavigationView = self.viewControllers.last as! UINavigationController
        
        let masterView = masterNavigationView.viewControllers.first as! UITabBarController
        let masterTableView = masterView.viewControllers?.last as! MasterTableView
        let masterControlView = masterView.viewControllers?.first as! ControlViewController
        
        let mapView = detailNavigationView.viewControllers?.first as! MapViewController
        
        masterTableView.waypointTableDelegate = mapView
        masterControlView.delegate = mapView
    }
    
}
//
//  SplitViewController.swift
//  FireflyApp
//
//  Created by Alexander Zeier on 03.06.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import UIKit

/**
This class describes our SplitViewController and initializes the delegates of the master and detail views. Also it provides a method to resolve the conflict between the swipe gestures of the MapView.
*/
class SplitViewController: UISplitViewController {
    
    var log: Log?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredDisplayMode = UISplitViewControllerDisplayMode.PrimaryHidden
        
        let masterNavigationView = self.viewControllers.first as! UINavigationController
        let detailNavigationView = self.viewControllers.last as! UINavigationController
        
        let masterView = masterNavigationView.viewControllers.first as! UITabBarController
        let masterTableView = masterView.viewControllers?.last as! MasterTableViewController
        let masterControlView = masterView.viewControllers?.first as! ControlViewController
        
        let mapView = detailNavigationView.viewControllers?.first as! MapViewController
        
        masterTableView.waypointTableDelegate = mapView
        masterControlView.delegate = mapView
    }
   
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let location = touch.locationInView(self.view)
        
        // Just allow the master view to appear if swipe gesture was performed at the left edge of the screen
        if (location.x < 150) {
            self.presentsWithGesture = true
        } else {
            self.presentsWithGesture = false
        }
    }
}
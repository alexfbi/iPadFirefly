//
//  LivemodusTabBarController.swift
//  FireflyApp
//
//  Created by ak on 19.06.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import UIKit

class LivemodusTabBarController: UITabBarController {
    @IBAction func unwindFromLogTableView(segue: UIStoryboardSegue){
        
        performSegueWithIdentifier("MapDetail", sender: nil)
        
    }

}

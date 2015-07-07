//
//  CategorieTableViewController.swift
//  FireflyApp
//
//  Created by ak on 18.05.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

/**
The Controller navigates the log to the destination controller
*/

class CategorieTableViewController: UITableViewController {
     // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Logs"
    }
    
    var log: Log?
    // MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let ident = String(segue.identifier!)
        
        switch (ident)
        {
            
        case "Status":
            
            let EintragTVC = segue.destinationViewController as! BatterieTableViewController
            
            EintragTVC.log = log
                  
            
            
        case "Pictures":
            let EintragTVC = segue.destinationViewController as! PicturesViewController
            
            EintragTVC.log = log
            
            
            
        case "PlotStatus" :
            
            let EintragTVC = segue.destinationViewController as! PlotterViewController
            
            EintragTVC.log = log
            
        case "GPS" :
            
            let EintragTVC = segue.destinationViewController as! GPSViewController
            
            EintragTVC.log = log
            
       
            
        default :
            
            NSLog("%@","Wrong Identifier: \(ident)")
        }
        
        
    }
    
       
}

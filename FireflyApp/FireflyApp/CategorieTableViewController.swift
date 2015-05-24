//
//  CategorieTableViewController.swift
//  FireflyApp
//
//  Created by ak on 18.05.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation
import UIKit

class CategorieTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Categorie"
    }
    
    var log: Log?
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let ident = String(segue.identifier!)
        
        switch (ident)
        {
            
        case "Status":
            
            let EintragTVC = segue.destinationViewController as! EntryTableViewController
            
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

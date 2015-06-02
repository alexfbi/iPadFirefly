//
//  EintragTableViewController.swift
//  AFC1
//
//  Created by ak on 02.05.15.
//  Copyright (c) 2015 ak. All rights reserved.
//

import UIKit
import CoreData

class BatterieTableViewController: UITableViewController {
    
    
    var log: Log?
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var batterieList = [Battery]()
    
      var controlDBModell:ControlDBModel =  ControlDBModel()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = "Battery"
        controlDBModell.loadDataFromDB(log!)
        batterieList = controlDBModell.batterieList
    }
    
   
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return batterieList.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        var cell  = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        
        let entry = batterieList[indexPath.row]
        //  let id = entries[indexPath.row].
        cell.textLabel?.text = "\(entry.id)   - \(entry.value)   - \(entry.date)"
        
        println(entry)
        
        
        
        return cell
    }
    
   
    

    
    
    
    
}

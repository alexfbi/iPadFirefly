//
//  KategorieTableViewController.swift
//  FireflyApp
//
//  Created by ak on 18.05.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation
import UIKit

class KategorieTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Kategorie"
    }
    
    var log: Log?
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let ident = String(segue.identifier!)
        
        switch (ident)
        {
            
        case "Status":
            
            let EintragTVC = segue.destinationViewController as! EintragTableViewController
            
            EintragTVC.log = log
            
            
            
        case "Bilder":
            let EintragTVC = segue.destinationViewController as! BilderViewController
            
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
        
        /*    if segue.identifier == "Status" {
        
        
        let EintragTVC = segue.destinationViewController as EintragTableViewController
        
        
        
        EintragTVC.log = log
        
        
        }
        
        if segue.identifier == "Bilder" {
        let EintragTVC = segue.destinationViewController as ViewController
        
        
        
        EintragTVC.log = log
        
        
        }
        if segue.identifier == "PlotStatus" {
        
        
        let EintragTVC = segue.destinationViewController as PlotterViewController
        
        
        EintragTVC.log = log
        }
        */
    }
    
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell
    
    // Configure the cell...
    
    return cell
    }
    */
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}

//
//  SecondViewController.swift
//  FireflyApp
//
//  Created by ak on 06.05.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import UIKit
import CoreData

/**

The controller loads the logs from the database and show the logs in tables
*/

class LogTableViewController: UITableViewController {
        
      // MARK: - Variable
    
        var logs = [Log]()
        
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
      // MARK: - IBAction
    
    @IBAction func livemodusButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
      // MARK: - ViewDidLoad
        override func viewDidLoad() {
            super.viewDidLoad()
            loadDataFromDB()
            
        }
  
    
    /**
    Load data from DB
    */
        func loadDataFromDB(){
            let fetchRequest = NSFetchRequest(entityName: "Log")
            logs = context?.executeFetchRequest(fetchRequest, error: nil) as! [Log]
            tableView.reloadData()
            NSLog("%@", "Count logs: \(logs.count)")
        }
        
        
         // MARK: - Table View
        
        
        override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            
            return logs.count
        }
    
        /**
        Table view output
        */
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            
            var cell  = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
            
            
            
            let logname = logs[indexPath.row].name
            let logID = logs[indexPath.row].id
            
            
            
            NSLog("%@", "Logname: \(logname)")
            cell.textLabel?.text = "\(logname) "
            
            
            
            
            return cell
        }
        
    
        
        override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
            return true
        }
        
        /** 
        Deletes a Log form filesystem and Database
        */
        override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
            
            
            if editingStyle == .Delete {
                
                var log:Log = logs[indexPath.row]
                
                let fileManager = NSFileManager.defaultManager()
                
                
                let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
                    .UserDomainMask, true)
                
                let docsDir = dirPaths[0] as! String
                
                
                let newDir = docsDir.stringByAppendingPathComponent("/Images/\(log.id)")
                
                var error: NSError?
                
                if !fileManager.removeItemAtPath(newDir, error: &error) {
                   NSLog("%@", "Failed to delete directory:\(error!.localizedDescription)")
                }

                
                context?.deleteObject(log)
                context?.save(nil)
                loadDataFromDB()
                 
            }
        }
        
        override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String! {
            return "Delete"
        }
    
        
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            
            
            if segue.identifier == "Categorie" {
                
                var indexPath  = tableView.indexPathForSelectedRow()!
                
                let kategorieVC = segue.destinationViewController as! CategorieTableViewController
                
                let log = logs[ indexPath.row ]
                
                kategorieVC.log = log
                
            }
            
        
    }
    
   
    
    
}



//
//  SecondViewController.swift
//  FireflyApp
//
//  Created by ak on 06.05.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import UIKit
import CoreData

class LogTableViewController: UITableViewController {
        
        var logs = [Log]()
        
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        override func viewDidLoad() {
            super.viewDidLoad()
            loadDataFromDB()
            
        }
        
        
        func loadDataFromDB(){
            let fetchRequest = NSFetchRequest(entityName: "Log")
            logs = context?.executeFetchRequest(fetchRequest, error: nil) as! [Log]
            tableView.reloadData()
            NSLog("%@", "Count logs: \(logs.count)")
        }
        
        
        
        
        
        override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            
            return logs.count
        }
        
        
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            
            var cell  = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
            
            
            
            let logname = logs[indexPath.row].name
            let logID = logs[indexPath.row].id
            
            
            
            NSLog("%@", "Logname: \(logname)")
            cell.textLabel?.text = "\(logname) \(logID) "
            
            
            
            
            return cell
        }
        
        
        
        override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
            return true
        }
        
        
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
        
    @IBAction func addLogBtnPressed(sender: AnyObject) {
               
            var alert = UIAlertController(title: "Log create", message: "insert Name and ID", preferredStyle: .Alert)
            
            alert.addTextFieldWithConfigurationHandler(){
                textField in
                textField.placeholder = "Name"
                textField.becomeFirstResponder()
                
            }
            
            
            
            alert.addTextFieldWithConfigurationHandler(){
                textField in
                textField.placeholder = "ID"
                
            }
            
            alert.addAction(UIAlertAction(title: "ADD", style: .Default, handler: {
                action in
                
                var newLog = NSEntityDescription.insertNewObjectForEntityForName("Log", inManagedObjectContext: self.context!) as! Log
              
                
                newLog.name = (alert.textFields![0] as! UITextField).text
                
                newLog.id = ((alert.textFields![1] as! UITextField).text).toInt()!
                
                
                NSLog("%@", " new Log inserted: \(newLog.name)")
                
                self.context?.save(nil)
                self.loadDataFromDB()
    
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            
            presentViewController(alert, animated: true, completion: nil)
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



//
//  EintragTableViewController.swift
//  AFC1
//
//  Created by ak on 02.05.15.
//  Copyright (c) 2015 ak. All rights reserved.
//

import UIKit
import CoreData

class EntryTableViewController: UITableViewController {

    
    var log: Log?
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var entries = [Entry]()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        title = "Entries"
        loadDataFromDB()
    }
    
    func loadDataFromDB(){
        
        let fetchRequest = NSFetchRequest(entityName: "Entry")
        fetchRequest.predicate = NSPredicate(format: "log = %@", log!)
        entries = context?.executeFetchRequest(fetchRequest, error: nil) as! [Entry]
        tableView.reloadData()
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return entries.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        var cell  = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        
        let entry = entries[indexPath.row]
      //  let id = entries[indexPath.row].
        cell.textLabel?.text = "\(entry.name) - \(entry.valueX) - \(entry.valueY) "
        
        println(entry)
        
        
        
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if editingStyle == .Delete {
            
            context?.deleteObject(entries[indexPath.row])
            context?.save(nil)
            loadDataFromDB()
            
            
        }
    }
    
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String! {
        return "Delete"
    }
    
    
    @IBAction func addEIntragButtonPressed(sender: AnyObject) {
        
        
        var alert = UIAlertController(title: "Eintrag anlegen", message: "Name eingeben", preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler(){
            textField in
            textField.placeholder = "Name"
            textField.becomeFirstResponder()
            
        }
       
        alert.addTextFieldWithConfigurationHandler(){
            textField in
            textField.placeholder = "ValueX"
            
        }
        alert.addTextFieldWithConfigurationHandler(){
            textField in
            textField.placeholder = "Valuey"
            
        }

        
        
        
        alert.addAction(UIAlertAction(title: "Hinzufügen", style: .Default, handler: {
            action in
            
            var newEntry = NSEntityDescription.insertNewObjectForEntityForName("Entry", inManagedObjectContext: self.context!) as! Entry
            
            newEntry.name = (alert.textFields![0] as! UITextField).text
            
           
         
            let valueX = (alert.textFields![1] as! UITextField).text
            
            let valueY = (alert.textFields![2] as! UITextField).text
            
            
            newEntry.valueX = valueX.toInt()!
      
            newEntry.valueY = valueY.toInt()!
            
            newEntry.log = self.log!
          
            
            self.context?.save(nil)
            self.loadDataFromDB()
            
            
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Abbrechen", style: .Cancel, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
    }

    
    

    
}

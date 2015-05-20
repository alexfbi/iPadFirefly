//
//  EintragTableViewController.swift
//  AFC1
//
//  Created by ak on 02.05.15.
//  Copyright (c) 2015 ak. All rights reserved.
//

import UIKit
import CoreData

class EintragTableViewController: UITableViewController {

    
    var log: Log?
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var eintraege = [Eintrag]()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        title = "Eintrag"
        loadDataFromDB()
    }
    
    func loadDataFromDB(){
        
        let fetchRequest = NSFetchRequest(entityName: "Eintrag")
        fetchRequest.predicate = NSPredicate(format: "log = %@", log!)
        eintraege = context?.executeFetchRequest(fetchRequest, error: nil) as! [Eintrag]
        tableView.reloadData()
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return eintraege.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        var cell  = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        
        let eintrag = eintraege[indexPath.row]
      //  let id = eintraege[indexPath.row].
        cell.textLabel?.text = "\(eintrag.name) - \(eintrag.valueX) - \(eintrag.valueY) "
        
        println(eintrag)
        
        
        
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if editingStyle == .Delete {
            
            context?.deleteObject(eintraege[indexPath.row])
            context?.save(nil)
            loadDataFromDB()
            
            
        }
    }
    
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String! {
        return "Löschen"
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
            
            var newEintrag = NSEntityDescription.insertNewObjectForEntityForName("Eintrag", inManagedObjectContext: self.context!) as! Eintrag
            
            newEintrag.name = (alert.textFields![0] as! UITextField).text
            
           
         
            let valueX = (alert.textFields![1] as! UITextField).text
            
            let valueY = (alert.textFields![2] as! UITextField).text
            
            
            newEintrag.valueX = valueX.toInt()!
      
            newEintrag.valueY = valueY.toInt()!
            
            newEintrag.log = self.log!
          
            
            self.context?.save(nil)
            self.loadDataFromDB()
            
            
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Abbrechen", style: .Cancel, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
    }

    
    

    
}

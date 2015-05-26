//
//  MissionControlViewController.swift
//  FireflyApp
//
//  Created by ak on 23.05.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import UIKit
import CoreData


class MissionControlViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    var logs = [Log]()
     var log: Log?
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
        loadDataFromDB()
    
        
        
    }

   
    
    
    func loadDataFromDB(){
         NSLog("%@","loadDataFromDB")
        let fetchRequest = NSFetchRequest(entityName: "Log")
        logs = context?.executeFetchRequest(fetchRequest, error: nil) as! [Log]
       
        NSLog("%@", "Count logs: \(logs.count)")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let ident = String(segue.identifier!)
        
        switch (ident)
        {
            
        case "Mission" :
            
            NSLog("%@","Ident Mission")

            
        
        case "Plotter" :
            NSLog("%@","Ident Plotter")
            loadDataFromDB()
            let EintragTVC = segue.destinationViewController as! TestViewController
            
         //  EintragTVC.log = logs.last

        case "Control" :
            
            let EintragTVC = segue.destinationViewController as! SteuerungTableViewController
            
            EintragTVC.log = logs.first
            

            
            
        default :
            
            NSLog("%@","Wrong Identifier: \(ident)")
        }
        
        
    }
   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

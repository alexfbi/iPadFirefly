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
   
    var logs = [Log]()
     var log: Log?
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext


    
    
    @IBOutlet weak var containerPlotter: UIView!
    

    @IBOutlet weak var ContainerMap: UIView!
    
   
    @IBOutlet weak var containerPics: UIView!
    
    @IBAction func plotterButtonPressed(sender: AnyObject) {
        
        
        
        containerPics.hidden = true
        
        ContainerMap.hidden  = true
        
        containerPlotter.hidden = false
    
    }
   

    @IBAction func MapButtonPressed(sender: AnyObject) {
        containerPics.hidden = true
        
        ContainerMap.hidden  = false
        
        containerPlotter.hidden = true
    }
    
    @IBAction func PicsButtonPressed(sender: AnyObject) {
        containerPics.hidden = false
        
        ContainerMap.hidden  = true
        
        containerPlotter.hidden = true
    }
    
   
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
        
           loadDataFromDB()
        
        let ident = String(segue.identifier!)
        
        switch (ident)
        {
            
        case "Mission" :
            
            NSLog("%@","Ident Mission")

            
        
        case "Plotter" :
        
        
            
         
            
          let EintragTVC = segue.destinationViewController as! PlotterViewController
            
            
                     EintragTVC.log = logs.last

        case "Pictures" :
            
            
            
            
            
        let EintragTVC = segue.destinationViewController as! PicturesViewController
            
            
            EintragTVC.log = logs.last

        
        case "Map" :
            
            
        
            
            let EintragTVC = segue.destinationViewController as! GPSViewController
            
            
            EintragTVC.log = logs.last
            
            
            
        case "Control" :
         
            let EintragTVC = segue.destinationViewController as! SteuerungTableViewController
            
            EintragTVC.log = logs.last
            

            
            
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

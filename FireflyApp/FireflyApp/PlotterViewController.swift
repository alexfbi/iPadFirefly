//
//  PlotterViewController.swift
//  AFC1
//
//  Created by ak on 10.05.15.
//  Copyright (c) 2015 ak. All rights reserved.
//

import UIKit
import CoreData

class PlotterViewController: ContentViewController, PlotViewDataSource {

    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var entries = [Entry]()
    
    
    
    @IBOutlet weak var plotView: PlotView!
        {
            didSet{
                
                plotView.dataSource = self
            }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        title = "Plotter"
        loadDataFromDB()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setPoints(sender: PlotView) -> [CGPoint?]
    
    {
        var listPoints  = [CGPoint?]()
        
       
        
        let eintraegeCount = entries.count
        if eintraegeCount > 0
        {
            
        
        for i in 0...eintraegeCount - 1
        {
            
            let x = CGFloat( entries[i].valueX)
            let y = CGFloat( entries[i].valueY)
            let point = CGPoint(x: x, y: y)
           
            listPoints.append(point)
            
        }
    }
    
        
        return listPoints
        
    }
    

    func loadDataFromDB(){
        
        let fetchRequest = NSFetchRequest(entityName: "Entry")
        fetchRequest.predicate = NSPredicate(format: "log = %@", log!)
        entries = context?.executeFetchRequest(fetchRequest, error: nil) as! [Entry]
      
        
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
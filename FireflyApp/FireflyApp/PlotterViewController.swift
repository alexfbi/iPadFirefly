//
//  PlotterViewController.swift
//  AFC1
//
//  Created by ak on 10.05.15.
//  Copyright (c) 2015 ak. All rights reserved.
//

import UIKit
import CoreData

/**

The controller converts and sets the points for the plot.
*/
class PlotterViewController: ContentViewController, PlotViewDataSource {

      // MARK: - Variable
    
    //  let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var batterieList = [Battery]()
    //   var log : Log!
    
     var controlDBModell:ControlDBModel =  ControlDBModel()
   
      // MARK: - Outlets
    
    @IBOutlet weak var plotView: PlotView!
        {
            didSet{
                
                plotView.dataSource = self
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        title = "Battery"
        
       controlDBModell.loadDataFromDB(log)
        
        batterieList  = controlDBModell.batterieList
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   func setPoints(sender: PlotView) -> ([CGPoint?], Double, Double)
    {
        var listPoints  = [CGPoint?]()
        
        
        
        let eintraegeCount = batterieList.count
          NSLog("%@", " eintraegeCount: \(batterieList.count) ")
      
        var maxX:Double = Double(batterieList.count)
        var maxY:Double = 0.0
        
        if eintraegeCount > 1
        {
            
            for i in 0...eintraegeCount - 1
            {
                
                if ( maxY < Double(batterieList[i].value) )
                {
                    maxY = Double(batterieList[i].value)
                }
                
                let x = CGFloat(i )
                let y = CGFloat( Double(batterieList[i].value ) )
                
                let point = CGPoint(x: x, y: y)
                
                listPoints.append(point)
                
            }
            
            
        }
        else{
            
            
            
            NSLog("%@", "Points size: \(listPoints.count) ")
            
        }
        return (listPoints, maxX, maxY)
    }
}

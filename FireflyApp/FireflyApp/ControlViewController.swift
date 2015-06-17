//
//  ControlViewController.swift
//  FireflyApp
//
//  Created by ak on 29.05.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//


import UIKit
import Foundation
import CoreData



protocol ControlViewDelegate {
    func drawLine(gpsList: [GPS_Struct])
    func getWaypoints() -> [Waypoint]
}

class ControlViewController:  UIViewController, PlotViewDataSource  {
   
    
      // MARK: - Variables
    let ANIMATIONDURATION: NSTimeInterval = 5
    
    var timer = NSTimer()
    var log:Log?
    var batterieList = [Double]()
    var gpsList = [GPS_Struct]()
    var imageList = [UIImage]()
    
    
    var delegate:ControlViewDelegate?
    var networkRecProp:NetworkRecProp?
    var networkSender:NetworkSender?
    var networkRecPicture:NetworkRecPicture?
    
    var mission:MissionModel = MissionModel()

    
    
     // MARK: - Outlets
    @IBOutlet weak var startSwitch: UISwitch!
    @IBOutlet weak var ImageView: UIImageView!
    
    @IBOutlet weak var labelGPSx: UILabel!
    @IBOutlet weak var labelGPSy: UILabel!
    @IBOutlet weak var labelBatterie: UILabel!
    @IBOutlet weak var labelSpeed: UILabel!
    @IBOutlet weak var labelHeight: UILabel!
    
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var buttonCreateData: UIButton!
    
    @IBOutlet weak var plotView: PlotView!
        {
        didSet{
            plotView.dataSource = self
        }
    }
 
    /**
        shows Data on Screen
    */
   
    func displayData()
    {
        
        var string:String = ""
        
        if let  battery =  mission.batterieList.last {
          
            string =  "\(battery)"
            
            NSLog("%@", " Data Batterie \(string)")
            labelBatterie.text = string
            
           
           
        }
        
        
        if let speed =  mission.speedList.last {
            
            string =  "\(speed)"
            
            NSLog("%@", " Data Speed \(string)")
          
            labelSpeed.text = string
            
        }

        if let gps =  mission.gpsList.last {
            
            let stringX =  "\(gps.x)"
            let stringY =  "\(gps.y)"
            let stringZ =  "\(gps.z)"
            
            NSLog("%@", " Data \(stringX)")
            
            labelGPSx.text = stringX
            labelGPSy.text = stringY
            labelHeight.text = stringZ
           
            delegate?.drawLine(mission.gpsList)
        }
 
        
        if let image =  mission.imageList.last {
            var imageListTmp:[UIImage] = [UIImage]()
            
            imageListTmp.append(image)
            
            imageList = imageListTmp
            
            startAnimation()
          
            
            
        }

       plotView.setNeedsDisplay()
    }
    
    /**
        Shows data on Screen after notification
    */
    func displayAfterNotification(notification: NSNotification){
        
        
        displayData()
        
        
    }
    

    
    /**
        Updates MissionModel after Notification
    */
    func updateMissionModel(notification: NSNotification){
    
    mission.speedList = networkRecProp!.speedList
        NSLog("%@", " old Data battery count: \(mission.batterieList.count)")
    mission.batterieList = networkRecProp!.batteryList
        NSLog("%@", " new Data battery count: \(mission.batterieList.count)")
    mission.gpsList = networkRecProp!.gpsList
   // mission.imageList = networkRecProp.imageList
   
        
 
    }
    
    /**
        Shows data on Screen after button pressed
    */

    
    @IBAction func refreshButtonPressed(sender: AnyObject) {
         NSLog("%@", "refreshButtonPressed")
        displayData()
    }
    

    
    /**
    
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.startSwitch.on = false
        
       
      
        
        // Starting the network sever
        networkRecProp = NetworkRecProp()
        networkSender = NetworkSender()
        networkRecPicture = NetworkRecPicture()
        

     
        // Notification  if mission data change
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("displayAfterNotification:"), name: "Mission", object: nil)
    
        NSNotificationCenter.defaultCenter().addObserver(self,selector: Selector("updateMissionModel:"), name: "MissionUpdate", object: nil)
       
        
        // Updates the View every 5 seconds
        // timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("displayData"), userInfo: nil, repeats: true)
        
        
        
        // ToDo: threading nicht mehr nötig, aber empfholen, da sonst verklemmungen auftreten könnten
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            self.networkSender!.start("127.0.0.1")
        }
           //  var networkRecProp = NetworkRecProp()
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            self.networkRecProp!.start("127.0.0.1")
        }
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            self.networkRecPicture!.start("127.0.0.1")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    /**
    
    */
    @IBAction func startSwitchChanged(sender: AnyObject) {
        if (self.startSwitch.on) {
            self.networkSender?.sendMission(delegate!.getWaypoints())
        }
    }
    
    
    /**
    
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var destination = segue.destinationViewController as? UIViewController
        if let navCon = destination as? UINavigationController {
            destination = navCon.visibleViewController
        }
        
      
        
        if let map = destination as? MapViewController {
            
            if let identifier = segue.identifier {
                switch identifier {
                case "SetMap": map.gpsPositions = gpsList
                    
                default:
                    NSLog("%@", "Fehler Segue SetMAP")
 
                }
               
            }
            
        }
        
    }
    
    
    /**
    Starts the Animation
    */
    
    func startAnimation() {
        
        NSLog("%@", "ANIMATIONDURATION: \(ANIMATIONDURATION) ")
        NSLog("%@", "Animation started:  ")
        ImageView.animationImages = imageList
        ImageView.animationDuration = ANIMATIONDURATION
        ImageView.animationRepeatCount = 1
        ImageView.startAnimating()
        
        
    }
   

    // MARK: - Implement delegates

    /**
    Sets the points for the Plottviewcontroller
    
    PlotviewDataSourece protocol implementation
    */
    
    func setPoints(sender: PlotView) -> [CGPoint?]
        
    {
        var listPoints  = [CGPoint?]()
        
        let eintraegeCount = batterieList.count
      
        NSLog("%@", " eintraegeCount: \(batterieList.count) ")
      
        if eintraegeCount > 1
        {
            
            
            for i in 0...eintraegeCount - 1
            {
             
                
                let x = CGFloat(i )
                let y = CGFloat(  batterieList[i]   )
                
                let point = CGPoint(x: x, y: y)
                
                listPoints.append(point)
                
            }
            
            
        }
        else{
        
    
        
        NSLog("%@", "Points size: \(listPoints.count) ")
        
        }
        return listPoints
    }
    
   
}


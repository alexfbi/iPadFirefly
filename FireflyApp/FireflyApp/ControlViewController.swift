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



class ControlViewController: UIViewController,MissionModelDelegate,PlotViewDataSource  {
    
    
    @IBOutlet weak var startSwitch: UISwitch!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var labelGPSx: UILabel!
    @IBOutlet weak var labelGPSy: UILabel!
    @IBOutlet weak var labelBatterie: UILabel!
    @IBOutlet weak var labelSpeed: UILabel!
    @IBOutlet weak var labelHeight: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var buttonCreateData: UIButton!
    
    var log:Log?
    
    var batterieList = [Double]()
    var gpsList = [GPS_Struct]()
    
    var buttonPressed = false
    var controlDBModell:ControlDBModel =  ControlDBModel()
    var controlTestDaten:ControlTestDatenModel = ControlTestDatenModel()
    
    
    var imageList = [UIImage]()
    
    var countNumber = 1.0
    
    let ANIMATIONDURATION: NSTimeInterval = 5
    
    
    @IBAction func buttonCreateDataPressed(sender: AnyObject) {
        
        
        //  controlTestDaten.createData()
        
        
        //  }
        //  @IBAction func buttonPressed(sender: AnyObject) {
        
        
        
        missionModel.name = "Mission"
        
        
        
        missionModel.gpsList.append(GPS_Struct(x: countNumber * 0.01, y: countNumber * 0.01, z:countNumber * 0.01))
        
        //  var battery:Battery = Battery()
        //   battery.value = countNumber
        
        
        for i in 1...20{
            missionModel.batterieList.append(countNumber)
            missionModel.speedList.append(countNumber)
            
            
            
            let imageNameTmp = "\(countNumber % 10)"
            
            var image =  UIImage(named: imageNameTmp)
            
            if ( nil != image){
                missionModel.imageList.append(image!)
            }
            ++countNumber
            
        }
        
        
    }
    
    @IBAction func refreshButtonPressed(sender: AnyObject) {
        
 
       
        startAnimation()
    }
    
    
    
    var missionModel:MissionModel = MissionModel()
        {//1 -- instantiate a model object, for didSet need to define
        didSet{ //any change to the class, but not the properties
            displayData()
        }
    }
    
    
    func displayData() {
        
        imageList = missionModel.imageList
      
        if( imageList.count >= 100 )
        {
            startAnimation()
        }
        
        
        
        let displayString = missionModel.batterieList.last
        
        labelBatterie.text = String(stringInterpolationSegment: displayString)
        
        
        batterieList = missionModel.batterieList
        
        plotView.setNeedsDisplay()
        
        
        
        
        let displayGpsX = missionModel.gpsList.last
        
        labelGPSx.text = String(stringInterpolationSegment: displayGpsX?.x)
        
         labelGPSy.text = String(stringInterpolationSegment: displayGpsX?.y)
       
        labelHeight.text = String(stringInterpolationSegment: displayGpsX?.z)
        
        gpsList = missionModel.gpsList
     
        performSegueWithIdentifier("SetMap", sender: nil)
        
        let displaySpeed = missionModel.speedList.last
        
        
     
        labelSpeed.text = String(stringInterpolationSegment: displaySpeed)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Control"
        
        
        self.startSwitch.on = false
        missionModel.delegate = self
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func startSwitchChanged(sender: AnyObject) {
        
        if (self.startSwitch.on) {
            if (self.startSwitch.on) {
                var networkSender = NetworkSender()
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
                    networkSender.start()
                }
                var networkRecProp = NetworkRecProp()
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
                    networkRecProp.start()
                }
                var networkRecPicture = NetworkRecPicture()
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
                    networkRecPicture.start()
                }
            }
            
        }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var destination = segue.destinationViewController as? UIViewController
        if let navCon = destination as? UINavigationController {
            destination = navCon.visibleViewController
        }
        
        if let map = destination as? FirstViewController {
            
            if let identifier = segue.identifier {
                switch identifier {
                case "SetMap": map.gpsPositions = gpsList
                    
                default:
                    NSLog("%@", "Fehler Segue SetMAP")
 
                }
               
            }
            
        }
        
    }
    
    
    func startAnimation() {
        
        NSLog("%@", "ANIMATIONDURATION: \(ANIMATIONDURATION) ")
        NSLog("%@", "Animation started:  ")
        ImageView.animationImages = imageList
        ImageView.animationDuration = ANIMATIONDURATION
        
        
        ImageView.animationRepeatCount = 1
        
        ImageView.startAnimating()
        
        
    }



    
    
    
    
    
    @IBOutlet weak var plotView: PlotView!
        {
        didSet{
              plotView.dataSource = self
        }
    }



    //Im release rausnehmen
  //  var oldeintraegeCount:Int = 0
    
    
    func setPoints(sender: PlotView) -> [CGPoint?]
        
    {
        var listPoints  = [CGPoint?]()
        
        
        
        let eintraegeCount = batterieList.count
      
        NSLog("%@", " eintraegeCount: \(batterieList.count) ")
        if eintraegeCount > 0
        {
            
            
            for i in 0...eintraegeCount - 1
            {
             //   var date:NSDate = batterieList[i].date
                
                let x = CGFloat(i )
                let y = CGFloat(  batterieList[i]   )
                
                let point = CGPoint(x: x, y: y)
                
                listPoints.append(point)
                
            }
        }
        
     //   oldeintraegeCount = eintraegeCount
        
        NSLog("%@", " setPointsSize: \(listPoints.count) ")
        return listPoints
        
    }
    
    
    

    
}


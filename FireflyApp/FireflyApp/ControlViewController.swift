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


private var myContext = 0

protocol ControlViewDelegate {
    func drawLine(gpsList: [GPS_Struct])
}

class ControlViewController:  UIViewController, NetworkModelDelegate, MissionModelDelegate,PlotViewDataSource  {
    
    var timer = NSTimer()
    var timerCount = 0
    
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
 //   var controlDBModell:ControlDBModel =  ControlDBModel()
 //   var controlTestDaten:ControlTestDatenModel = ControlTestDatenModel()
    
    
    var imageList = [UIImage]()
    
    var countNumber = 1.0
    
    let ANIMATIONDURATION: NSTimeInterval = 5
    
    var delegate:ControlViewDelegate?
    
    var networkSender:NetworkSender?
    var networkRecPicture:NetworkRecPicture?
    
    var missionModel:MissionModel = MissionModel()
        {//1 -- instantiate a model object, for didSet need to define
        didSet{ //any change to the class, but not the properties
            displayData()
        }
    }
    
    
    var networkRecProp = NetworkRecProp()
        {//1 -- instantiate a model object, for didSet need to define
        didSet{ //any change to the class, but not the properties
            displayData()
        }
    }
    
   
    func display()
    {
        
        var battery:[Double] = networkRecProp.getBattery()
        
        
        var string:String = ""
        
        if battery.last != nil {
            batterieList = battery
            var batteryDouble:Double = battery.last!
            string =  "\(batteryDouble)"
            
            NSLog("%@", " Data Batterie \(string)")
            labelBatterie.text = string
            
            plotView.setNeedsDisplay()
           
        }
        
        
        if let speed =  networkRecProp.speedList.last {
            
            string =  "\(speed)"
            
            NSLog("%@", " Data Speed \(string)")
          
            labelSpeed.text = string
        //    plotView.setNeedsDisplay()
            
        }

        if let gps =  networkRecProp.gpsList.last {
            
            let stringX =  "\(gps.x)"
            let stringY =  "\(gps.y)"
            let stringZ =  "\(gps.z)"
            
            NSLog("%@", " Data \(stringX)")
            
            labelGPSx.text = stringX
            labelGPSy.text = stringY
            labelHeight.text = stringZ
            //    plotView.setNeedsDisplay()
            
        }
 
        
        if let image =  networkRecProp.imageList.last {
            var imageListTmp:[UIImage] = [UIImage]()
            
            imageListTmp.append(image)
            
            imageList = imageListTmp
            
            startAnimation()
          
            
            
        }

      
    }
    
    
    @IBAction func buttonCreateDataPressed(sender: AnyObject) {
        
        
        //  controlTestDaten.createData()
        
        
        
        missionModel.name = "MissionName"
        
        
        
     
        missionModel.gpsList.append(GPS_Struct(x: countNumber * 0.01, y: countNumber * 0.01, z:countNumber * 0.01))
        
    
        for i in 1...20{
            missionModel.batterieList.append(countNumber)
            missionModel.speedList.append(countNumber)
            
            
            
            let imageNameTmp = "\(countNumber % 20)"
            
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
    
    func displayData() {
         NSLog("%@", "Display Data ")
        
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
     
        delegate?.drawLine(gpsList)
        
        let displaySpeed = missionModel.speedList.last
        
        
     
        labelSpeed.text = String(stringInterpolationSegment: displaySpeed)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        title = "Control"
        
        
        //Observer
        networkRecProp.addObserver(self, forKeyPath: "batterieList", options: .New, context: &myContext)
        
        self.startSwitch.on = false
        
        //Delegates
        networkRecProp.delegate = self
        missionModel.delegate = self
        
        // Starting the network sever
        networkSender = NetworkSender()
        networkRecPicture = NetworkRecPicture()
        
        
        // ToDo: threading nicht mehr nötig
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            self.networkSender!.start("127.0.0.1")
        }
        //     var networkRecProp = NetworkRecProp()
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            self.networkRecProp.start("127.0.0.1")
        }
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            self.networkRecPicture!.start("127.0.0.1")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func startSwitchChanged(sender: AnyObject) {
        if (self.startSwitch.on) {
            self.networkSender?.sendWaypoints()
        }
    }
    
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



    
    func setPoints(sender: PlotView) -> [CGPoint?]
        
    {
        var listPoints  = [CGPoint?]()
        
        let eintraegeCount = batterieList.count
      
        NSLog("%@", " eintraegeCount: \(batterieList.count) ")
      
        if eintraegeCount > 1
        {
            
            
            for i in 0...eintraegeCount - 1
            {
             //   var date:NSDate = batterieList[i].date
                
                let x = CGFloat(i )
                let y = CGFloat(  batterieList[i]   )
                
                let point = CGPoint(x: x, y: y)
                
                listPoints.append(point)
                
            }
             //   oldeintraegeCount = eintraegeCount
            
        }
        else{
        
    
        
        NSLog("%@", " setPointsSize: \(listPoints.count) ")
        
        }
        return listPoints
    }
    
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [NSObject : AnyObject]?, context: UnsafeMutablePointer<Void>) {
       
        if context == &myContext {
        
            if let newValue:AnyObject = change?[NSKeyValueChangeNewKey] {
                var val: [Double] = newValue as! [Double]
                 NSLog("%@", "Value battery changed size: \(val.count) ")
              
            
//                labelBatterie.text = String(stringInterpolationSegment: val.last)
//                labelBatterie.
//                missionModel.batterieList = networkRecProp.batteryList
//               
//                batterieList = missionModel.batterieList
//                
                
             //   plotView.setNeedsDisplay()
    
//                var battery:[Double] = val
//                
//                var string:String = ""
//                
//                if battery.last != nil {
//                    var batteryDouble:Double = battery.last!
//                    string =  "\(batteryDouble)"
//                    
//                    NSLog("%@", " Data Obersver: \(string)")
//                    labelBatterie.text = string
//                }
                

                
            }
        } else {
            super.observeValueForKeyPath(keyPath!, ofObject: object!, change: change!, context: context)
        }
    }
    
    deinit {
        networkRecProp.removeObserver(self, forKeyPath: "batterieList", context: &myContext)
    }
    
}


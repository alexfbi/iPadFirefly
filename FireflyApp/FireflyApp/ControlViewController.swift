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
        
        NSLog("%@", "Display Data")
        
        var string:String = ""
        
        NSLog("%@", "Battery")
        
        if let  battery =  mission.batterieList.last {
          
            string =  "\(battery)"
            
            NSLog("%@", " Data Batterie \(string)")
            
            dispatch_async(dispatch_get_main_queue()) {
                self.labelBatterie.text = string
            }
            
            
           
           
        }
        
        NSLog("%@", "Speed")
        
        if let speed =  mission.speedList.last {
            
            string =  "\(speed)"
            
            NSLog("%@", " Data Speed \(string)")
          
            dispatch_async(dispatch_get_main_queue()) {
                self.labelSpeed.text = string
            }
            
            
        }

        NSLog("%@", "GPS")
        
        if let gps =  mission.gpsList.last {
            
            let stringX =  "\(gps.x)"
            let stringY =  "\(gps.y)"
            let stringZ =  "\(gps.z)"
            
            NSLog("%@", " Data \(stringX)")
            
            dispatch_async(dispatch_get_main_queue()) {
                self.labelGPSx.text = stringX
                self.labelGPSy.text = stringY
                self.labelHeight.text = stringZ
            }
            
            delegate?.drawLine(mission.gpsList)
        }
 
        NSLog("%@", "Image")
        
        if let image =  mission.imageList.last {
            var imageListTmp:[UIImage] = [UIImage]()
            
            imageListTmp.append(image)
            
            imageList = imageListTmp
            
            startAnimation()
        }
        
        NSLog("%@", "Output")
        
        

        plotView.setNeedsDisplay()
        
        NSLog("%@", "Finished display")
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
        self.networkRecProp = NetworkRecProp()
        self.networkSender = NetworkSender()
        self.networkRecPicture = NetworkRecPicture()
        

     
        // Notification  if mission data change
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("displayAfterNotification:"), name: "Mission", object: nil)
    
        NSNotificationCenter.defaultCenter().addObserver(self,selector: Selector("updateMissionModel:"), name: "MissionUpdate", object: nil)
       
        
        // Updates the View every 5 seconds
        // timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("displayData"), userInfo: nil, repeats: true)
        
        
        
        // ToDo: threading nicht mehr nötig, aber empfholen, da sonst verklemmungen auftreten könnten
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            //self.networkSender!.start("141.100.75.214")
            self.networkSender!.start(self.getIFAddresses().last!)
        }
           //  var networkRecProp = NetworkRecProp()
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            //self.networkRecProp!.start("141.100.75.214")
            self.networkRecProp!.start(self.getIFAddresses().last!)
            while (true) {
                self.networkRecProp!.receiveMessage()
            }
        }
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            //self.networkRecPicture!.start("141.100.75.214")
            self.networkRecPicture!.start(self.getIFAddresses().last!)
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
            // TODO: Waypoints in Datenbank schreiben
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
    
    /**
    Get all IFAdresses.
    
    :returns: Array of all IFAdresses
    */
    // TODO: the last entry is the ip address of the device. In any case?
    func getIFAddresses() -> [String] {
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs> = nil
        if getifaddrs(&ifaddr) == 0 {
            
            // For each interface ...
            for (var ptr = ifaddr; ptr != nil; ptr = ptr.memory.ifa_next) {
                let flags = Int32(ptr.memory.ifa_flags)
                var addr = ptr.memory.ifa_addr.memory
                
                // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        
                        // Convert interface address to a human readable string:
                        var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                                if let address = String.fromCString(hostname) {
                                    addresses.append(address)
                                }
                        }
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        
        return addresses
    }
   
}


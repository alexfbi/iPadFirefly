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
import CoreLocation

protocol ControlViewDelegate {
    func drawLine(gpsList: [GPS_Struct])
    func getWaypoints() -> [Waypoint]
    // TODO: Anzeige Verbindungsstatus
    func setConnectionLabel(isConnected: Bool)
}



class ControlViewController:  UIViewController, PlotMultiViewDataSource, CLLocationManagerDelegate  {
   
    
    
      // MARK: - Variables
    let ANIMATIONDURATION: NSTimeInterval = 5
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
   // var timer = NSTimer()
    var log:Log?
    //var batterieList = [Double]()
    var gpsList = [GPS_Struct]()
    var imageList = [UIImage]()
    
    
    var delegate:ControlViewDelegate?
    var networkRecProp:NetworkRecProp?
    var networkSender:NetworkSender?
    var networkRecPicture:NetworkRecPicture?
    
    var mission:MissionModel = MissionModel()
    var locationManager  = CLLocationManager()
    var haunterMode = false
    
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
    @IBOutlet weak var labelHauntedMode: UILabel!
    @IBOutlet weak var labelRouteMode: UILabel!
    
    @IBOutlet weak var plotView: PlotMultiView!
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
            
             var string =  "\(speed)"
            
            NSLog("%@", " Data Speed \(string)")
          
            dispatch_async(dispatch_get_main_queue()) {
                self.labelSpeed.text = string
            }
            
            
        }

        NSLog("%@", "GPS")
        
        if let gps =  mission.gpsList.last {
            
            let stringX =  "\(gps.x)"
            let stringY =  "\(gps.y)"
         //   let stringZ =  "\(gps.z)"
            
            NSLog("%@", " Data \(stringX)")
            
            dispatch_async(dispatch_get_main_queue()) {
                self.labelGPSx.text = stringX
                self.labelGPSy.text = stringY
       //         self.labelHeight.text = stringZ
            }
            
            delegate?.drawLine(mission.gpsList)
        }
        
        if let altitude =  mission.altitudeList.last {
            var string =  "\(altitude)"
            
            NSLog("%@", " Data Speed \(string)")
         
            dispatch_async(dispatch_get_main_queue()) {
               self.labelHeight.text = string            }
        }
        
 
        NSLog("%@", "Image Count \(mission.imageList.count)")
        
        if let image =  mission.imageList.last {
            var imageListTmp:[UIImage] = [UIImage]()
            
            imageListTmp.append(image)
            
            
            imageList = imageListTmp
             dispatch_async(dispatch_get_main_queue()) {
                self.startAnimation()
            }
        }
        
        NSLog("%@", "Output")
        
        
        dispatch_async(dispatch_get_main_queue()) {
            self.plotView.setNeedsDisplay()
        }
        
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
    
        
        if ( networkRecProp!.speedList.count > 0)
        {
            mission.speedList.append(networkRecProp!.speedList.last!)
            networkRecProp!.speedList.removeAll(keepCapacity: false)
        }
     
        
        if ( networkRecProp!.batteryList.count > 0 )
        {
            mission.batterieList.append(networkRecProp!.batteryList.last!)
            networkRecProp!.batteryList.removeAll(keepCapacity: false)
        }
        
        if ( networkRecProp!.gpsList.count > 0)
        {
            mission.gpsList.append(networkRecProp!.gpsList.last!)
            networkRecProp!.gpsList.removeAll(keepCapacity: false)
        }
        
     
        if ( networkRecProp!.altitudeList.count > 0)
        {
            mission.altitudeList.append(networkRecProp!.altitudeList.last!)
            networkRecProp!.altitudeList.removeAll(keepCapacity: false)
        }
        
        if (networkRecPicture!.imageList.count > 0){
            
            mission.imageList.append(networkRecPicture!.imageList.last!)
            networkRecPicture!.imageList.removeAll(keepCapacity: false)
        }
        
        
 
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
     
        //Startring GPS localization
       
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
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
        
        
        if (self.getIFAddresses().count > 0) {
            // ToDo: threading nicht mehr nötig, aber empfholen, da sonst verklemmungen auftreten könnten
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
                self.networkSender!.start(self.getIFAddresses().last!)
                self.delegate?.setConnectionLabel(true)
            }
            
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
                self.networkRecProp!.start(self.getIFAddresses().last!)
                while (true) {
                    self.networkRecProp!.receiveMessage()
                }
            }
            
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
                self.networkRecPicture!.start(self.getIFAddresses().last!)
                 while (true) {
                    self.networkRecPicture!.receiveAndSavePicture()
                }
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func saveWayPointsInDB(waypoints: [Waypoint]){
        
        
         }
   
    
    func saveNewMissionOnDB() {
        
        let fetchRequestSpeed = NSFetchRequest(entityName: "Log")
        
        
         var log = context?.executeFetchRequest(fetchRequestSpeed, error: nil) as! [Log]
        
        var id = log.count + 1
        
        var newLog = NSEntityDescription.insertNewObjectForEntityForName("Log", inManagedObjectContext: self.context!) as! Log
        
        
        newLog.name = "Mission \(id)"
        newLog.id = id
        newLog.date = NSDate()
        
        NSLog("%@", " new Log inserted: \(newLog.name)")
        
        self.context?.save(nil)
    }
    
    /**
    Sets a new mission entry into database and sends the waypoints to the reciever
    */
    @IBAction func startSwitchChanged(sender: AnyObject) {
        if (self.startSwitch.on) {
            self.networkSender?.sendMission(delegate!.getWaypoints())
            //self.networkSender?.sendCommand("start")
            
            saveWayPointsInDB(delegate!.getWaypoints())
            saveNewMissionOnDB()

            haunterModeSwitch.hidden = true
            labelHauntedMode.hidden = true
            
        }
        else{
              NSLog("%@", " Switch turned off")
            
            //ToDO Welche Befehle, wie sind die Befehle aufgebaut ?????
            self.networkSender?.sendCommand("stop")
            
            haunterModeSwitch.hidden = false
            labelHauntedMode.hidden = false
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
    
    func setPoints(sender: PlotMultiView) -> ([CGPoint],[CGPoint],[CGPoint], Double, Double)
        
    {
        var points = [CGPoint]()
        var output:[Int : [CGPoint] ]  = [0: [CGPoint](), 1 : [CGPoint](), 2: [CGPoint]()]
        

        
        var valuesStatus:[Int : [Double]] = [0: mission.batterieList, 1: mission.speedList, 2: mission.altitudeList]
      
        var maxX = 0.0
        var maxY = 0.0
        for j in 0...2
        {
            
        var status = valuesStatus[j]!
         maxX = Double(status.count)
    
        if status.count > 1
        {
           for i in 0...status.count - 1
            {
            
                if ( maxY < status[i] )
                {
                    maxY = status[i]
                }
            
                let x = CGFloat(i )
                let y = CGFloat( status[i]   )
                let point = CGPoint(x: x, y: y)
                
                output[j]!.append(point)
                
            }
            
            
        }
        else{
    
            NSLog("%@", "Points size: \(output[j]!.count) ")
        
        }
        }
        
        return (output[0]!,output[1]!,output[2]!, maxX, maxY)
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
    
    
    @IBOutlet weak var haunterModeSwitch: UISwitch!
    
    
    @IBAction func haunterModeChanged(sender: AnyObject) {
        if (haunterModeSwitch.on){
            haunterMode = true
            saveNewMissionOnDB()
            
            startSwitch.hidden = true
            labelRouteMode.hidden = true
        }
        else{
            haunterMode = false
            
            startSwitch.hidden = false
            labelRouteMode.hidden = false
        }
        
    }
    
   
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
       
        if ( haunterMode == true){
             let location = locations[0] as! CLLocation
            
                println(location.coordinate.latitude)
                println(location.coordinate.longitude)
                var str = "\(location.coordinate.latitude) , \(location.coordinate.longitude)"
        
            
            self.networkSender?.sendCommand(str)
            self.networkSender?.sendCommand("start")
        }
    }
    
    
    
}


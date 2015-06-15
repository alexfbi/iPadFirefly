//
//  NetworkReceiver.swift
//  FireflyApp
//
//  Created by Christian Adam on 27.05.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol NetworkModelDelegate{
    func displayData()
}

class NetworkRecProp:NSObject {
    
    // dynamic var batteryList = [Double]()
    
    var buffersize:Int = 100
    var client:TCPClient?
    var status:String?
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    //temp
    var counter = 0
    
    
    func start(ip: String){
        var server:TCPServer = TCPServer(addr: ip, port: 50000)
        println("Server started")
        var (success,msg)=server.listen()
        if success{
            client = server.accept()
            if client != nil {
                println("connection etablished")
            }else{
                println("accept error")
            }
        }else{
            println(msg)
        }
    }
    
    func receiveAndSaveStatusInformations(){
        var recMessage = client!.read(100)
        var cleanedMessage = NSString(bytes: recMessage!, length: recMessage!.count, encoding: NSUTF8StringEncoding)
        
        var msgArray = cleanedMessage!.componentsSeparatedByString(";")
        
        let fetchRequest = NSFetchRequest(entityName: "Log")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        fetchRequest.fetchLimit = 1
        let log: Log = (context?.executeFetchRequest(fetchRequest, error: nil) as! [Log])[0]
        
        switch (msgArray[0] as! String) {
        case "status":
            status = "inMission"
            saveGPS(msgArray[1] as! NSString, log: log)
            saveBattery(msgArray[2] as! NSString, log: log)
            saveSpeed(msgArray[3] as! NSString, log: log)
            break;
        case "missionover":
            status = ""
            break;
        default:
            println("error in message-worker")
            break;
        }
    }
    
    private func saveGPS(coordinates: NSString, log: Log){
        var gpsArray = coordinates.componentsSeparatedByString(",")
        var newGPS = NSEntityDescription.insertNewObjectForEntityForName("GPS", inManagedObjectContext: self.context!) as! GPS
        newGPS.id = counter
        newGPS.valueX = (gpsArray[0] as! NSString).doubleValue
        newGPS.valueY = (gpsArray[1] as! NSString).doubleValue
        newGPS.valueZ = (gpsArray[2] as! NSString).doubleValue
        newGPS.date = NSDate()
        newGPS.log = log
        self.context?.save(nil)
        
        var gps:GPS_Struct = GPS_Struct(x: newGPS.valueX ,y: newGPS.valueY, z:  newGPS.valueZ)
        gpsList.append(gps)
    }
    
    private func saveBattery(charge: NSString, log: Log){
        var newBattery = NSEntityDescription.insertNewObjectForEntityForName("Battery", inManagedObjectContext: self.context!) as! Battery
        var str: NSString = charge
        newBattery.value = str.doubleValue
        newBattery.date = NSDate()
        newBattery.id = counter
        newBattery.log = log
        self.context?.save(nil)
        
        batterieList.append(Double(newBattery.value))
        // println(batterieList.count)
    }
    
    private func saveSpeed(speed: NSString, log: Log){
        var newSpeed = NSEntityDescription.insertNewObjectForEntityForName("Speed", inManagedObjectContext: self.context!) as! Speed
        var str: String = speed as! String
        newSpeed.value = str.toInt()!
        newSpeed.date = NSDate()
        newSpeed.id = counter
        newSpeed.log = log
        self.context?.save(nil)
        
        speedList.append(Double(newSpeed.value))
    }
    
    
    var delegate:NetworkModelDelegate? = nil
    
    
    var imageList:[UIImage] = [UIImage](){
        
        
        didSet
        {
            if imageList.count == 100
            {
                delegate?.displayData()
                imageList.removeAll(keepCapacity: true)
            }
        }
    }
    
    
    var gpsList:[GPS_Struct] = [GPS_Struct](){
        didSet{
            delegate?.displayData()
        }
        
    }
    
    dynamic var batterieList:[Double] = [Double](){
        didSet{
            delegate?.displayData()
            
        }
        
    }
    
    
    var speedList:[Double] = [Double]() {
        didSet{
            delegate?.displayData()
        }
        
    }
    
    
    func getBattery() -> [Double]{
        
        return batterieList
    }
    
}
//
//  NetworkRecProp.swift
//  FireflyApp
//
//  Created by Christian Adam on 27.05.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation
import UIKit
import CoreData



class NetworkRecProp:NSObject {
    
    
    
    
    var gpsList:[GPS_Struct] = [GPS_Struct]()
    var batteryList:[Double] = [Double]()
    
    var speedList:[Double] = [Double]()
    var altitudeList:[Double] = [Double]()
    
    var client:TCPClient?
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
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
    
    func receiveMessage(){
        
        if(client == nil){
            //println("Fehler client")
            return;
        }
        
        var recMessage = client!.read(100)
        
        if recMessage != nil{
            var cleanedMessage = NSString(bytes: recMessage!, length: recMessage!.count, encoding: NSUTF8StringEncoding)
            
            var msgArray = cleanedMessage!.componentsSeparatedByString(";")
            
            let fetchRequest = NSFetchRequest(entityName: "Log")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            fetchRequest.fetchLimit = 1
            let log: Log = (context?.executeFetchRequest(fetchRequest, error: nil) as! [Log])[0]
            
            switch (msgArray[0] as! String) {
            case "status":
                saveGPS(msgArray[1] as! NSString, log: log)
                saveBattery(msgArray[2] as! NSString, log: log)
                saveSpeed(msgArray[3] as! NSString, log: log)
                statusCounter++
                
                //send Broadcast about change
                notify()
                break;
            case "missionover":
                statusCounter = 0
                pictureCounter = 0
                break;
            default:
                println("error in message-worker")
                break;
            }
        }
    }
    
    private func saveGPS(coordinates: NSString, log: Log){
        var gpsArray = coordinates.componentsSeparatedByString(",")
        
        var newGPS = NSEntityDescription.insertNewObjectForEntityForName("GPS", inManagedObjectContext: self.context!) as! GPS
        newGPS.id = statusCounter
        newGPS.valueX = (gpsArray[0] as! NSString).doubleValue
        newGPS.valueY = (gpsArray[1] as! NSString).doubleValue
        newGPS.valueZ = (gpsArray[2] as! NSString).doubleValue
        newGPS.date = NSDate()
        newGPS.log = log
        self.context?.save(nil)
        
        
        
        var gps:GPS_Struct = GPS_Struct(x: newGPS.valueX ,y: newGPS.valueY)
        gpsList.append(gps)
        altitudeList.append(Double(newGPS.valueZ))
        
    }
    
    private func saveBattery(charge: NSString, log: Log){
        var newBattery = NSEntityDescription.insertNewObjectForEntityForName("Battery", inManagedObjectContext: self.context!) as! Battery
        var str: NSString = charge
        newBattery.value = str.doubleValue
        newBattery.date = NSDate()
        newBattery.id = statusCounter
        newBattery.log = log
        self.context?.save(nil)
        
        batteryList.append(Double(newBattery.value))
    }
    
    private func saveSpeed(speed: NSString, log: Log){
        var newSpeed = NSEntityDescription.insertNewObjectForEntityForName("Speed", inManagedObjectContext: self.context!) as! Speed
        var str: String = speed as! String
        newSpeed.value = str.toInt()!
        newSpeed.date = NSDate()
        newSpeed.id = statusCounter
        newSpeed.log = log
        self.context?.save(nil)
        
        speedList.append(Double(newSpeed.value))
    }
    
    
    
    /**
    Broadcast about changes
    @brief  NSNotification: MissionUpdate
    */
    
    func notify(){
        
        NSNotificationCenter.defaultCenter().postNotificationName("MissionUpdate", object: self )
    }
    
}
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

class NetworkRecProp {
    
    var buffersize:Int = 1000
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    func start(){
        var server:TCPServer = TCPServer(addr: "192.168.1.30", port: 50000)
        println("Server started")
        var (success,msg)=server.listen()
        if success{
            while true{
                if var client=server.accept(){
                    println("connection etablished")
                    receiveControll(client: client)
                }else{
                    println("accept error")
                }
            }
        }else{
            println(msg)
        }
    }
    
    func receiveControll(client c:TCPClient){
        while("yes" == holdSockets){
            var recMessage = c.read(buffersize)
            var cleanedMessage = NSString(bytes: recMessage!, length: recMessage!.count, encoding: NSUTF8StringEncoding)
            parser(message: cleanedMessage!)
        }
        c.close()
    }
    
    func parser(message msg: NSString){
        var msgArray = msg.componentsSeparatedByString(";")
        
        let fetchRequest = NSFetchRequest(entityName: "Log")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        fetchRequest.fetchLimit = 1
        let log: Log = (context?.executeFetchRequest(fetchRequest, error: nil) as! [Log])[0]
        
        switch (msgArray[0] as! String) {
        case "status":
            saveGPS(msgArray[1] as! NSString, log: log)
            saveBattery(msgArray[2] as! NSString, log: log)
            saveSpeed(msgArray[3] as! NSString, log: log)
            break;
        case "missionover":
            counter = 0
            isDroneInMission = "no"
            break;
        default:
            println("error in parser")
            break;
        }
        counter++
    }
    
    func saveGPS(coordinates: NSString, log: Log){
        var gpsArray = coordinates.componentsSeparatedByString(",")
        var newGPS = NSEntityDescription.insertNewObjectForEntityForName("GPS", inManagedObjectContext: self.context!) as! GPS
        newGPS.id = counter
        newGPS.valueX = gpsArray[0] as! Double
        newGPS.valueY = gpsArray[1] as! Double
        newGPS.valueZ = gpsArray[2] as! Double
        newGPS.date = NSDate()
        newGPS.log = log
        self.context?.save(nil)
    }
    
    func saveBattery(charge: NSString, log: Log){
        var newBattery = NSEntityDescription.insertNewObjectForEntityForName("Battery", inManagedObjectContext: self.context!) as! Battery
        var str: String = charge as! String
        newBattery.value = str.toInt()!
        newBattery.date = NSDate()
        newBattery.id = counter
        newBattery.log = log
        self.context?.save(nil)
    }
    
    func saveSpeed(speed: NSString, log: Log){
        var newSpeed = NSEntityDescription.insertNewObjectForEntityForName("Speed", inManagedObjectContext: self.context!) as! Speed
        var str: String = speed as! String
        newSpeed.value = str.toInt()!
        newSpeed.date = NSDate()
        newSpeed.id = counter
        newSpeed.log = log
        self.context?.save(nil)
    }
    
}
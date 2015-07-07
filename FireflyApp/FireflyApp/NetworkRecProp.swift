//
// NetworkRecProp.swift
// FireflyApp
//
// Created by Christian Adam on 27.05.15.
// Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation
import UIKit
import CoreData

/**
This class contains the controll for use the ServerClasses. The Class initialize the connection to the client and controll the receiving of Informations such as GPS Data from the Client. The Class has a funciton for parsing this Informations and save the data into the Database.
*/
class NetworkRecProp:NSObject {
    
    // MARK: - Variables
    
    var client:TCPcommunication?
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    // arrays for the view
    var gpsList:[GPS_Struct] = [GPS_Struct]()
    var batteryList:[Double] = [Double]()
    var speedList:[Double] = [Double]()
    var altitudeList:[Double] = [Double]()
    
    /**
    This function is starting the communication between a TCPServer object and a TCPcommunication object.
    
    :param: The server ip for listen for a incomming connection establishment from a client.
    */
    func start(ip: String){
        var server:TCPServer = TCPServer(ip: ip, port: 50000)
        println("Server started")
        var (success, msg)=server.listen()
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
    
    /**
    This function is receiving, parsing and saving informations from a client
    */
    func receiveMessage(){
        
        if(client == nil){
            //println("Fehler client")
            return;
        }
        
        var recMessage = client!.read(100)
        
        if recMessage != nil{
            // convert the readed byte array into a NSString
            var cleanedMessage = NSString(bytes: recMessage!, length: recMessage!.count, encoding: NSUTF8StringEncoding)
            
            // split the String into a String array with the ; as delimiter
            var msgArray = cleanedMessage!.componentsSeparatedByString(";")
            
            // getting the youngest Log entry, for saving the informations proper to the youngest log, from the database
            let fetchRequest = NSFetchRequest(entityName: "Log")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            fetchRequest.fetchLimit = 1
            let log: Log = (context?.executeFetchRequest(fetchRequest, error: nil) as! [Log])[0]
            
            // checking for the message type
            switch (msgArray[0] as! String) {
            case "status":
                // structure of the status message: status;longitude,latitude,height;batterystatus;speed;end
                saveGPS(msgArray[1] as! NSString, log: log)
                saveBattery(msgArray[2] as! NSString, log: log)
                saveSpeed(msgArray[3] as! NSString, log: log)
                statusCounter++
                
                //send Broadcast about change
                notify()
                break;
            case "missionover":
                //resetting the counter for database entrys
                statusCounter = 0
                pictureCounter = 0
                NSNotificationCenter.defaultCenter().postNotificationName("MissionEnd", object: self )
                break;
            default:
                println("error in message-worker")
                break;
            }
        }
    }
    
    /**
    Saving the GPS data
    
    :param: gps data
    :param: log for reference
    */
    private func saveGPS(coordinates: NSString, log: Log){
        //seperate the gps data
        var gpsArray = coordinates.componentsSeparatedByString(",")
        
        // create new GPS database Entry
        var newGPS = NSEntityDescription.insertNewObjectForEntityForName("GPS", inManagedObjectContext: self.context!) as! GPS
        newGPS.id = statusCounter
        newGPS.valueX = (gpsArray[0] as! NSString).doubleValue
        newGPS.valueY = (gpsArray[1] as! NSString).doubleValue
        newGPS.valueZ = (gpsArray[2] as! NSString).doubleValue
        newGPS.date = NSDate()
        newGPS.log = log
        
        // save the Database
        self.context?.save(nil)
        
        var gps:GPS_Struct = GPS_Struct(x: newGPS.valueX , y: newGPS.valueY)
        
        // push the GPS Data into the gps array.
        gpsList.append(gps)
        altitudeList.append(Double(newGPS.valueZ))
    }
    
    /**
    Saving the batterystatus
    
    :param: battery data
    :param: log for reference
    */
    private func saveBattery(charge: NSString, log: Log){
        
        // create new Battery database Entry
        var newBattery = NSEntityDescription.insertNewObjectForEntityForName("Battery", inManagedObjectContext: self.context!) as! Battery
        var str: NSString = charge
        newBattery.value = str.doubleValue
        newBattery.date = NSDate()
        newBattery.id = statusCounter
        newBattery.log = log
        
        // save the Database
        self.context?.save(nil)
        
        // push the battery Data into the battery array.
        batteryList.append(Double(newBattery.value))
    }
    
    /**
    Saving the speed data
    
    :param: speed data
    :param: log for reference
    */
    private func saveSpeed(speed: NSString, log: Log){
        
        // create new Speed database Entry
        var newSpeed = NSEntityDescription.insertNewObjectForEntityForName("Speed", inManagedObjectContext: self.context!) as! Speed
        var str: String = speed as! String
        newSpeed.value = str.toInt()!
        newSpeed.date = NSDate()
        newSpeed.id = statusCounter
        newSpeed.log = log
        
        // save the Database
        self.context?.save(nil)
        
        // push the speed Data into the battery array.
        speedList.append(Double(newSpeed.value))
    }
    
    /**
    Broadcast about changes
    */
    func notify(){
        
        NSNotificationCenter.defaultCenter().postNotificationName("MissionUpdate", object: self )
    }
    
}
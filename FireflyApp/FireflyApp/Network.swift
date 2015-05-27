//
//  Network.swift
//  FireflyApp
//
//  Created by Alexander Zeier on 13.05.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// neue message liegt bereit (stop, mission etc.)
var newMessageType: String = "mission"
// close socket
var quit: String = "no"
// ist Drone in einer Mission?
var isDroneInMission: String = "no"

class Network {
    
    struct WaypointForSend {
        var height: NSNumber
        var longitude: NSNumber
        var latitude: NSNumber
        var speed: NSNumber
    }
    
    var buffersize1:Int = 100
    var ipAdress1:String = "127.0.0.1"
    var port1:Int = 50000
    
    var buffersize2:Int = 500000
    var ipAdress2:String = "127.0.0.1"
    var port2:Int = 60000
    
    // for database
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var gpsIndex: Int = 0
    //    var log?
    
    func startSender(){
        var server:TCPServer = TCPServer(addr: ipAdress1, port: port1)
        println("Server started")
        var (success,msg)=server.listen()
        if success{
            while true{
                if var client=server.accept(){
                    println("connection etablished")
                    messageControll(client: client)
                }else{
                    println("accept error")
                }
            }
        }else{
            println(msg)
        }
    }
    
    func messageControll(client c:TCPClient){
        while("no" == quit){
            switch(newMessageType){
            case "mission":
                sendMission(client: c)
                newMessageType = ""
                break;
            case "command":
                sendCommand(client: c, command: "stop")
                newMessageType = ""
                break;
            default:
                //verhindert ledeglich das blockieren von eingehendes nachrichten
                sendNothing(client: c)
            }
            messageRecieve(client: c)
        }
        c.close()
    }
    
    func messageRecieve(client c:TCPClient){
        var recMessage = c.read(buffersize1)
        var cleanMessage = NSString(bytes: recMessage!, length: recMessage!.count, encoding: NSUTF8StringEncoding)
        parser(message: cleanMessage!)
    }
    
    // parse data for app
    func parser(message msg: NSString){
        var msgArray = msg.componentsSeparatedByString(";")
        switch (msgArray[0] as! String) {
        case "gps":
            var gpsArray = msgArray[1].componentsSeparatedByString(",")
            var newGPS = NSEntityDescription.insertNewObjectForEntityForName("GPS", inManagedObjectContext: self.context!) as! GPS
            newGPS.id = gpsIndex
            newGPS.valueX = gpsArray[0] as! Double
            newGPS.valueY = gpsArray[1] as! Double
            newGPS.valueZ = gpsArray[2] as! Double
            self.context?.save(nil)
            gpsIndex++
            break;
        case "status":
            switch(String(msgArray[1] as! String)){
            case "missionover":
                isDroneInMission = "no"
                break;
            default:
                println("no such commandotype")
                break;
            }
            break;
        default:
            println("error in parser")
            break;
        }
    }
    
    // send for missiondata
    func sendMission(client c:TCPClient){
        // test waypoints
        var waypoints = [WaypointForSend]()
        waypoints.append(WaypointForSend(height: 11, longitude: 21, latitude: 31, speed: 41))
        waypoints.append(WaypointForSend(height: 12, longitude: 22, latitude: 32, speed: 42))
        waypoints.append(WaypointForSend(height: 13, longitude: 23, latitude: 33, speed: 43))
        waypoints.append(WaypointForSend(height: 14, longitude: 24, latitude: 34, speed: 44))
        for waypoint in waypoints{
            var message: String = "mission;" + waypoint.height.stringValue + "," + waypoint.latitude.stringValue + "," + waypoint.longitude.stringValue + "," + waypoint.speed.stringValue +  ";end"
            while(message.dataUsingEncoding(NSUTF8StringEncoding)?.length < buffersize1){
                message.append(" " as Character)
            }
            c.send(str: message)
        }
        var message: String = "mission;start;end"
        while(message.dataUsingEncoding(NSUTF8StringEncoding)?.length < buffersize1){
            message.append(" " as Character)
        }
        c.send(str: message)
    }
    
    // send for special commands such stop
    func sendCommand(client c:TCPClient, command com:String){
        var message: String = "command;" + com + ";end"
        while(message.dataUsingEncoding(NSUTF8StringEncoding)?.length < buffersize1){
            message.append(" " as Character)
        }
        c.send(str: message)
    }
    
    // send nothing for no waittime on clientside
    func sendNothing(client c:TCPClient){
        var message: String = "nothing;end"
        while(message.dataUsingEncoding(NSUTF8StringEncoding)?.length < buffersize1){
            message.append(" " as Character)
        }
        c.send(str: message)
    }
    
    func startReciever(){
        var server:TCPServer = TCPServer(addr: ipAdress2, port: port2)
        println("Server started")
        var (success,msg)=server.listen()
        if success{
            while true{
                if var client=server.accept(){
                    println("connection etablished")
                    pictureControll(client: client)
                }else{
                    println("accept error")
                }
            }
        }else{
            println(msg)
        }
    }
    
    func pictureControll(client c:TCPClient){
        while("no" == quit){
            messageRecieve(client: c)
        }
        c.close()
    }
    
    func pictureRecieve(client c:TCPClient){
        var recMessage = c.read(buffersize2)
        var cleanMessage = NSString(bytes: recMessage!, length: recMessage!.count, encoding: NSUTF8StringEncoding)
        //save picture and make database entry
    }
    
}
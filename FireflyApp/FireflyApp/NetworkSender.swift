//
//  Network.swift
//  FireflyApp
//
//  Created by Christian Adam on 13.05.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MapKit

class NetworkSender {
    
    var buffersize:Int = 100
    
    // for database
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var gpsIndex: Int = 0
    //    var log?
    
    func start(){
        fillingTestData()
        var server:TCPServer = TCPServer(addr: "127.0.0.1", port: 50000)
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
        while("yes" == holdSockets){
            switch(newMessageType){
            case "mission":
                sendMission(client: c)
                newMessageType = "old"
                break
            case "command":
                sendCommand(client: c)
                newMessageType = "old"
                break
            case "toggle":
                // ToDo: picture format
                newMessageType = "old"
                break
            default:
                break
            }
        }
        c.close()
    }
    
    // send for missiondata
    func sendMission(client c:TCPClient){
        for waypoint in waypointsForMission{
            var message: String = "mission;\(waypoint.coordinate.latitude),\(waypoint.coordinate.longitude),\(waypoint.height),\(waypoint.height);end"
            while(message.dataUsingEncoding(NSUTF8StringEncoding)?.length < buffersize){
                message.append(" " as Character)
            }
            c.send(str: message)
        }
        var message: String = "mission;start;end"
        while(message.dataUsingEncoding(NSUTF8StringEncoding)?.length < buffersize){
            message.append(" " as Character)
        }
        c.send(str: message)
    }
    
    // send for special commands such stop
    func sendCommand(client c:TCPClient){
        var message: String = "command;" + droneCommand + ";end"
        while(message.dataUsingEncoding(NSUTF8StringEncoding)?.length < buffersize){
            message.append(" " as Character)
        }
        c.send(str: message)
    }
    
    func fillingTestData(){
        var newAnnotation1 = Waypoint(coordinate: CLLocationCoordinate2D(latitude: 11, longitude: 12), waypointNumber: 1)
        var newAnnotation2 = Waypoint(coordinate: CLLocationCoordinate2D(latitude: 21, longitude: 22), waypointNumber: 2)
        var newAnnotation3 = Waypoint(coordinate: CLLocationCoordinate2D(latitude: 31, longitude: 32), waypointNumber: 3)
        var newAnnotation4 = Waypoint(coordinate: CLLocationCoordinate2D(latitude: 41, longitude: 42), waypointNumber: 4)
        waypointsForMission.insert(newAnnotation1, atIndex: waypointsForMission.count)
        waypointsForMission.insert(newAnnotation2, atIndex: waypointsForMission.count)
        waypointsForMission.insert(newAnnotation3, atIndex: waypointsForMission.count)
        waypointsForMission.insert(newAnnotation4, atIndex: waypointsForMission.count)
    }
    
}
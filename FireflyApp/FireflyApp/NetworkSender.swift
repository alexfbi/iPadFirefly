//
//  Network.swift
//  FireflyApp
//
//  Created by Christian Adam on 13.05.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation

class NetworkSender {
    
    var buffersize:Int = 100
    var client:TCPClient?
    
    func start(){
        var server:TCPServer = TCPServer(addr: ip, port: 60000)
        println("Server started")
        var (success,msg)=server.listen()
        if success{
            client = server.accept()
            if client != nil {
                println("connection etablished")
                messageControll()
            }else{
                println("accept error")
            }
        }else{
            println(msg)
        }
    }
    
    func messageControll(){
        while("yes" == holdSockets){
            switch(newMessageType){
            case "mission":
                sendMission()
                newMessageType = "old"
                break
            case "command":
                sendCommand()
                newMessageType = "old"
                break
            default:
                break
            }
        }
        self.client!.close()
    }
    
    func sendMission(){
        for waypoint in waypointsForMission{
            var message: String = "mission;\(waypoint.coordinate.latitude),\(waypoint.coordinate.longitude),\(waypoint.speed),\(waypoint.height);end"
            while(message.dataUsingEncoding(NSUTF8StringEncoding)?.length < buffersize){
                message.append(" " as Character)
            }
            self.client!.send(str: message)
        }
        var message: String = "mission;start;end"
        while(message.dataUsingEncoding(NSUTF8StringEncoding)?.length < buffersize){
            message.append(" " as Character)
        }
        self.client!.send(str: message)
        counter = 0
        pictureCounter = 0
        isDroneInMission = "yes"
    }
    
    func sendCommand(){
        var message: String = "command;" + droneCommand + ";end"
        while(message.dataUsingEncoding(NSUTF8StringEncoding)?.length < buffersize){
            message.append(" " as Character)
        }
        self.client!.send(str: message)
    }
    
    func sendWaypoints(waypoints: [Waypoint]){
        // TODO: 
    }
    
}
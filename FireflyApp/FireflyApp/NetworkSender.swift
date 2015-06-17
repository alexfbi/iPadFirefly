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
    
    func start(ip: String){
        var server:TCPServer = TCPServer(addr: ip, port: 60000)
        println("Server started")
        var (success,msg)=server.listen()
        if success{
            self.client = server.accept()
            if client != nil {
                println("connection etablished")
            }else{
                println("accept error")
            }
        }else{
            println(msg)
        }
    }
    
    func sendMission(waypointsForMission: [Waypoint]){
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
    }
    
    func sendCommand(message: String){
        var message: String = "command;" + message + ";end"
        while(message.dataUsingEncoding(NSUTF8StringEncoding)?.length < buffersize){
            message.append(" " as Character)
        }
        self.client!.send(str: message)
    }
    
}
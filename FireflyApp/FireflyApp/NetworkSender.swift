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
    
    func start(){
        var server:TCPServer = TCPServer(addr: "192.168.1.30", port: 60000)
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
            default:
                break
            }
        }
        c.close()
    }
    
    func sendMission(client c:TCPClient){
        for waypoint in waypointsForMission{
            var message: String = "mission;\(waypoint.coordinate.latitude),\(waypoint.coordinate.longitude),\(waypoint.speed),\(waypoint.height);end"
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
        counter = 0
        isDroneInMission = "yes"
    }
    
    func sendCommand(client c:TCPClient){
        var message: String = "command;" + droneCommand + ";end"
        while(message.dataUsingEncoding(NSUTF8StringEncoding)?.length < buffersize){
            message.append(" " as Character)
        }
        c.send(str: message)
    }
    
}
//
// NetworkSender.swift
// FireflyApp
//
// Created by Christian Adam on 13.05.15.
// Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation

class NetworkSender {
    
    var buffersize:Int = 100
    var client:TCPClient?
    
    func start(ip: String){
        var server:TCPServer = TCPServer(ip: ip, port: 60000)
        println("Server started")
        var (success, msg)=server.listen()
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
            var message: String = "mission;\(waypoint.coordinate.latitude), \(waypoint.coordinate.longitude), \(waypoint.speed), \(waypoint.height);end"
            while(message.dataUsingEncoding(NSUTF8StringEncoding)?.length < buffersize){
                message.append(" " as Character)
            }
            if client != nil {
                self.client!.send(message)
            }
        }
        var message: String = "mission;start;end"
        while(message.dataUsingEncoding(NSUTF8StringEncoding)?.length < buffersize){
            message.append(" " as Character)
        }
        if client != nil {
            self.client!.send(message)
        }
    }
    
    func sendCommand(message: String){
        var message: String = "command;" + message + ";end"
        while(message.dataUsingEncoding(NSUTF8StringEncoding)?.length < buffersize){
            message.append(" " as Character)
        }
        if client != nil {
            self.client!.send(message)
        }
    }
    
    func sendToggle(message: String){
        // parameter: l, r
        // example: 0, 1
        // example: 1, 1
        var message: String = "toggle;" + message + ";end"
        while(message.dataUsingEncoding(NSUTF8StringEncoding)?.length < buffersize){
            message.append(" " as Character)
        }
        if client != nil {
            self.client!.send(message)
        }
    }
    
}
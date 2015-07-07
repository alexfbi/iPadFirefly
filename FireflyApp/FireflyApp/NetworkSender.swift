//
// NetworkSender.swift
// FireflyApp
//
// Created by Christian Adam on 13.05.15.
// Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation

/**
This class contains the controll for use the ServerClasses. The Class initialize the connection to the client and controll the send of Data to the Client.
*/
class NetworkSender {
    
    // MARK: - Variables
    
    var buffersize:Int = 100
    var client:TCPcommunication?
    
    /**
    This function is starting the communication between a TCPServer object and a TCPcommunication object.
    
    :param: The server ip for listen for a incomming connection establishment from a client.
    */
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
    
    /**
    This function is parsing and sending the missiondata to the client
    
    :params: Array of Missiondata
    */
    func sendMission(waypointsForMission: [Waypoint]){
        for waypoint in waypointsForMission{
            
            // parsing the Missiondata into a string and appending space characters to fill the buffersize for the client
            var message: String = "mission;\(waypoint.coordinate.latitude), \(waypoint.coordinate.longitude), \(waypoint.speed), \(waypoint.height);end"
            while(message.dataUsingEncoding(NSUTF8StringEncoding)?.length < buffersize){
                message.append(" " as Character)
            }
            
            if client != nil {
                self.client!.send(message)
            }
        }
        
        // parsing the mission start message into a string and appending space characters to fill the buffersize for the client
        var message: String = "mission;start;end"
        while(message.dataUsingEncoding(NSUTF8StringEncoding)?.length < buffersize){
            message.append(" " as Character)
        }
        
        if client != nil {
            self.client!.send(message)
        }
    }
    
    /**
    This function is parsing and sending commands such as the misisonstop message to the client
    
    :params: message for send to the client
    */
    func sendCommand(message: String){
        
        // parsing the message into a command message for the client and appending space characters to fill the buffersize for the client
        var message: String = "command;" + message + ";end"
        while(message.dataUsingEncoding(NSUTF8StringEncoding)?.length < buffersize){
            message.append(" " as Character)
        }
        if client != nil {
            self.client!.send(message)
        }
    }
    
    /**
    This function is parsing and sending the command for toggle the camera
    
    :params: command for toggle the camera
    */
    func sendToggle(message: String){
        // parameter: l, r
        // example: 0, 1
        // example: 1, 1
        // parsing the message into a toggle message for the client and appending space characters to fill the buffersize for the client
        var message: String = "toggle;" + message + ";end"
        while(message.dataUsingEncoding(NSUTF8StringEncoding)?.length < buffersize){
            message.append(" " as Character)
        }
        if client != nil {
            self.client!.send(message)
        }
    }
    
}
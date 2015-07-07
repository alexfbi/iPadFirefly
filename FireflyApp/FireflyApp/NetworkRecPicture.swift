//
// NetworkRecPicture.swift
// FireflyApp
//
// Created by Christian Adam on 27.05.15.
// Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation
import UIKit
import CoreData

/**
This class contains the controll for use the ServerClasses. The Class initialize the connection to the client and controll the receiving of the pictures and the picture data. The Class has a funciton for parsing this Informations and save the data into the Database and on the filesystem.
*/

class NetworkRecPicture {
    
    // MARK: - Variables
    
    var buffersize:Int = 200704
    var client:TCPcommunication?
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    // array for the view
    var imageList:[UIImage] = [UIImage]()
    
    /**
    This function is starting the communication between a TCPServer object and a TCPcommunication object.
    
    :param: The server ip for listen for a incomming connection establishment from a client.
    */
    func start(ip: String){
        var server:TCPServer = TCPServer(ip: ip, port: 51000)
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
    This function is receiving, parsing and saving the picture data from a client
    */
    func receiveAndSavePicture(){
        
        if(client == nil){
            //println("Fehler client")
            return;
        }
        
        // getting the youngest Log entry, for saving the data proper to the youngest log, from the database
        let fetchRequest = NSFetchRequest(entityName: "Log")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        fetchRequest.fetchLimit = 1
        var log: Log = (context?.executeFetchRequest(fetchRequest, error: nil) as! [Log])[0]
        
        if (client != nil) {
            var packet:[UInt8] = []
            
            // reading the data in packets
            for(var i = 0; i<(buffersize/1024); i++){
                packet = packet + client!.read(1024)!
            }
            
            if packet.count > 0 {
                var posOfDelimiter:Int = 0
                
                // check for position of delimiter (;). this is the size of the picture
                for (var i = 1; i<packet.count; i++) {
                    if ( 59 == packet[i-1]){
                        posOfDelimiter = i
                        break;
                    }
                }
                
                // convert data before the delimiter into a NSString. This is the size of the picture.
                var size = (NSString(bytes: packet, length: posOfDelimiter-1, encoding: NSUTF8StringEncoding) as! String).toInt()!
                
                if (size > 0 )
                {
                    // remove the appended zeros (its appended on the clientsite)
                    for (var i = 1; i<=(buffersize - posOfDelimiter - size); i++){
                        packet.removeLast()
                    }
                    
                    // remove the size plus delimiter
                    for (var i = 1; i<=posOfDelimiter; i++){
                        packet.removeAtIndex(0)
                    }
                    
                    // getting the path for saving the picture into the filesystem.
                    let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
                        .UserDomainMask, true)
                    let docsDir = dirPaths[0] as! String
                    let newDir = docsDir.stringByAppendingPathComponent("/Images/\(log.id)")
                    let imageName = "/\(pictureCounter).jpg"
                    let pathToFile = newDir.stringByAppendingString(imageName)
                    
                    
                    // creating the path for saving the picture into the filesystem.
                    let fileManager = NSFileManager.defaultManager()
                    fileManager.createDirectoryAtPath(newDir, withIntermediateDirectories: true, attributes: nil, error: nil)
                    
                    // create the picture with the picture data from the client and saving into the filesystem.
                    var data = NSData(bytes: packet, length: packet.count)
                    var image = UIImage(data: data)
                    var file = UIImageJPEGRepresentation(image, 1.0)
                    file.writeToFile(pathToFile, atomically: true)
                    
                    // create new Picture database Entry. Its for the Informations about the Picture.
                    var newPicture = NSEntityDescription.insertNewObjectForEntityForName("Picture", inManagedObjectContext: self.context!) as! Picture
                    newPicture.id = pictureCounter
                    newPicture.name = log.name
                    newPicture.path = pathToFile
                    newPicture.log = log
        
                    // save the Database
                    self.context?.save(nil)
                    
                    pictureCounter++
                    
                    // push the Image into the Image array. Its for the View.
                    imageList.append(image!)
                    
                    //clear packet
                    packet.removeAll(keepCapacity: false)
                
                    //send Broadcast about change
                    notify()
                }
            }
        }
    }
    
    /**
    Broadcast about changes
    */
    func notify(){
        NSNotificationCenter.defaultCenter().postNotificationName("MissionUpdate", object: self )
    }
    
}
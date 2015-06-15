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

class NetworkRecPicture {
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    func start(){
        var server:TCPServer = TCPServer(addr: ip, port: 50001)
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
            var recSize = c.read(100)
            var recMessage = c.read((NSString(bytes: recSize!, length: recSize!.count, encoding: NSUTF8StringEncoding) as! String).toInt()!)
            parser(message: NSString(bytes: recMessage!, length: recMessage!.count, encoding: NSUTF8StringEncoding)!)
        }
        c.close()
    }
    
    func parser(message msg: NSString){
        var msgArray = msg.componentsSeparatedByString(";")
        
        let fetchRequest = NSFetchRequest(entityName: "Log")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        fetchRequest.fetchLimit = 1
        var log: Log = (context?.executeFetchRequest(fetchRequest, error: nil) as! [Log])[0]
        
        switch (msgArray[0] as! String) {
        case "picture":
            let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
                .UserDomainMask, true)
            let docsDir = dirPaths[0] as! String
            let newDir = docsDir.stringByAppendingPathComponent("/Images/\(log.id)")
            let imageName = "/\(pictureCounter).png"
            let pathToFile = newDir.stringByAppendingString(imageName)
            
            let fileManager = NSFileManager.defaultManager()
            fileManager.createDirectoryAtPath(newDir, withIntermediateDirectories: true, attributes: nil, error: nil)
            
            var image = UIImage(data: msgArray[1] as! NSData)
            var file = UIImagePNGRepresentation(image)
            file.writeToFile(pathToFile, atomically: true)
            
            var newPicture = NSEntityDescription.insertNewObjectForEntityForName("Picture", inManagedObjectContext: self.context!) as! Picture
            newPicture.id = (msgArray[2] as! String).toInt()!
            newPicture.name = log.name
            newPicture.path = pathToFile
            newPicture.log = log
            self.context?.save(nil)
            break;
        default:
            println("error in parser")
            break;
        }
        pictureCounter++
    }
    
}
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
    
    var buffersize:Int = 100000
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    func start(){
        var server:TCPServer = TCPServer(addr: "192.168.1.30", port: 50001)
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
            var recMessage = c.read(buffersize)
            var cleanedMessage = NSString(bytes: recMessage!, length: recMessage!.count, encoding: NSUTF8StringEncoding)
            parser(message: cleanedMessage!)
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
            //ToDo: save picture
            let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
                .UserDomainMask, true)
            
            let docsDir = dirPaths[0] as! String
            let newDir = docsDir.stringByAppendingPathComponent("/Images/\(log.id)")
            
            
            // bild einlesen
//            var image =  UIImage(named: imageNameTmp)
            
            
//            let imageName = "/\(imageNameTmp).png"
            
            
//            NSLog("%@", "ImageLogname: \(imageName)")
            
//            let pathToFile = newDir.stringByAppendingString( imageName)
            
            
            
            var newPicture = NSEntityDescription.insertNewObjectForEntityForName("Picture", inManagedObjectContext: self.context!) as! Picture
            var str: String = msgArray[2] as! String
            newPicture.id = str.toInt()!
            newPicture.name = log.name
            newPicture.path = ""
            newPicture.log = log
            self.context?.save(nil)
            break;
        default:
            println("error in parser")
            break;
        }
    }
    
    
    private func writeImagesToFolder(log: Log){
        
        let fileManager = NSFileManager.defaultManager()
        
        
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        let docsDir = dirPaths[0] as! String
        let newDir = docsDir.stringByAppendingPathComponent("/Images/\(log.id)")
        
        var error: NSError?
        
        
        if !fileManager.createDirectoryAtPath(newDir, withIntermediateDirectories: true, attributes: nil, error: &error) {
            
            println("Failed to create dir: \(error!.localizedDescription)")
        }
        
        
//        var image =  UIImage(named: imageNameTmp)
        
        
//        let imageName = "/\(imageNameTmp).png"
        
        
//        NSLog("%@", "Logname: \(imageName)")
        
//        let pathToFile = newDir.stringByAppendingString( imageName)
        
        
//        saveFileToDocumentsFolder( image!, pathToFile: pathToFile)
    }
    
    private   func saveFileToDocumentsFolder(image: UIImage, pathToFile: String){
        let fileManager = NSFileManager.defaultManager()
        
        
        if (!fileManager.fileExistsAtPath(pathToFile) ) {
            
            var file = UIImagePNGRepresentation(image)
            
            let fileToBeWritten = file.writeToFile(pathToFile, atomically: true)
            
            
            NSLog("%@", "file save true: \(fileToBeWritten)")
            
        }else
        {
            NSLog("%@", "file save false: \(pathToFile) ")
            
        }
        
        
    }
}
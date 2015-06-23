//
//  NetworkRecPicture.swift
//  FireflyApp
//
//  Created by Christian Adam on 27.05.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class NetworkRecPicture {
    
    var buffersize:Int = 200000
    var imageList:[UIImage] = [UIImage]()
    var client:TCPClient?
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    func start(ip: String){
        var server:TCPServer = TCPServer(addr: ip, port: 51000)
        println("Server started")
        var (success,msg)=server.listen()
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
    
    func receiveAndSavePicture(){
        let fetchRequest = NSFetchRequest(entityName: "Log")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        fetchRequest.fetchLimit = 1
        var log: Log = (context?.executeFetchRequest(fetchRequest, error: nil) as! [Log])[0]
        
        var packet:[UInt8] = client!.read(buffersize)!
        
        if packet.count > 0 {
            var posOfDelimiter:Int = 0
            
            var packetTemp:[UInt8] = packet
            for (var i = 1; i<packetTemp.count; i++) {
                var sign:UInt8 = packetTemp.removeAtIndex(0)
                if ( 59 == sign){
                    posOfDelimiter = i
                    break;
                }
            }
            
            var size = (NSString(bytes: packet, length: posOfDelimiter-1, encoding: NSUTF8StringEncoding) as! String).toInt()!
            
            for (var i = 0; i<(buffersize-posOfDelimiter-size); i++){
                packet.removeLast()
            }
            
            
            for (var i = 0; i<posOfDelimiter; i++){
                packet.removeAtIndex(0)
            }
            
            let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
                .UserDomainMask, true)
            let docsDir = dirPaths[0] as! String
            let newDir = docsDir.stringByAppendingPathComponent("/Images/\(log.id)")
            let imageName = "/\(pictureCounter).png"
            let pathToFile = newDir.stringByAppendingString(imageName)
            
            let fileManager = NSFileManager.defaultManager()
            fileManager.createDirectoryAtPath(newDir, withIntermediateDirectories: true, attributes: nil, error: nil)
            
            var image = UIImage( data: NSData(bytes: packet, length: packet.count))
            var file = UIImagePNGRepresentation(image)
            file.writeToFile(pathToFile, atomically: true)
            
            var newPicture = NSEntityDescription.insertNewObjectForEntityForName("Picture", inManagedObjectContext: self.context!) as! Picture
            newPicture.id = pictureCounter
            newPicture.name = log.name
            newPicture.path = pathToFile
            newPicture.log = log
            self.context?.save(nil)
            
            pictureCounter++
            
            imageList.append(image!)
            packet.removeAll(keepCapacity: false)
            notify()
        }
    }
    
    func notify(){
        NSNotificationCenter.defaultCenter().postNotificationName("MissionUpdate", object: self )
    }
    
}
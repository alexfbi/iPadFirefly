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
    
    var buffersize:Int = 200704
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
        
        if (client != nil) {
        
            var packet:[UInt8] = client!.read(buffersize)!
            
            if packet.count > 0 {
                var posOfDelimiter:Int = 0
                
                for (var i = 1; i<packet.count; i++) {
                    if ( 59 == packet[i-1]){
                        posOfDelimiter = i
                        break;
                    }
                }
                
                var size = (NSString(bytes: packet, length: posOfDelimiter-1, encoding: NSUTF8StringEncoding) as! String).toInt()!
                
                if (size > 0 )
                {
                    for (var i = 1; i<=(buffersize - posOfDelimiter - size); i++){
                        packet.removeLast()
                    }
                    
                    for (var i = 1; i<=posOfDelimiter; i++){
                        packet.removeAtIndex(0)
                    }
                    
                    let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
                        .UserDomainMask, true)
                    let docsDir = dirPaths[0] as! String
                    let newDir = docsDir.stringByAppendingPathComponent("/Images/\(log.id)")
                    let imageName = "/\(pictureCounter).jpg"
                    let pathToFile = newDir.stringByAppendingString(imageName)
                    
                    let fileManager = NSFileManager.defaultManager()
                    fileManager.createDirectoryAtPath(newDir, withIntermediateDirectories: true, attributes: nil, error: nil)
                    
                    var data = NSData(bytes: packet, length: packet.count)
                    var image = UIImage(data: data)
                    var file = UIImageJPEGRepresentation(image, 1.0)
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
        }
    }
    
    func notify(){
        NSNotificationCenter.defaultCenter().postNotificationName("MissionUpdate", object: self )
    }
    
}